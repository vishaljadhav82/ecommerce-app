package com.jtspringproject.JtSpringProject.models;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity(name="ORDER_ITEMS")
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    // Link back to the parent Order
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id")
    private Order order;

    // Link to the specific Product
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "product_id")
    private Product product;

    private int quantity;
    
    // 100x Improvement: Store price at the time of purchase
    // If you change the price of Mangoes tomorrow, the old order still shows the original price.
    private int priceAtPurchase;

    // Default Constructor (Required by JPA)
    public OrderItem() {}

    // Convenience Constructor for Controller
    public OrderItem(Order order, Product product, int quantity) {
        this.order = order;
        this.product = product;
        this.quantity = quantity;
        this.priceAtPurchase = product.getPrice();
    }

    // ================= GETTERS & SETTERS =================

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getPriceAtPurchase() { return priceAtPurchase; }
    public void setPriceAtPurchase(int priceAtPurchase) { this.priceAtPurchase = priceAtPurchase; }
    
    // UI Helper: Get subtotal for this specific item
    public int getSubTotal() {
        return this.quantity * this.priceAtPurchase;
    }
}