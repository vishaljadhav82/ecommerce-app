package com.jtspringproject.JtSpringProject.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import com.jtspringproject.JtSpringProject.models.Order;

public interface OrderRepository  extends JpaRepository<Order, Long>{

}
