package com.jtspringproject.JtSpringProject.models;

import jakarta.persistence.*;
import java.util.Date;

@Entity(name="CUSTOMER_ORDER")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @ManyToOne
    private User customer;

    private int totalAmount;
    private String address;
    private String pincode;
    private String contact;
    private String paymentMethod;
    private Date orderDate;

    public Order() { this.orderDate = new Date(); }

    // Standard Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public User getCustomer() { return customer; }
    public void setCustomer(User customer) { this.customer = customer; }
    public int getTotalAmount() { return totalAmount; }
    public void setTotalAmount(int totalAmount) { this.totalAmount = totalAmount; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }
    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
}