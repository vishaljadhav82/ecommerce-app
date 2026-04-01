package com.jtspringproject.JtSpringProject.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.jtspringproject.JtSpringProject.dao.CategoryRepository;
import com.jtspringproject.JtSpringProject.dao.OrderRepository;
import com.jtspringproject.JtSpringProject.models.Cart;
import com.jtspringproject.JtSpringProject.models.Order;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.cartService;
import com.jtspringproject.JtSpringProject.services.productService;
import com.jtspringproject.JtSpringProject.services.userService;

import jakarta.transaction.Transactional;

@RestController
@RequestMapping("/api/v1")
@CrossOrigin(origins = "*")
public class AllApi {

    @Autowired private userService userService;
    @Autowired private productService productService;
    @Autowired private cartService cartService;
    @Autowired private OrderRepository orderRepository;
    @Autowired private CategoryRepository categoryRepository;

    // 1. AUTH: Login
    @PostMapping("/auth/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> info) {
        User user = userService.getUserByEmail(info.get("email"));
        if (user != null && user.getPassword().equals(info.get("password"))) {
            return ResponseEntity.ok(user);
        }
        return ResponseEntity.status(401).body("Invalid Credentials");
    }

    // 2. AUTH: Register
    @PostMapping("/auth/register")
    public ResponseEntity<?> register(@RequestBody User user) {
        if(userService.getUserByEmail(user.getEmail()) != null) 
            return ResponseEntity.badRequest().body("Email exists");
        User saved = userService.addUser(user);
        // Initialize an empty cart for the new user
        Cart cart = new Cart();
        cart.setCustomer(saved);
        cartService.addCart(cart);
        return ResponseEntity.ok(saved);
    }

    // 3. HOME: Categories & Products
    @GetMapping("/discovery")
    public ResponseEntity<Map<String, Object>> discovery(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Long categoryId) {
        Map<String, Object> res = new HashMap<>();
        res.put("categories", categoryRepository.findAll());
        res.put("products", productService.getFilteredProducts(search, categoryId, 0, 100, "desc").getContent());
        return ResponseEntity.ok(res);
    }

    // 4. CART: Add Item
    @PostMapping("/cart/add")
    public ResponseEntity<?> addToCart(@RequestParam int userId, @RequestParam int productId) {
        Cart cart = cartService.getCartByUserId(userId);
        Product product = productService.getProduct((long) productId);
        cartService.addItemToCart(cart, product);
        return ResponseEntity.ok(Map.of("status", "success"));
    }

    // 5. CART: Get Full Details (For Checkout Screen)
    @GetMapping("/cart/details/{userId}")
    public ResponseEntity<?> getCart(@PathVariable int userId) {
        Cart cart = cartService.getCartByUserId(userId);
        return ResponseEntity.ok(cartService.getCartProducts(cart));
    }

    // 6. ORDER: Place Order (The Transaction)
    @PostMapping("/orders/place")
    @Transactional
    public ResponseEntity<?> placeOrder(@RequestBody Order order) {
        order.setOrderDate(new Date());
        order.setStatus("PLACED");
        Order saved = orderRepository.save(order);
        // Clear cart after successful order
        cartService.clearCart(cartService.getCartByUserId(order.getCustomer().getId()));
        return ResponseEntity.ok(saved);
    }

    // 7. PROFILE: Order History
    @GetMapping("/orders/user/{userId}")
    public ResponseEntity<?> getHistory(@PathVariable int userId) {
        return ResponseEntity.ok(orderRepository.findByCustomer_IdOrderByOrderDateDesc(userId));
    }
}