<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <title>My Orders | Mazi Mandai</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f8f9fa; }
        .success-banner { background: #e8f5e9; border-left: 5px solid #2e7d32; padding: 20px; border-radius: 10px; }
        .order-card { border: none; border-radius: 15px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .status-dot { height: 10px; width: 10px; background-color: #ff6f00; border-radius: 50%; display: inline-block; margin-right: 5px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="/">Mazi<span style="color: #FF6F00;">Mandai</span></a>
        <a href="/" class="btn btn-outline-primary btn-sm rounded-pill">Continue Shopping</a>
    </div>
</nav>

<div class="container mt-5">
    <c:if test="${not empty msg}">
        <div class="success-banner mb-4">
            <h5 class="text-success font-weight-bold"><i class="fas fa-check-circle mr-2"></i> ${msg}</h5>
        </div>
    </c:if>

    <div class="row">
        <div class="col-md-4">
            <div class="card order-card p-4 text-center">
                <div class="mb-3">
                    <i class="fas fa-user-circle fa-4x text-muted"></i>
                </div>
                <h5 class="font-weight-bold">${username}</h5>
                <p class="text-muted small">Dharashiv Premium Member</p>
                <hr>
                <a href="/user/profile" class="btn btn-sm btn-light btn-block">Edit Profile</a>
                <a href="/logout" class="btn btn-sm btn-outline-danger btn-block mt-2">Logout</a>
            </div>
        </div>

        <div class="col-md-8">
            <h4 class="font-weight-bold mb-4">Recent Orders</h4>
            
            <div class="card order-card mb-3">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="badge badge-warning px-3 py-2 rounded-pill mb-2">ORDER #MM9921</span>
                            <h6 class="font-weight-bold">Status: <span class="status-dot"></span> Out for Delivery</h6>
                            <p class="small text-muted mb-0">Expected: Today, within 45 mins</p>
                        </div>
                        <div class="text-right">
                            <h5 class="font-weight-bold text-success">Preparing</h5>
                            <i class="fas fa-truck-loading fa-2x text-muted mt-2"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-center mt-5">
                <p class="text-muted">Looking for older orders? <a href="#">Download Statement</a></p>
            </div>
        </div>
    </div>
</div>

</body>
</html>