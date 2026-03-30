package com.jtspringproject.JtSpringProject.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jtspringproject.JtSpringProject.dao.CategoryRepository;
import com.jtspringproject.JtSpringProject.models.Category;

@Service
public class categoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    public Category addCategory(String name) {
        Category category = new Category();
        category.setName(name);
        return categoryRepository.save(category);
    }

    public List<Category> getCategories() {
        return categoryRepository.findAll();
    }

    public boolean deleteCategory(Long id) {
        if (categoryRepository.existsById(id)) {
            categoryRepository.deleteById(id);
            return true;
        }
        return false;
    }

    public Category updateCategory(Long id, String name) {
        Category category = categoryRepository.findById(id).orElse(null);

        if (category != null) {
            category.setName(name);
            return categoryRepository.save(category);
        }
        return null;
    }

    public Category getCategory(Long id) {
        return categoryRepository.findById(id).orElse(null);
    }
}