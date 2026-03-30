package com.jtspringproject.JtSpringProject.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.jtspringproject.JtSpringProject.models.CartProduct;
import com.jtspringproject.JtSpringProject.models.CartProductId;

@Repository
public interface CartProductRepository extends JpaRepository<CartProduct, CartProductId> {
    
    // Find all items in a specific cart (for the checkout list)
    List<CartProduct> findByCartId(int cartId);

    // CRITICAL for Quantity: Find a specific product in a specific cart
    // This allows you to check if you should increment quantity or create a new row
    CartProduct findByCartIdAndProductId(int cartId, Long productId);

    // This allows the service to wipe the cart items in one query
    void deleteByCartId(int cartId);
}