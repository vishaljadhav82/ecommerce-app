package com.jtspringproject.JtSpringProject.models;

import jakarta.persistence.*;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
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
    // ✅ Address Fields (Structured)
    private String houseNo;        // Flat / House No
    private String buildingName;   // Apartment / Society
    private String street;         // Road / Street
    private String landmark;       // Nearby landmark
    private String area;           // Area / Locality
    private String city;
    private String district;
    private String state;
    private String country;
    private String pincode;

   
    private String contact;
    private String paymentMethod;
    private String status; // PREPARING, DISPATCHED, DELIVERED, CANCELLED
    private String paymentStatus; // PENDING, PAID, REFUNDED, FAILED

    @Temporal(TemporalType.TIMESTAMP)
    private Date orderDate;

    // --- 100x Improvement: Link to OrderItem ---
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<OrderItem> items = new ArrayList<>();

    

 // New Fields for Exact Location
    private Double latitude;
    private Double longitude;
    
    public Order() { 
        this.orderDate = new Date(); 
        this.status = "PREPARING";
        this.paymentStatus = "PENDING"; // Default state
    }

    // Getters and Setters...
    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }
    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }
    
    // Helper to add item and set the back-reference (Crucial for Hibernate)
    public void addOrderItem(OrderItem item) {
        items.add(item);
        item.setOrder(this);
    }

    public String getFormattedDate() {
        return new SimpleDateFormat("dd MMM yyyy, hh:mm a").format(orderDate);
    }

    public String getStatusColor() {
        switch (this.status) {
            case "DELIVERED": return "success";
            case "DISPATCHED": return "info";
            case "CANCELLED": return "danger";
            default: return "warning";
        }
    }

    // --- GETTERS & SETTERS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public User getCustomer() { return customer; }
    public void setCustomer(User customer) { this.customer = customer; }
    public int getTotalAmount() { return totalAmount; }
    public void setTotalAmount(int totalAmount) { this.totalAmount = totalAmount; }
    
    public String getHouseNo() {
		return houseNo;
	}

	public void setHouseNo(String houseNo) {
		this.houseNo = houseNo;
	}

	public String getBuildingName() {
		return buildingName;
	}

	public void setBuildingName(String buildingName) {
		this.buildingName = buildingName;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getLandmark() {
		return landmark;
	}

	public void setLandmark(String landmark) {
		this.landmark = landmark;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getDistrict() {
		return district;
	}

	public void setDistrict(String district) {
		this.district = district;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

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
    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
 // Helper for UI colors
    public String getPaymentStatusColor() {
        if ("PAID".equals(this.paymentStatus)) return "success";
        if ("FAILED".equals(this.paymentStatus)) return "danger";
        return "warning"; // For PENDING
    }

    // Add Getter and Setter
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
}