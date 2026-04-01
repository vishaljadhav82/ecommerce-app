package com.jtspringproject.JtSpringProject.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.jtspringproject.JtSpringProject.dao.UserRepository;
import com.jtspringproject.JtSpringProject.models.Category;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;

import jakarta.transaction.Transactional;

@Service
public class userService {

    @Autowired
    private UserRepository userRepository;

    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    // ADDED: Needed by cartService to create a new cart
    public User getUserByID(Long id) {
        return userRepository.findById(id).orElse(null);
    }

    public List<User> getUsers() {
        return userRepository.findAll();
    }

    public User addUser(User user) {
        try {
            return userRepository.save(user);
        } catch (DataIntegrityViolationException e) {
            throw new RuntimeException("Username already exists");
        }
    }

    public User checkLogin(String username, String password) {
        return userRepository.findByUsername(username)
                .filter(user -> encoder.matches(password, user.getPassword()))
                .orElse(null);
    }

    public boolean checkUserExists(String email) {
        return userRepository.existsByEmail(email);
    }

    public User getUserByEmail(String username) {
        return userRepository.findByEmail(username).orElse(null);
    }

	public User getUserById(Long id) {
		// TODO Auto-generated method stub
        return userRepository.findById(id).orElse(null);
	}
	

}