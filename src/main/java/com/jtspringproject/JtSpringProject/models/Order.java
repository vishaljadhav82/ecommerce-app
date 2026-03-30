package com.jtspringproject.JtSpringProject.models;

import jakarta.persistence.*;
import java.util.Date;
import java.text.SimpleDateFormat;

@Entity(name="CUSTOMER_ORDER")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private User customer;

    private int totalAmount;
    private String address;
    private String area; // Better for Dharashiv local delivery routing
    private String pincode;
    private String contact;
    private String paymentMethod;
    
    // 100x Improvement: Track Order Progress
    private String status; // PREPARING, DISPATCHED, DELIVERED, CANCELLED

    @Temporal(TemporalType.TIMESTAMP)
    private Date orderDate;

    public Order() { 
        this.orderDate = new Date(); 
        this.status = "PREPARING"; // Default state for new orders
    }

    // ================= CUSTOM LOGIC METHODS =================

    /**
     * Better than Amazon: Shows a friendly date format in the JSP
     */
    public String getFormattedDate() {
        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
        return sdf.format(orderDate);
    }

    /**
     * UI Helper: Returns a Bootstrap color class based on status
     */
    public String getStatusColor() {
        switch (this.status) {
            case "DELIVERED": return "success";
            case "DISPATCHED": return "info";
            case "CANCELLED": return "danger";
            default: return "warning"; // PREPARING
        }
    }

    // ================= GETTERS & SETTERS =================

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public User getCustomer() { return customer; }
    public void setCustomer(User customer) { this.customer = customer; }

    public int getTotalAmount() { return totalAmount; }
    public void setTotalAmount(int totalAmount) { this.totalAmount = totalAmount; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getArea() { return area; }
    public void setArea(String area) { this.area = area; }

    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }
}