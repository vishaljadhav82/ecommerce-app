<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | Mazi Mandai Premium</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root {
            --brand-orange: #FF6F00;
            --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --royal-dark: #0F172A;
            --bg-light: #F8FAFC;
            --success-green: #2E7D32;
        }

        body { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            background-color: var(--bg-light); 
            color: var(--royal-dark);
        }

        /* --- 1. PREMIUM NAVBAR --- */
        .navbar {
            background: white !important;
            border-bottom: 3px solid var(--brand-orange);
            padding: 15px 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .navbar-brand { font-weight: 800; font-size: 1.6rem; letter-spacing: -1px; }
        .navbar-brand span { color: var(--brand-orange); }

        /* --- 2. SIDEBAR (FLIPKART STYLE) --- */
        .sidebar-card {
            background: white;
            border-radius: 20px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
            overflow: hidden;
        }
        .sidebar-header {
            background: var(--brand-gradient);
            padding: 30px 20px;
            color: white;
            text-align: center;
        }
        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            color: #64748B;
            font-weight: 600;
            transition: 0.3s;
            text-decoration: none !important;
            border-left: 4px solid transparent;
        }
        .sidebar-link i { width: 30px; font-size: 1.1rem; }
        .sidebar-link:hover, .sidebar-link.active {
            background: #FFF7ED;
            color: var(--brand-orange);
            border-left-color: var(--brand-orange);
        }

        /* --- 3. ORDER CARDS (AMAZON STYLE) --- */
        .order-card {
            background: white;
            border-radius: 20px;
            border: 1px solid rgba(0,0,0,0.05);
            margin-bottom: 25px;
            transition: 0.3s;
        }
        .order-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.08);
        }
        .status-badge {
            padding: 6px 16px;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
        }
        .status-preparing { background: #FEF3C7; color: #92400E; }
        .status-delivered { background: #DCFCE7; color: #166534; }
        
        .price-tag { font-size: 1.4rem; font-weight: 800; color: var(--success-green); }
        
        /* Pulse animation for preparing orders */
        .pulse-dot {
            height: 10px; width: 10px;
            background-color: #F59E0B;
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(245, 158, 11, 0.7); }
            70% { transform: scale(1); box-shadow: 0 0 0 10px rgba(245, 158, 11, 0); }
            100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(245, 158, 11, 0); }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/">Mazi<span>Mandai</span></a>
        <div class="ml-auto d-flex align-items-center">
            <span class="d-none d-md-inline mr-3 text-muted">Welcome, <strong>${username}</strong></span>
            <a href="/" class="btn btn-orange btn-sm rounded-pill px-4 shadow-sm" style="background: var(--brand-orange); color:white;">Shop More</a>
        </div>
    </div>
</nav>

<div class="container mt-5 pb-5">
    
    <c:if test="${not empty msg}">
        <div class="alert alert-success border-0 shadow-sm rounded-pill px-4 py-3 mb-4">
            <i class="fas fa-check-circle mr-2"></i> ${msg}
        </div>
    </c:if>

    <div class="row">
        
        <div class="col-lg-3 mb-4">
            <div class="sidebar-card mb-4">
                <div class="sidebar-header">
                    <i class="fas fa-user-astronaut fa-3x mb-3"></i>
                    <h5 class="font-weight-bold mb-0 text-truncate">${username}</h5>
                    <small class="opacity-75">Dharashiv, MH</small>
                </div>
                <div class="py-2">
                    <a href="/user/profile" class="sidebar-link">
                        <i class="fas fa-user-edit"></i> Profile Settings
                    </a>
                    <a href="/user/orders" class="sidebar-link active">
                        <i class="fas fa-shopping-bag"></i> My Orders
                    </a>
                    <a href="/cart/view" class="sidebar-link">
                        <i class="fas fa-cart-arrow-down"></i> View Basket
                    </a>
                    <hr class="mx-3">
                    <a href="/logout" class="sidebar-link text-danger">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="font-weight-bold m-0">Recent Deliveries</h3>
                <span class="text-muted small font-weight-600">${orders.size()} Records Found</span>
            </div>

            <c:if test="${empty orders}">
                <div class="card border-0 shadow-sm rounded-lg p-5 text-center bg-white">
                    <div class="mb-4">
                        <i class="fas fa-box-open fa-5x text-light"></i>
                    </div>
                    <h4 class="text-muted">No Orders Found</h4>
                    <p class="text-secondary">It looks like you haven't placed any orders yet.</p>
                    <a href="/" class="btn btn-warning rounded-pill px-5 mt-3 shadow">Start Shopping</a>
                </div>
            </c:if>

            <c:forEach var="order" items="${orders}">
                <div class="order-card shadow-sm">
                    <div class="card-header bg-white border-0 pt-4 px-4 d-flex justify-content-between align-items-center">
                        <div>
                            <span class="text-muted small text-uppercase font-weight-bold">Order ID</span>
                            <h6 class="font-weight-bold mb-0">#MM-2026-${order.id}</h6>
                        </div>
                        <div class="text-right">
                            <c:choose>
                                <c:when test="${order.status == 'DELIVERED'}">
                                    <span class="status-badge status-delivered">
                                        <i class="fas fa-check-circle mr-1"></i> Delivered
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-preparing">
                                        <span class="pulse-dot"></span> ${order.status}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="card-body px-4 pb-4">
                        <hr class="my-3 opacity-50">
                        <div class="row align-items-center">
                            <div class="col-md-7">
                                <div class="d-flex align-items-start mb-3">
                                    <i class="fas fa-map-marker-alt text-danger mt-1 mr-3"></i>
                                    <div>
                                        <p class="small text-muted mb-0">Delivering to:</p>
                                        <p class="font-weight-600 mb-0">${order.address}</p>
                                        <small class="text-muted">PIN: ${order.pincode} | Contact: ${order.contact}</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5 text-md-right border-left">
                                <p class="small text-muted mb-1">Total Bill (${order.paymentMethod})</p>
                                <h2 class="price-tag mb-0">₹${order.totalAmount}</h2>
                                <button class="btn btn-light btn-sm mt-3 rounded-pill px-4">
                                    <i class="fas fa-file-invoice mr-2"></i> Invoice
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <div class="text-center mt-5">
                <p class="text-muted small">Showing your last 12 months of activity. <br> Dharashiv Diaries Tech v3.0</p>
            </div>
        </div>

    </div>
</div>

<footer class="py-4 mt-5 text-center text-muted border-top bg-white">
    <p class="small mb-0">&copy; 2026 Mazi Mandai | Maharashtra's Fastest Grocery App</p>
</footer>

</body>
</html>