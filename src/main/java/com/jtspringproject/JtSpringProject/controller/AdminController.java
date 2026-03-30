package com.jtspringproject.JtSpringProject.controller;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.jtspringproject.JtSpringProject.dao.OrderRepository;
import com.jtspringproject.JtSpringProject.models.Category;
import com.jtspringproject.JtSpringProject.models.Order;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.categoryService;
import com.jtspringproject.JtSpringProject.services.productService;
import com.jtspringproject.JtSpringProject.services.userService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private userService userService;

    @Autowired
    private categoryService categoryService;

    @Autowired
    private productService productService;
    
    @Autowired
    private OrderRepository orderRepository;

    // ================= MANUAL LOGIN PROCESSING =================

    @PostMapping("/adminloginvalidate")
    public String adminLoginValidate(@RequestParam String username, 
                                     @RequestParam String password, 
                                     HttpServletRequest request) {
        
        System.out.println("DEBUG: Admin Login attempt for: " + username);
        User user = userService.getUserByEmail(username);

        // Check if user exists and has the ADMIN role
        if (user != null && "ROLE_ADMIN".equals(user.getRole())) {
            
            System.out.println("DEBUG: Admin DB Password: " + user.getPassword());

            // 🔥 PLAIN TEXT COMPARISON (No Encoder)
            if (password.equals(user.getPassword())) {
                System.out.println("DEBUG: Admin Password match SUCCESS.");

                UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                    user.getUsername(), 
                    null, 
                    Collections.singletonList(new SimpleGrantedAuthority(user.getRole()))
                );

                // Set Security Context
                SecurityContextHolder.getContext().setAuthentication(auth);
                
                // 🔥 CRITICAL: Bind to Session so the login persists
                HttpSession session = request.getSession(true);
                session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
                
                return "redirect:/admin/Dashboard";
            }
        }
        
        System.out.println("DEBUG: Admin Login FAILED.");
        return "redirect:/admin/adminLogin?error=true";
    }

    // ================= DASHBOARD & LOGIN PAGE =================

    @GetMapping("/adminLogin")
    public ModelAndView adminlogin(@RequestParam(required = false) String error) {
        ModelAndView mv = new ModelAndView("adminlogin");
        if ("true".equals(error)) {
            mv.addObject("msg", "Invalid Admin credentials");
        }
        return mv;
    }

    @GetMapping({"", "/", "/Dashboard"})
    public ModelAndView adminHome() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        // Manual Security Check: Redirect if not authenticated as Admin
        if (auth == null || !auth.isAuthenticated() || auth.getAuthorities().stream().noneMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
             return new ModelAndView("redirect:/admin/adminLogin");
        }

        ModelAndView mv = new ModelAndView("adminHome");
        mv.addObject("admin", auth.getName());
        return mv;
    }

    @GetMapping("/index")
    public String index(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) return "redirect:/admin/adminLogin";
        
        model.addAttribute("username", auth.getName());
        return "index";
    }

    // ================= CATEGORY MANAGEMENT =================

    @GetMapping("/categories")
    public ModelAndView getCategories() {
        ModelAndView mv = new ModelAndView("categories");
        List<Category> categories = categoryService.getCategories();
        mv.addObject("categories", categories);
        return mv;
    }

    @PostMapping("/categories")
    public String addCategory(@RequestParam("categoryname") String name) {
        categoryService.addCategory(name);
        return "redirect:/admin/categories";
    }

    @GetMapping("/categories/delete")
    public String deleteCategory(@RequestParam("id") Long id) {
        categoryService.deleteCategory(id);
        return "redirect:/admin/categories";
    }

    @GetMapping("/categories/update")
    public String updateCategory(@RequestParam("categoryid") Long id,
                                 @RequestParam("categoryname") String name) {
        categoryService.updateCategory(id, name);
        return "redirect:/admin/categories";
    }

    // ================= PRODUCT MANAGEMENT =================

    @GetMapping("/products")
    public ModelAndView getProducts() {
        ModelAndView mv = new ModelAndView("products");
        List<Product> products = productService.getProducts();

        if (products.isEmpty()) {
            mv.addObject("msg", "No products available");
        } else {
            mv.addObject("products", products);
        }
        return mv;
    }

    @GetMapping("/products/add")
    public ModelAndView addProductPage() {
        ModelAndView mv = new ModelAndView("productsAdd");
        mv.addObject("categories", categoryService.getCategories());
        return mv;
    }

    @PostMapping("/products/add")
    public String addProduct(
            @RequestParam String name,
            @RequestParam Long categoryid,
            @RequestParam int price,
            @RequestParam int weight,
            @RequestParam int quantity,
            @RequestParam String description,
            @RequestParam String productImage) {

        Category category = categoryService.getCategory(categoryid);

        Product product = new Product();
        product.setName(name);
        product.setCategory(category);
        product.setPrice(price);
        product.setWeight(weight);
        product.setQuantity(quantity);
        product.setDescription(description);
        product.setImage(productImage);

        productService.addProduct(product);
        return "redirect:/admin/products";
    }

    @GetMapping("/products/update/{id}")
    public ModelAndView updateProductPage(@PathVariable Long id) {
        ModelAndView mv = new ModelAndView("productsUpdate");
        mv.addObject("product", productService.getProduct(id));
        mv.addObject("categories", categoryService.getCategories());
        return mv;
    }

    @PostMapping("/products/update/{id}")
    public String updateProduct(
            @PathVariable Long id,
            @RequestParam String name,
            @RequestParam Long categoryid,
            @RequestParam int price,
            @RequestParam int weight,
            @RequestParam int quantity,
            @RequestParam String description,
            @RequestParam String productImage) {

        Category category = categoryService.getCategory(categoryid);

        Product product = new Product();
        product.setName(name);
        product.setCategory(category);
        product.setPrice(price);
        product.setWeight(weight);
        product.setQuantity(quantity);
        product.setDescription(description);
        product.setImage(productImage);

        productService.updateProduct(id, product);
        return "redirect:/admin/products";
    }

    @GetMapping("/products/delete")
    public String deleteProduct(@RequestParam Long id) {
        productService.deleteProduct(id);
        return "redirect:/admin/products";
    }

    // ================= CUSTOMERS =================

    @GetMapping("/customers")
    public ModelAndView getCustomers() {
        ModelAndView mv = new ModelAndView("displayCustomers");
        mv.addObject("customers", userService.getUsers());
        return mv;
    }

    // ================= PROFILE & LOGOUT =================

    @GetMapping("/profileDisplay")
    public String profileDisplay(Model model) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userService.getUserByEmail(username);
        model.addAttribute("user", user);
        return "updateProfile";
    }

    @PostMapping("/updateuser")
    public String updateUser(@ModelAttribute User updatedUser, HttpServletRequest request) {
        User existing = userService.getUserByEmail(updatedUser.getUsername());

        if (existing != null) {
            existing.setEmail(updatedUser.getEmail());
            existing.setAddress(updatedUser.getAddress());
            userService.addUser(existing); // Saves plain text

            UsernamePasswordAuthenticationToken newAuth = new UsernamePasswordAuthenticationToken(
                    existing.getUsername(),
                    null,
                    Collections.singletonList(new SimpleGrantedAuthority(existing.getRole()))
            );
            SecurityContextHolder.getContext().setAuthentication(newAuth);
            request.getSession().setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
        }
        return "redirect:/admin/index";
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        SecurityContextHolder.clearContext();
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/admin/adminLogin?logout";
    }
 // ================= ORDER MANAGEMENT (NEW) =================

    @GetMapping("/orders")
    public ModelAndView getAllOrders() {
        ModelAndView mv = new ModelAndView("adminOrders");
        // Fetch all orders from the database
        List<Order> allOrders = orderRepository.findAll();
        
        // Sort them manually if your repository doesn't have a sorted method
        Collections.reverse(allOrders); 

        mv.addObject("orders", allOrders);
        return mv;
    }

    @PostMapping("/orders/updateStatus")
    public String updateOrderStatus(@RequestParam int orderId, @RequestParam String status) {
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order != null) {
            order.setStatus(status);
            orderRepository.save(order);
        }
        return "redirect:/admin/orders?statusUpdated=true";
    }

    @GetMapping("/orders/delete/{id}")
    public String deleteOrder(@PathVariable int id) {
        orderRepository.deleteById(id);
        return "redirect:/admin/orders?deleted=true";
    }
}