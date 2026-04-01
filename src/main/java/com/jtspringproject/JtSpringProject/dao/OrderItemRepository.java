package com.jtspringproject.JtSpringProject.dao;

import com.jtspringproject.JtSpringProject.models.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, Integer> {
    
    // Custom query to find all items belonging to a specific order ID
    List<OrderItem> findByOrderId(int orderId);
    
    // Custom query to find items by product ID (Useful for sales reports in Dharashiv)
    List<OrderItem> findByProductId(int productId);
}