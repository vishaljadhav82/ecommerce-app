<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout | Mazi Mandai Premium</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root { --brand-orange: #FF6F00; --royal-blue: #1A237E; --leaf-green: #2E7D32; }
        body { font-family: 'Poppins', sans-serif; background-color: #f0f2f5; color: #333; }
        
        /* Progress Stepper */
        .stepper { display: flex; justify-content: space-between; margin-bottom: 30px; position: relative; }
        .step { text-align: center; z-index: 2; flex: 1; }
        .step-icon { width: 40px; height: 40px; border-radius: 50%; background: #ddd; color: white; line-height: 40px; margin: 0 auto 10px; transition: 0.3s; }
        .step.active .step-icon { background: var(--brand-orange); box-shadow: 0 0 15px rgba(255,111,0,0.4); }
        .step.active span { color: var(--brand-orange); font-weight: 700; }
        
        /* Product Cards */
        .cart-card { border: none; border-radius: 20px; overflow: hidden; transition: 0.3s; }
        .item-row { border-bottom: 1px solid #eee; padding: 20px 0; transition: 0.2s; }
        .item-row:last-child { border-bottom: none; }
        .item-row:hover { background: #fafafa; }
        .prod-img { width: 90px; height: 90px; object-fit: cover; border-radius: 12px; background: #f9f9f9; }
        
        /* Sidebar/Summary */
        .summary-card { border: none; border-radius: 25px; background: white; position: sticky; top: 100px; }
        .promo-box { background: #fff3e0; border: 1px dashed var(--brand-orange); border-radius: 12px; padding: 15px; }
        
        /* Delivery Info */
        .delivery-badge { background: #e8f5e9; color: var(--leaf-green); font-weight: 700; padding: 5px 15px; border-radius: 50px; font-size: 12px; }
        
        .btn-checkout { background: linear-gradient(45deg, var(--brand-orange), #ff9100); color: white; border: none; border-radius: 15px; padding: 18px; font-weight: 800; font-size: 1.1rem; box-shadow: 0 10px 20px rgba(255,111,0,0.3); transition: 0.3s; }
        .btn-checkout:hover { transform: translateY(-3px); box-shadow: 0 15px 25px rgba(255,111,0,0.4); color: white; }
    </style>
</head>
<body>

<nav class="navbar navbar-light bg-white py-3 shadow-sm mb-4">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="/" style="color: var(--royal-blue);">
            <i class="fas fa-chevron-left mr-3 small text-muted"></i>Mazi<span style="color: var(--brand-orange);">Mandai</span>
        </a>
        <span class="text-muted small font-weight-bold">SECURE CHECKOUT <i class="fas fa-lock ml-1"></i></span>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="stepper">
                <div class="step active"><div class="step-icon"><i class="fas fa-shopping-cart"></i></div><span>Cart</span></div>
                <div class="step"><div class="step-icon"><i class="fas fa-map-marker-alt"></i></div><span>Address</span></div>
                <div class="step"><div class="step-icon"><i class="fas fa-credit-card"></i></div><span>Payment</span></div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card cart-card shadow-sm mb-4">
                <div class="card-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="font-weight-bold mb-0">Your Basket <span class="text-muted">(${cartItems.size()} Items)</span></h4>
                        <span class="delivery-badge"><i class="fas fa-truck mr-2"></i>FREE DELIVERY TO DHARASHIV</span>
                    </div>

                    <c:forEach var="item" items="${cartItems}">
                        <div class="item-row">
                            <div class="row align-items-center">
                                <div class="col-3 col-md-2">
                                    <img src="${item.product.image}" class="prod-img" alt="product">
                                </div>
                                <div class="col-6 col-md-7">
                                    <small class="text-primary font-weight-bold text-uppercase">${item.product.category.name}</small>
                                    <h5 class="font-weight-bold mb-1">${item.product.name}</h5>
                                    <p class="text-muted small mb-0">Sold by: Local Mandai Farmers</p>
                                    <div class="mt-2">
                                        <button class="btn btn-sm btn-light rounded-circle text-danger"><i class="fas fa-minus"></i></button>
                                        <span class="mx-3 font-weight-bold">1</span>
                                        <button class="btn btn-sm btn-light rounded-circle text-success"><i class="fas fa-plus"></i></button>
                                    </div>
                                </div>
                                <div class="col-3 text-right">
                                    <h5 class="font-weight-bold text-dark">₹${item.product.price}</h5>
                                    <a href="#" class="text-muted small"><i class="fas fa-trash-alt mr-1"></i> Remove</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty cartItems}">
                        <div class="text-center py-5">
                            <img src="https://cdn-icons-png.flaticon.com/512/11329/11329060.png" style="width: 150px; opacity: 0.5;">
                            <h4 class="mt-4 text-muted">Your basket is empty!</h4>
                            <a href="/" class="btn btn-primary rounded-pill px-4 mt-3">Start Shopping</a>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm rounded-lg text-center p-3 h-100">
                        <i class="fas fa-certificate fa-2x text-success mb-2"></i>
                        <h6 class="font-weight-bold">100% Fresh</h6>
                        <small class="text-muted">Direct from farms to your home</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm rounded-lg text-center p-3 h-100">
                        <i class="fas fa-bolt fa-2x text-warning mb-2"></i>
                        <h6 class="font-weight-bold">Fast Delivery</h6>
                        <small class="text-muted">Within 60 mins in Dharashiv</small>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm rounded-lg text-center p-3 h-100">
                        <i class="fas fa-shield-alt fa-2x text-primary mb-2"></i>
                        <h6 class="font-weight-bold">Secure Pay</h6>
                        <small class="text-muted">Safe UPI & Cash on Delivery</small>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card summary-card shadow-lg p-3">
                <div class="card-body">
                    <h5 class="font-weight-bold mb-4">Bill Summary</h5>
                    
                    <div class="promo-box mb-4">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-percentage mr-3 text-orange fa-lg"></i>
                            <div>
                                <h6 class="mb-0 font-weight-bold text-orange">MANDAI30 Applied</h6>
                                <small class="text-muted">You saved ₹30 more!</small>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Item Total</span>
                        <span>₹${total}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Handling Charges</span>
                        <span class="text-success">FREE</span>
                    </div>
                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted">Delivery Fee</span>
                        <span class="text-success">FREE</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="font-weight-bold mb-0 text-dark">To Pay</h5>
                        <h4 class="font-weight-bold mb-0 text-danger">₹${total}</h4>
                    </div>

                    <a href="/cart/checkout" class="btn btn-checkout btn-block">
                        PROCEED TO CHECKOUT <i class="fas fa-arrow-right ml-2"></i>
                    </a>
                    
                    <div class="text-center mt-3">
                        <img src="https://logos-world.net/wp-content/uploads/2020/11/UPI-Logo.png" style="height: 20px; opacity: 0.6;">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="bg-dark text-white py-4 mt-5">
    <div class="container text-center">
        <p class="mb-0 small">&copy; 2026 Mazi Mandai Premium | Proudly Supporting Local Farmers</p>
    </div>
</footer>

</body>
</html>