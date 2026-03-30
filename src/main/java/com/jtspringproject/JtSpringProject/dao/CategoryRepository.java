package com.jtspringproject.JtSpringProject.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import com.jtspringproject.JtSpringProject.models.Category;

public interface CategoryRepository extends JpaRepository<Category, Long> {
}