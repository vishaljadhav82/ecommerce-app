package com.jtspringproject.JtSpringProject.dao;

import com.jtspringproject.JtSpringProject.models.DeliveryPartner;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DeliveryPartnerRepository extends JpaRepository<DeliveryPartner, Integer> {
    // Custom query to find partner by the linked User's email
    DeliveryPartner findByUserEmail(String email);
}