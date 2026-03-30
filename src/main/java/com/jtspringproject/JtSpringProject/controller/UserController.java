package com.jtspringproject.JtSpringProject.controller;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.jtspringproject.JtSpringProject.dao.OrderRepository;
import com.jtspringproject.JtSpringProject.models.Cart;
import com.jtspringproject.JtSpringProject.models.CartProduct;
import com.jtspringproject.JtSpringProject.models.Order;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.cartService;
import com.jtspringproject.JtSpringProject.services.productService;
import com.jtspringproject.JtSpringProject.services.userService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

    private final userService userService;
    private final productService productService;
    private final cartService cartService;
    private final OrderRepository orderRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    public UserController(OrderRepository orderRepository,userService userService, productService productService, cartService cartService) {
        this.userService = userService;
        this.productService = productService;
        this.cartService = cartService;
        this.orderRepository = orderRepository;
    }

    // ================= 1. AUTHENTICATION & SESSION =================

    @GetMapping("/login")
    public ModelAndView userlogin(@RequestParam(required = false) String error) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken)) {
            return new ModelAndView("redirect:/");
        }

        ModelAndView mv = new ModelAndView("userLogin");
        if ("true".equals(error)) {
            mv.addObject("msg", "Invalid username or password.");
        }
        return mv;
    }

    @PostMapping("/login/process")
    public String loginProcess(@RequestParam String username, @RequestParam String password, HttpServletRequest request) {
        User user = userService.getUserByUsername(username);
        if (user != null && passwordEncoder.matches(password.trim(), user.getPassword())) {
            UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                user.getUsername(), null, Collections.singletonList(new SimpleGrantedAuthority(user.getRole()))
            );
            SecurityContextHolder.getContext().setAuthentication(auth);
            request.getSession(true).setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
            return "redirect:/";
        }
        return "redirect:/login?error=true";
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        SecurityContextHolder.clearContext();
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        return "redirect:/login?logout=true";
    }

    // ================= 2. DISCOVERY (HOME & SEARCH) =================

    @GetMapping("/")
    public ModelAndView indexPage() {
        ModelAndView mView = new ModelAndView("index");
        String username = "Guest";
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken)) {
            username = auth.getName();
        }
        mView.addObject("username", username);
        mView.addObject("products", this.productService.getProducts());
        return mView;
    }

    @GetMapping("/shop/search")
    public ModelAndView searchProducts(@RequestParam(name = "query", required = false) String query) {
        ModelAndView mView = new ModelAndView("index");
        List<Product> allProducts = this.productService.getProducts();
        if (query != null && !query.isEmpty()) {
            List<Product> filtered = allProducts.stream()
                .filter(p -> p.getName().toLowerCase().contains(query.toLowerCase()) || 
                             p.getCategory().getName().toLowerCase().contains(query.toLowerCase()))
                .collect(Collectors.toList());
            mView.addObject("products", filtered);
        } else {
            mView.addObject("products", allProducts);
        }
        return mView;
    }

    // ================= 3. CART OPERATIONS =================

    @GetMapping("/cart/add/{id}")
    public String addToCart(@PathVariable int id) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || auth instanceof AnonymousAuthenticationToken) {
            return "redirect:/login";
        }

        User user = userService.getUserByUsername(auth.getName());
        Product product = productService.getProduct((long) id);
        
        // Use the cartService logic to find/create cart and link product
        Cart cart = cartService.getCartByUserId(user.getId());
        cartService.addItemToCart(cart, product);

        return "redirect:/cart/view";
    }

    @GetMapping("/cart/view")
    public ModelAndView viewCart() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || auth instanceof AnonymousAuthenticationToken) {
            return new ModelAndView("redirect:/login");
        }

        User user = userService.getUserByUsername(auth.getName());
        Cart cart = cartService.getCartByUserId(user.getId());
        List<CartProduct> cartItems = cartService.getCartProducts(cart);

        ModelAndView mv = new ModelAndView("cart");
        mv.addObject("cartItems", cartItems);
        mv.addObject("total", cartItems.stream().mapToInt(i -> i.getProduct().getPrice()).sum());
        return mv;
    }

    // ================= 4. PROFILE & ORDERS =================

    @GetMapping("/user/profile")
    public String profileDisplay(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken)) {
            model.addAttribute("user", userService.getUserByUsername(auth.getName()));
            return "updateProfile";
        }
        return "redirect:/login";
    }
    
    @GetMapping("/cart/checkout")
    public ModelAndView checkoutPage() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.getUserByUsername(auth.getName());
        Cart cart = cartService.getCartByUserId(user.getId());
        List<CartProduct> items = cartService.getCartProducts(cart);

        int total = items.stream().mapToInt(i -> i.getProduct().getPrice()).sum();

        ModelAndView mv = new ModelAndView("checkout");
        mv.addObject("total", total);
        mv.addObject("user", user);
        return mv;
    }

    @PostMapping("/cart/placeOrder")
    public String placeOrder(@RequestParam String address, @RequestParam String pincode, 
                             @RequestParam String contact, @RequestParam String paymentMethod) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.getUserByUsername(auth.getName());
        Cart cart = cartService.getCartByUserId(user.getId());
        List<CartProduct> items = cartService.getCartProducts(cart);

        // 1. Create and Save Order
        Order order = new Order();
        order.setCustomer(user);
        order.setAddress(address);
        order.setPincode(pincode);
        order.setContact(contact);
        order.setPaymentMethod(paymentMethod);
        order.setTotalAmount(items.stream().mapToInt(i -> i.getProduct().getPrice()).sum());
        
         orderRepository.save(order); // Assuming you create a simple OrderRepository

        // 2. Clear Cart after successful order
         cartService.clearCart(cart); 

        return "redirect:/user/orders?success=true";
    }

    @GetMapping("/user/orders")
    public ModelAndView getUserOrders(@RequestParam(required = false) String success) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || auth instanceof AnonymousAuthenticationToken) {
            return new ModelAndView("redirect:/login");
        }

        User user = userService.getUserByUsername(auth.getName());
        
        // For a real project, you would fetch from an OrderRepository. 
        // For now, let's show the "Mandai Delivery" status page.
        ModelAndView mv = new ModelAndView("uproduct"); // Matches uproduct.jsp
        mv.addObject("username", user.getUsername());
        
        if ("true".equals(success)) {
            mv.addObject("msg", "Order Placed Successfully! Our delivery partner is heading to your address in Dharashiv.");
        }
        
        return mv;
    }
}