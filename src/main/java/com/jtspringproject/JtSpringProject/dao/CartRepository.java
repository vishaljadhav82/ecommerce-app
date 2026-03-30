package com.jtspringproject.JtSpringProject.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import com.jtspringproject.JtSpringProject.models.Cart;
import org.springframework.stereotype.Repository;

@Repository
public interface CartRepository extends JpaRepository<Cart, Integer> {
    // Spring looks at Cart.customer.id to fulfill this
    Cart findByCustomerId(long customerId);
}