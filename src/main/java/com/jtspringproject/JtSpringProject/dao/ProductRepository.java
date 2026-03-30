package com.jtspringproject.JtSpringProject.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import com.jtspringproject.JtSpringProject.models.Product;

import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Long> {

    // Optional: find by category
    List<Product> findByCategoryId(Long categoryId);
}