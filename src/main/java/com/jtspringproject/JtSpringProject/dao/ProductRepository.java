package com.jtspringproject.JtSpringProject.dao;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.jtspringproject.JtSpringProject.models.Product;
import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Long> {

    // Supports: "search + category"
    Page<Product> findByNameContainingIgnoreCaseAndCategoryId(String name, Long categoryId, Pageable pageable);

    // Supports: "search only"
    Page<Product> findByNameContainingIgnoreCase(String name, Pageable pageable);

    // Supports: "category only"
    Page<Product> findByCategoryId(Long categoryId, Pageable pageable);

    // Default: "show all"
    Page<Product> findAll(Pageable pageable);

    List<Product> findByNameContainingIgnoreCase(String name);
    // Existing list method
    List<Product> findByCategoryId(Long categoryId);
}