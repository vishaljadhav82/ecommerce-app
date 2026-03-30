<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout | Mazi Mandai</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --brand-orange: #FF6F00; --royal-blue: #1A237E; }
        body { background-color: #f8f9fa; font-family: 'Poppins', sans-serif; }
        .checkout-card { border: none; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .btn-confirm { background: var(--brand-orange); color: white; font-weight: 700; border-radius: 10px; padding: 12px; }
        .btn-confirm:hover { background: #e65100; color: white; }
    </style>
</head>
<body>

<nav class="navbar navbar-light bg-white border-bottom shadow-sm mb-4">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="/" style="color: var(--royal-blue);">
            <i class="fas fa-arrow-left mr-2"></i> Mazi Mandai Checkout
        </a>
    </div>
</nav>

<div class="container">
    <div class="row">
        <div class="col-md-8">
            <div class="card checkout-card p-4 mb-4">
                <h4 class="mb-4">Delivery Address</h4>
                <form>
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" class="form-control" value="${username}" readonly>
                    </div>
                    <div class="form-group">
                        <label>Shipping Address</label>
                        <textarea class="form-control" rows="3" placeholder="Enter your full address in Maharashtra..."></textarea>
                    </div>
                </form>
            </div>
            
            <div class="card checkout-card p-4">
                <h4 class="mb-4">Payment Method</h4>
                <div class="custom-control custom-radio mb-2">
                    <input type="radio" id="cod" name="payment" class="custom-control-input" checked>
                    <label class="custom-control-label" for="cod">Cash on Delivery (COD)</label>
                </div>
                <div class="custom-control custom-radio">
                    <input type="radio" id="upi" name="payment" class="custom-control-input">
                    <label class="custom-control-label" for="upi">UPI / PhonePe / Google Pay</label>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card checkout-card p-4">
                <h4 class="mb-4">Order Summary</h4>
                <div class="d-flex justify-content-between mb-2">
                    <span>Items Total</span>
                    <span>₹${product.price}</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>Delivery Fee</span>
                    <span class="text-success">FREE</span>
                </div>
                <hr>
                <div class="d-flex justify-content-between mb-4">
                    <strong class="h5">Total Amount</strong>
                    <strong class="h5 text-primary">₹${product.price}</strong>
                </div>
                <button class="btn btn-confirm btn-block" onclick="alert('Order Placed Successfully!')">
                    PLACE ORDER
                </button>
            </div>
        </div>
    </div>
</div>

</body>
</html>