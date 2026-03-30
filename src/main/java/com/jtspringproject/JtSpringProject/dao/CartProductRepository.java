package com.jtspringproject.JtSpringProject.dao;

import com.jtspringproject.JtSpringProject.models.CartProduct;
import com.jtspringproject.JtSpringProject.models.CartProductId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CartProductRepository extends JpaRepository<CartProduct, CartProductId> {
    // Find all items in a specific cart
    List<CartProduct> findByCartId(int cartId);
 // This allows the service to wipe the cart items in one query
    void deleteByCartId(int cartId);
    
}