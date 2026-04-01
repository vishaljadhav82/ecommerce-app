package com.jtspringproject.JtSpringProject.dao;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.jtspringproject.JtSpringProject.models.Order;

public interface OrderRepository extends JpaRepository<Order, Integer> {
    // 100x Better: Fetch only the orders belonging to the logged-in customer
    List<Order> findByCustomerIdOrderByOrderDateDesc(int userId);
    List<Order> findByCustomer_IdOrderByOrderDateDesc(int userId);
 // Search by ID or Customer Name with Pagination and Status Filter
    @Query("SELECT o FROM CUSTOMER_ORDER o WHERE " +
    	       "(:status IS NULL OR o.status = :status) AND " +
    	       "(:payStatus IS NULL OR o.paymentStatus = :payStatus) AND " +
    	       "(:query IS NULL OR CAST(o.id AS string) LIKE %:query% OR LOWER(o.customer.username) LIKE LOWER(CONCAT('%', :query, '%')))")
    	Page<Order> adminSearchOrders(
    	    @Param("status") String status, 
    	    @Param("payStatus") String payStatus,
    	    @Param("query") String query, 
    	    Pageable pageable
    	);
	List<Order> findByStatus(String string);
}
