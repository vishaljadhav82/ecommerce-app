package com.jtspringproject.JtSpringProject.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import com.jtspringproject.JtSpringProject.models.User;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

    Optional<User> findByUsername(String username);

    boolean existsByUsername(String username);
}