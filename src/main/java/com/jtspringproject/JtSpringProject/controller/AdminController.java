package com.jtspringproject.JtSpringProject.controller;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
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

    // 🛡️ Central Security Helper
    private boolean isAdminAuthenticated() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth != null && auth.isAuthenticated() && 
               auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
    }

    // ================= MANUAL LOGIN PROCESSING =================

    @PostMapping("/adminloginvalidate")
    public String adminLoginValidate(@RequestParam String username, 
                                     @RequestParam String password, 
                                     HttpServletRequest request) {
        
        System.out.println("DEBUG: Admin Login attempt for: " + username);
        User user = userService.getUserByEmail(username);

        if (user != null && "ROLE_ADMIN".equals(user.getRole())) {
            if (password.equals(user.getPassword())) {
                UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                    user.getUsername(), 
                    null, 
                    Collections.singletonList(new SimpleGrantedAuthority(user.getRole()))
                );

                SecurityContextHolder.getContext().setAuthentication(auth);
                HttpSession session = request.getSession(true);
                session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
                
                return "redirect:/admin/Dashboard";
            }
        }
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
    	// Fix 1: Security check must return a ModelAndView object
        if (!isAdminAuthenticated()) {
            return new ModelAndView("403"); // Or "adminLogin"
        }
        ModelAndView mv = new ModelAndView("adminHome");
        mv.addObject("admin", SecurityContextHolder.getContext().getAuthentication().getName());
        return mv;
    }

    @GetMapping("/index")
    public String index(Model model) {
        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";
        
        model.addAttribute("username", SecurityContextHolder.getContext().getAuthentication().getName());
        return "index";
    }

    // ================= CATEGORY MANAGEMENT =================

    @GetMapping("/categories")
    public ModelAndView getCategories() {
    	// Fix 1: Security check must return a ModelAndView object
        if (!isAdminAuthenticated()) {
            return new ModelAndView("403"); // Or "adminLogin"
        }
        ModelAndView mv = new ModelAndView("categories");
        List<Category> categories = categoryService.getCategories();
        mv.addObject("categories", categories);
        return mv;
    }

    @PostMapping("/categories")
    public String addCategory(@RequestParam("categoryname") String name) {
        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

        categoryService.addCategory(name);
        return "redirect:/admin/categories";
    }

    @GetMapping("/categories/delete")
    public String deleteCategory(@RequestParam("id") Long id) {
        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

        categoryService.deleteCategory(id);
        return "redirect:/admin/categories";
    }

    @GetMapping("/categories/update")
    public String updateCategory(@RequestParam("categoryid") Long id,
                                 @RequestParam("categoryname") String name) {
        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

        categoryService.updateCategory(id, name);
        return "redirect:/admin/categories";
    }

    // ================= PRODUCT MANAGEMENT =================

    @GetMapping("/products")
    public ModelAndView getProducts(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "desc") String sortDir) { // 🆕 Sort Direction
        
    	// Fix 1: Security check must return a ModelAndView object
        if (!isAdminAuthenticated()) {
            return new ModelAndView("403"); // Or "adminLogin"
        }
        ModelAndView mv = new ModelAndView("products");
        
        // Pass sortDir to service
        org.springframework.data.domain.Page<Product> productPage = 
            productService.getFilteredProducts(search, categoryId, page, size, sortDir);

        mv.addObject("products", productPage.getContent());
        mv.addObject("currentPage", page);
        mv.addObject("totalPages", productPage.getTotalPages());
        mv.addObject("search", search);
        mv.addObject("categoryId", categoryId);
        mv.addObject("sortDir", sortDir); // Send current sort back to UI
        mv.addObject("reverseSortDir", sortDir.equals("asc") ? "desc" : "asc"); // For toggle
        mv.addObject("categories", categoryService.getCategories());

        return mv;
    }

    @GetMapping("/products/add")
    public ModelAndView addProductPage() {
    	// Fix 1: Security check must return a ModelAndView object
        if (!isAdminAuthenticated()) {
            return new ModelAndView("403"); // Or "adminLogin"
        }
        ModelAndView mv = new ModelAndView("productsAdd");
        mv.addObject("categories", categoryService.getCategories());
        return mv;
    }

    @PostMapping("/products/add")
    public String addProduct(
            @RequestParam String name,
            @RequestParam Long categoryid,
            @RequestParam int price,
            @RequestParam String weight,
            @RequestParam int quantity,
            @RequestParam String description,
            @RequestParam String productImage) {

        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

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
    	// Fix 1: Security check must return a ModelAndView object
        if (!isAdminAuthenticated()) {
            return new ModelAndView("403"); // Or "adminLogin"
        }
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
            @RequestParam String weight,
            @RequestParam int quantity,
            @RequestParam String description,
            @RequestParam String productImage) {

        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

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
        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

        productService.deleteProduct(id);
        return "redirect:/admin/products";
    }

    // ================= CUSTOMERS =================

    @GetMapping("/customers")
    public ModelAndView getCustomers() {
    	// Fix 1: Security check must return a ModelAndView object
        if (!isAdminAuthenticated()) {
            return new ModelAndView("403"); // Or "adminLogin"
        }
        ModelAndView mv = new ModelAndView("displayCustomers");
        mv.addObject("customers", userService.getUsers());
        return mv;
    }

    // ================= PROFILE & LOGOUT =================

    @GetMapping("/profileDisplay")
    public String profileDisplay(Model model) {
        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userService.getUserByEmail(username);
        model.addAttribute("user", user);
        return "updateProfile";
    }

    @PostMapping("/updateuser")
    public String updateUser(@ModelAttribute User updatedUser, HttpServletRequest request) {
        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

        User existing = userService.getUserByEmail(updatedUser.getUsername());
        if (existing != null) {
            existing.setEmail(updatedUser.getEmail());
            existing.setAddress(updatedUser.getAddress());
            userService.addUser(existing);

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

    // ================= ORDER MANAGEMENT =================

    @GetMapping("/orders")
    public ModelAndView getAdminOrders(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String paymentStatus,
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "0") int page) {
    	
    	// Fix 1: Security check must return a ModelAndView object
        if (!isAdminAuthenticated()) {
            return new ModelAndView("403"); // Or "adminLogin"
        }
        
        Pageable pageable = PageRequest.of(page, 10, Sort.by("orderDate").descending());
        
        // CRITICAL: Convert empty strings from the form to null so the query ignores them
        String statusParam = (status != null && !status.trim().isEmpty()) ? status : null;
        String payParam = (paymentStatus != null && !paymentStatus.trim().isEmpty()) ? paymentStatus : null;
        String searchParam = (search != null && !search.trim().isEmpty()) ? search : null;

        Page<Order> orderPage = orderRepository.adminSearchOrders(statusParam, payParam, searchParam, pageable);

        ModelAndView mv = new ModelAndView("adminOrders");
        mv.addObject("orders", orderPage.getContent());
        mv.addObject("totalPages", orderPage.getTotalPages());
        mv.addObject("currentPage", page);
        
        // Send these back so the search box stays filled after clicking 'Search'
        mv.addObject("status", status);
        mv.addObject("paymentStatus", paymentStatus);
        mv.addObject("search", search);
        
        return mv;
    }
    @PostMapping("/orders/updateStatus")
    public String updateOrderStatus(@RequestParam int orderId, @RequestParam String status) {
        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

        Order order = orderRepository.findById(orderId).orElse(null);
        if (order != null) {
            order.setStatus(status);
            orderRepository.save(order);
        }
        return "redirect:/admin/orders?statusUpdated=true";
    }

    @GetMapping("/orders/delete/{id}")
    public String deleteOrder(@PathVariable int id) {
        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

        orderRepository.deleteById(id);
        return "redirect:/admin/orders?deleted=true";
    }
    
    @GetMapping("/system/seed-data")
    public String SeedData() {
        if (!isAdminAuthenticated()) return "redirect:/admin/adminLogin";

        productService.seedAllDatabaseProducts();
        return "redirect:/admin/products?seeded=true";    
    }
}