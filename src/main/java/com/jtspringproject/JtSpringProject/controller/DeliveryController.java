package com.jtspringproject.JtSpringProject.controller;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.jtspringproject.JtSpringProject.dao.OrderRepository;
import com.jtspringproject.JtSpringProject.dao.DeliveryPartnerRepository;
import com.jtspringproject.JtSpringProject.models.Order;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.models.DeliveryPartner;
import com.jtspringproject.JtSpringProject.services.userService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/delivery")
public class DeliveryController {

    @Autowired
    private userService userService;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private DeliveryPartnerRepository partnerRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private User getAuthenticatedUser() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userService.getUserByEmail(principal.toString());
    }

    @GetMapping("/login")
    public String loginPage() { return "delivery/deliveryLogin"; }

    @GetMapping("/register")
    public String registerPage() { return "delivery/deliveryRegister"; }

    @PostMapping("/login/process")
    public String loginProcess(@RequestParam String username, @RequestParam String password, HttpServletRequest request) {
        User user = userService.getUserByEmail(username);
        if (user != null && passwordEncoder.matches(password.trim(), user.getPassword()) && "ROLE_DELIVERY".equals(user.getRole())) {
            UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(user.getEmail(), null,
                    Collections.singletonList(new SimpleGrantedAuthority(user.getRole())));
            SecurityContextHolder.getContext().setAuthentication(auth);
            request.getSession(true).setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
            return "redirect:/delivery/dashboard";
        }
        return "redirect:/delivery/login?error=true";
    }

    @PostMapping("/register/process")
    @Transactional
    public String processRegistration(@RequestParam String username, @RequestParam String email,
                                    @RequestParam String password, @RequestParam String address,
                                    @RequestParam String vehicleNumber, @RequestParam String vehicleType,
                                    @RequestParam String aadharNumber) {
        
        if (userService.getUserByEmail(email) != null) return "redirect:/delivery/register?error=exists";

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setAddress(address);
        user.setPassword(passwordEncoder.encode(password.trim()));
        user.setRole("ROLE_DELIVERY"); 

        DeliveryPartner partner = new DeliveryPartner();
        partner.setUser(user);
        partner.setVehicleNumber(vehicleNumber);
        partner.setVehicleType(vehicleType);
        partner.setAadharNumber(aadharNumber);
        partner.setAvailable(true);
        partner.setActiveZone("Dharashiv Central");

        partnerRepository.save(partner);
        return "redirect:/delivery/login?msg=partner_onboarded";
    }

    @GetMapping("/dashboard")
    public ModelAndView deliveryDashboard() {
        User user = getAuthenticatedUser();
        if (user == null || !"ROLE_DELIVERY".equals(user.getRole())) return new ModelAndView("redirect:/delivery/login");

        ModelAndView mv = new ModelAndView("delivery/deliveryDashboard");
        mv.addObject("partner", user);
        mv.addObject("orders", orderRepository.findByStatus("SHIPPED"));
        return mv;
    }

    @PostMapping("/order/complete")
    public String markAsDelivered(@RequestParam Integer orderId) {
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order != null) {
            order.setStatus("DELIVERED");
            order.setPaymentStatus("PAID"); 
            orderRepository.save(order);
        }
        return "redirect:/delivery/dashboard?success=true";
    }
}