package com.jtspringproject.JtSpringProject.controller;

import java.util.List;
import java.util.Collections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.jtspringproject.JtSpringProject.models.*;
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

    // ================= MANUAL LOGIN PROCESSING =================

    @PostMapping("/adminloginvalidate")
    public String adminLoginValidate(@RequestParam String username, 
                                     @RequestParam String password, 
                                     HttpServletRequest request) {
        
        System.out.println("DEBUG: Admin Login attempt for: " + username);
        User user = userService.getUserByUsername(username);

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
        User user = userService.getUserByUsername(username);
        model.addAttribute("user", user);
        return "updateProfile";
    }

    @PostMapping("/updateuser")
    public String updateUser(@ModelAttribute User updatedUser, HttpServletRequest request) {
        User existing = userService.getUserByUsername(updatedUser.getUsername());

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
}