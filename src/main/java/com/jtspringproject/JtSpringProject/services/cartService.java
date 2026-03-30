package com.jtspringproject.JtSpringProject.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jtspringproject.JtSpringProject.dao.CartProductRepository;
import com.jtspringproject.JtSpringProject.dao.CartRepository;
import com.jtspringproject.JtSpringProject.models.Cart;
import com.jtspringproject.JtSpringProject.models.CartProduct;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;

import jakarta.transaction.Transactional;

@Service
public class cartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartProductRepository cartProductRepository;

    @Autowired
    private userService userService; // Needed to link the new cart to a real user

    /**
     * Finds a cart for the user. If none exists, creates and saves a new one.
     * This prevents NullPointerException in the Controller.
     */
    public Cart getCartByUserId(long userId) {
        Cart cart = cartRepository.findByCustomerId(userId);
        
        if (cart == null) {
            System.out.println("LOG: Creating new cart for User ID: " + userId);
            
            cart = new Cart();
            // Fetch the user object from DB to ensure the relationship is valid
            User user = userService.getUserByID(userId);
            cart.setCustomer(user);
            
            // Crucial: Save the cart FIRST so it gets a generated ID from MySQL
            cart = cartRepository.save(cart);
        }
        
        return cart;
    }

//    public void addItemToCart(Cart cart, Product product) {
//        // Now 'cart' is guaranteed not to be null
//        CartProduct cartProduct = new CartProduct(cart, product);
//        cartProductRepository.save(cartProduct);
//    }

    public List<CartProduct> getCartProducts(Cart cart) {
        if (cart == null) return java.util.Collections.emptyList();
        return cartProductRepository.findByCartId(cart.getId());
    }

    public Cart addCart(Cart cart) {
        return cartRepository.save(cart);
    }
    
    @Transactional
    public void clearCart(Cart cart) {
        if (cart != null) {
            System.out.println("LOG: Clearing all items from Cart ID: " + cart.getId());
            // This deletes rows from the CART_PRODUCT table, 
            // but keeps the CART and USER intact.
            cartProductRepository.deleteByCartId(cart.getId());
        }
    }
    
    /**
     * Adds a product to the cart. If the product already exists, 
     * it increments the quantity. If not, it creates a new entry.
     */
//    @Transactional
//    public void addItemToCart(Cart cart, Product product) {
//        // 1. Check if this product is already in the specific cart
//        CartProduct existingItem = cartProductRepository.findByCartIdAndProductId(cart.getId(), product.getId());
//
//        if (existingItem != null) {
//            // 2. 100x Logic: Just increase the quantity
//            existingItem.setQuantity(existingItem.getQuantity() + 1);
//            cartProductRepository.save(existingItem);
//        } else {
//            // 3. New item: Create with quantity 1
//            CartProduct newItem = new CartProduct(cart, product);
//            newItem.setQuantity(1); 
//            cartProductRepository.save(newItem);
//        }
//    }
//
    /**
     * Reduces product quantity by 1. If quantity becomes 0, 
     * the row is removed from the database.
     */
    @Transactional
    public void reduceItemQuantity(Cart cart, Product product) {
        CartProduct existingItem = cartProductRepository.findByCartIdAndProductId(cart.getId(), product.getId());

        if (existingItem != null) {
            if (existingItem.getQuantity() > 1) {
                existingItem.setQuantity(existingItem.getQuantity() - 1);
                cartProductRepository.save(existingItem);
            } else {
                // If it's the last one, delete the row entirely
                cartProductRepository.delete(existingItem);
            }
        }
    }
    
    @Transactional
    public void addItemToCart(Cart cart, Product product) {
        // 1. Check if this product is already in the specific cart
        CartProduct existingItem = cartProductRepository.findByCartIdAndProductId(cart.getId(), (Long) product.getId());

        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + 1);
            cartProductRepository.save(existingItem);
        } else {
            // Refined: Ensure the CartProduct and its Composite ID are fully initialized
            CartProduct newItem = new CartProduct(cart, product);
            newItem.setQuantity(1); 
            cartProductRepository.save(newItem);
        }
    }
    
    @Transactional
    public void removeItemCompletely(Cart cart, Product product) {
        CartProduct existingItem = cartProductRepository.findByCartIdAndProductId(cart.getId(), (Long) product.getId());
        if (existingItem != null) {
            cartProductRepository.delete(existingItem);
        }
    }
}
