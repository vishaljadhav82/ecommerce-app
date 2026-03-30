package com.jtspringproject.JtSpringProject.dao;

import com.jtspringproject.JtSpringProject.models.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Integer> {
    // 100x Better: Fetch only the orders belonging to the logged-in customer
    List<Order> findByCustomerIdOrderByOrderDateDesc(int userId);
    List<Order> findByCustomer_IdOrderByOrderDateDesc(int userId);
}