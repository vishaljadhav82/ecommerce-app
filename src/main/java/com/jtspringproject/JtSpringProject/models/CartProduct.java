package com.jtspringproject.JtSpringProject.models;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;

@Entity
@Table(name = "CART_PRODUCT")
public class CartProduct {

    @EmbeddedId
    private CartProductId id;

    @ManyToOne
    @MapsId("cartId")
    @JoinColumn(name = "cart_id")
    private Cart cart;

    @ManyToOne
    @MapsId("productId")
    @JoinColumn(name = "product_id")
    private Product product;

    // --- 100x NEW FIELD ---
    @Column(name = "quantity")
    private int quantity = 1; // Default to 1 when a product is first added

    public CartProduct() {}

    public CartProduct(Cart cart, Product product) {
        this.cart = cart;
        this.product = product;
        // Ensure quantity is 1 on creation
        this.quantity = 1;
        // Handle the composite key mapping
        this.id = new CartProductId(cart.getId(), (Long) product.getId());
    }

    // --- GETTERS & SETTERS FOR QUANTITY ---
    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Standard Getters & Setters
    public CartProductId getId() { return id; }
    public void setId(CartProductId id) { this.id = id; }
    public Cart getCart() { return cart; }
    public void setCart(Cart cart) { this.cart = cart; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}