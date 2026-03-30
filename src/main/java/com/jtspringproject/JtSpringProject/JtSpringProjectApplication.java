package com.jtspringproject.JtSpringProject;

import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.userService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class JtSpringProjectApplication {

    public static void main(String[] args) {
        SpringApplication.run(JtSpringProjectApplication.class, args);
    }

    @Bean
    public CommandLineRunner setupAdmin(userService userService) {
        return args -> {
            System.out.println("DEBUG: Checking for Admin user...");

            // 1. Check if the admin already exists to avoid duplicates
            String adminUsername = "admin@gmail.com";
            
            if (!userService.checkUserExists(adminUsername)) {
                System.out.println("DEBUG: Admin not found. Creating default admin...");

                User admin = new User();
                admin.setUsername(adminUsername);
                admin.setPassword("admin123"); // 🔥 Saving as PLAIN TEXT
                admin.setEmail("admin@gmail.com");
                admin.setAddress("Office 101");
                admin.setRole("ROLE_ADMIN"); // 🔥 Critical for AdminController access

                userService.addUser(admin);
                System.out.println("DEBUG: Admin created successfully!");
                System.out.println("DEBUG: Username: admin@gmail.com | Password: admin123");
            } else {
                System.out.println("DEBUG: Admin already exists in the database.");
            }
        };
    }
}