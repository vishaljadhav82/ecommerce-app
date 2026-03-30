<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mazi Mandai | Maharashtra's Premium Store</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root { --brand-orange: #FF6F00; --royal-blue: #1A237E; }
        body { font-family: 'Poppins', sans-serif; background-color: #f4f7f6; }
        
        /* Navbar Styling */
        .navbar { background: white !important; border-bottom: 3px solid var(--brand-orange); }
        .navbar-brand { font-weight: 800; color: var(--royal-blue) !important; font-size: 1.6rem; }
        .navbar-brand span { color: var(--brand-orange); }
        
        /* Search Box */
        .search-box { border: 2px solid #ddd; border-radius: 25px; overflow: hidden; width: 400px; }
        .search-input { border: none; padding: 8px 20px; width: 80%; outline: none; }
        .search-btn { border: none; background: var(--brand-orange); color: white; width: 20%; }

        /* Product Cards */
        .p-card { border: none; border-radius: 12px; transition: 0.3s; background: white; margin-bottom: 25px; overflow: hidden; }
        .p-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .img-box { height: 160px; background: #f9f9f9; display: flex; align-items: center; justify-content: center; padding: 15px; }
        .img-box img { max-height: 100%; max-width: 100%; object-fit: contain; }
        
        .btn-cart { background: var(--brand-orange); color: white; font-weight: 600; border-radius: 8px; width: 100%; transition: 0.3s; }
        .btn-cart:hover { background: #e65100; color: white; }
        
        .category-badge { background: #e3f2fd; color: #1976d2; font-size: 11px; font-weight: 700; padding: 3px 10px; border-radius: 5px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="/">Mazi<span>Mandai</span></a>
        
        <form action="/shop/search" method="get" class="search-box d-none d-md-flex mx-auto">
            <input type="text" name="query" class="search-input" placeholder="Search vegetables, fruits...">
            <button type="submit" class="search-btn"><i class="fas fa-search"></i></button>
        </form>

        <div class="d-flex align-items-center">
            <span class="mr-3 d-none d-sm-block">Hi, <strong>${username}</strong></span>
            <a href="/cart/view" class="btn position-relative mr-2">
                <i class="fas fa-shopping-basket fa-lg"></i>
                <span class="badge badge-danger position-absolute" style="top:-5px; right:-5px;">!</span>
            </a>
            <a href="/logout" class="btn btn-sm btn-outline-danger">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="mb-4 d-flex overflow-auto pb-2">
        <a href="/" class="btn btn-sm btn-white border shadow-sm mr-2 rounded-pill px-3">All Items</a>
        <a href="/shop/search?query=Vegetables" class="btn btn-sm btn-white border shadow-sm mr-2 rounded-pill px-3">Vegetables</a>
        <a href="/shop/search?query=Fruits" class="btn btn-sm btn-white border shadow-sm mr-2 rounded-pill px-3">Fruits</a>
        <a href="/shop/search?query=Spices" class="btn btn-sm btn-white border shadow-sm mr-2 rounded-pill px-3">Spices</a>
    </div>

    <c:if test="${not empty msg}">
        <div class="alert alert-info py-2">${msg}</div>
    </c:if>

    <h4 class="font-weight-bold mb-4">Fresh Arrivals</h4>

    <div class="row">
        <c:forEach var="product" items="${products}">
            <div class="col-6 col-md-4 col-lg-3">
                <div class="p-card card shadow-sm">
                    <div class="img-box">
                        <img src="${product.image}" alt="${product.name}">
                    </div>
                    <div class="card-body">
                        <span class="category-badge mb-2 d-inline-block">${product.category.name}</span>
                        <h6 class="text-truncate font-weight-bold mb-1">${product.name}</h6>
                        <p class="text-muted small text-truncate">${product.description}</p>
                        
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="h5 font-weight-bold text-success mb-0">₹${product.price}</span>
                            <small class="text-muted"><del>₹${product.price + 50}</del></small>
                        </div>
                        
                        <a href="/cart/add/${product.id}" class="btn btn-cart">
                            <i class="fas fa-cart-plus mr-2"></i> Add
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<footer class="bg-white py-4 mt-5 border-top">
    <div class="container text-center text-muted">
        <p>&copy; 2026 Mazi Mandai | Dharashiv Diaries Project</p>
    </div>
</footer>

</body>
</html>