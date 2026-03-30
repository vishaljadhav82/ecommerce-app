<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mazi Mandai | Premium Freshness</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root {
            --brand-orange: #FF6F00;
            --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --royal-dark: #0F172A;
            --glass-white: rgba(255, 255, 255, 0.85);
            --soft-bg: #F8FAFC;
        }

        body { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            background-color: var(--soft-bg); 
            color: var(--royal-dark);
            overflow-x: hidden;
        }

        /* --- 1. PREMIUM NAVBAR --- */
        .navbar {
            background: var(--glass-white) !important;
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(0,0,0,0.05);
            padding: 15px 0;
        }
        .navbar-brand { font-weight: 800; font-size: 1.5rem; letter-spacing: -1px; }
        .navbar-brand span { color: var(--brand-orange); }

        .search-container {
            background: #F1F5F9;
            border-radius: 12px;
            padding: 5px 15px;
            transition: 0.3s;
            border: 1px solid transparent;
        }
        .search-container:focus-within {
            background: white;
            border-color: var(--brand-orange);
            box-shadow: 0 0 0 4px rgba(255, 111, 0, 0.1);
        }
        .search-input { border: none; background: transparent; outline: none; width: 250px; font-size: 0.9rem; }

        /* --- 2. HERO SECTION --- */
        .hero-banner {
            background: var(--brand-gradient);
            border-radius: 30px;
            padding: 60px;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 40px;
            box-shadow: 0 20px 40px rgba(255, 111, 0, 0.2);
        }
        .hero-banner h1 { font-weight: 800; font-size: 3.5rem; line-height: 1.1; }
        .hero-badge {
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(5px);
            padding: 5px 15px;
            border-radius: 50px;
            font-size: 0.8rem;
            text-transform: uppercase;
            font-weight: 700;
        }

        /* --- 3. CATEGORY CHIPS --- */
        .category-chip {
            background: white;
            border: 1px solid #E2E8F0;
            padding: 10px 25px;
            border-radius: 50px;
            font-weight: 600;
            color: #64748B;
            transition: 0.3s;
            display: inline-block;
            margin-right: 10px;
            white-space: nowrap;
        }
        .category-chip:hover, .category-chip.active {
            background: var(--brand-orange);
            color: white;
            border-color: var(--brand-orange);
            text-decoration: none;
        }

        /* --- 4. PRODUCT CARDS --- */
        .product-card {
            background: white;
            border: none;
            border-radius: 24px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            padding: 20px;
            height: 100%;
        }
        .product-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 30px 60px rgba(0,0,0,0.08);
        }
        .img-container {
            height: 180px;
            border-radius: 18px;
            background: #F8FAFC;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
        }
        .img-container img { max-height: 140px; transition: 0.5s; }
        .product-card:hover .img-container img { transform: scale(1.1) rotate(5deg); }

        .price-text { font-size: 1.4rem; font-weight: 800; color: #1e293b; }
        
        .add-btn {
            background: var(--brand-gradient);
            color: white;
            border: none;
            border-radius: 12px;
            width: 45px;
            height: 45px;
            transition: 0.3s;
            cursor: pointer;
        }
        .add-btn:hover { transform: scale(1.1); box-shadow: 0 5px 15px rgba(255, 111, 0, 0.4); }

        /* --- 5. FLOATING ELEMENTS (100x ADDITIONS) --- */
        .floating-cart {
            position: fixed;
            bottom: 40px;
            right: 40px;
            background: var(--royal-dark);
            color: white !important;
            padding: 12px 25px;
            border-radius: 50px;
            display: flex;
            align-items: center;
            z-index: 1050;
            text-decoration: none !important;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .floating-cart:hover { transform: scale(1.05) translateY(-5px); }
        .cart-badge-count {
            background: var(--brand-orange);
            color: white;
            font-size: 0.7rem;
            padding: 2px 8px;
            border-radius: 50px;
            position: absolute;
            top: -10px;
            right: -5px;
            border: 2px solid white;
        }

        #cart-toast {
            position: fixed;
            top: 100px;
            right: -400px;
            background: white;
            padding: 20px;
            border-radius: 20px;
            width: 300px;
            z-index: 2000;
            transition: 0.5s;
            border-left: 5px solid #10B981;
        }
        #cart-toast.show { right: 30px; }

        @media (max-width: 768px) {
            .mobile-bottom-nav {
                position: fixed; bottom: 20px; left: 20px; right: 20px;
                background: var(--royal-dark); border-radius: 20px; padding: 15px;
                display: flex; justify-content: space-around; z-index: 1000;
            }
            .floating-cart { bottom: 90px; right: 20px; padding: 10px 15px; }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/">Mazi<span>Mandai</span></a>
        
        <div class="d-none d-lg-flex align-items-center">
            <form action="/shop/search" method="get" class="search-container mr-4">
                <i class="fas fa-search text-muted mr-2"></i>
                <input type="text" name="query" class="search-input" placeholder="Search Fresh Produce...">
            </form>
            
            <div class="user-actions d-flex align-items-center">
                <a href="/user/profile" class="mr-4 text-dark font-weight-600">
                    <i class="far fa-user-circle mr-1"></i> ${username}
                </a>
                <a href="/logout" class="btn btn-link text-danger p-0 font-weight-bold">Exit</a>
            </div>
        </div>
    </div>
</nav>

<div class="container mt-5">
    
    <div class="hero-banner">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <span class="hero-badge mb-3 d-inline-block">Dharashiv Local Delivery</span>
                <h1>Freshness <br>Redefined.</h1>
                <p class="mt-3 opacity-75">Farm-to-fork in under 45 minutes. No middlemen, just quality.</p>
                <a href="#store" class="btn btn-light rounded-pill px-4 py-2 font-weight-bold mt-4 shadow">Shop Now</a>
            </div>
            <div class="col-lg-5 d-none d-lg-block text-right">
                <i class="fas fa-leaf fa-10x opacity-25"></i>
            </div>
        </div>
    </div>

    <div class="d-flex overflow-auto pb-4 no-scrollbar" id="store">
        <a href="/" class="category-chip active">All Products</a>
        <a href="/shop/search?query=Vegetables" class="category-chip">Vegetables</a>
        <a href="/shop/search?query=Fruits" class="category-chip">Fruits</a>
        <a href="/shop/search?query=Organic" class="category-chip">Organic Picks</a>
        <a href="/shop/search?query=Spices" class="category-chip">Pure Spices</a>
    </div>

    <div class="row mt-4">
        <c:forEach var="product" items="${products}">
            <div class="col-6 col-md-4 col-lg-3 mb-4">
                <div class="product-card shadow-sm">
                    <div class="img-container">
                        <img src="${product.image}" alt="${product.name}">
                    </div>
                    <div class="product-info">
                        <small class="text-uppercase text-muted font-weight-bold" style="letter-spacing: 1px; font-size: 0.65rem;">
                            ${product.category.name}
                        </small>
                        <h6 class="font-weight-bold text-truncate mt-1 mb-0">${product.name}</h6>
                        <p class="text-muted small text-truncate mb-3">${product.description}</p>
                        
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="price-text">₹${product.price}</span>
                                <br><small class="text-muted"><del>₹${product.price + 40}</del></small>
                            </div>
                            <button class="add-btn ajax-add" data-id="${product.id}" data-name="${product.name}">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<a href="/cart/view" class="floating-cart shadow-lg">
    <div class="position-relative mr-3">
        <i class="fas fa-shopping-basket fa-lg"></i>
        <span class="cart-badge-count" id="cart-counter">0</span>
    </div>
    <div class="d-none d-md-block">
        <small class="d-block opacity-75" style="line-height:1">Basket</small>
        <span class="font-weight-bold">View Items</span>
    </div>
</a>

<div id="cart-toast" class="shadow-lg">
    <div class="d-flex align-items-center">
        <i class="fas fa-check-circle text-success mr-3 fa-2x"></i>
        <div>
            <h6 class="mb-0 font-weight-bold" id="toast-p-name">Product Added</h6>
            <small class="text-muted">Added to your Dharashiv Mandai</small>
        </div>
    </div>
</div>

<footer class="mt-5 py-5 bg-white border-top text-center">
    <div class="container">
        <p class="font-weight-bold mb-1">Mazi Mandai</p>
        <p class="text-muted small">Crafted for Dharashiv Diaries Project &copy; 2026</p>
    </div>
</footer>

<div class="mobile-bottom-nav d-lg-none">
    <a href="/" class="active"><i class="fas fa-home"></i></a>
    <a href="/shop/search"><i class="fas fa-search"></i></a>
    <a href="/cart/view"><i class="fas fa-shopping-basket"></i></a>
    <a href="/user/profile"><i class="fas fa-user"></i></a>
</div>

<script>
    document.querySelectorAll('.ajax-add').forEach(button => {
        button.addEventListener('click', function() {
            const productId = this.getAttribute('data-id');
            const productName = this.getAttribute('data-name');

            // Fire AJAX request to the Controller method we created
            fetch('/cart/add/' + productId)
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        // 1. Update Floating Badge
                        document.getElementById('cart-counter').innerText = data.cartCount;

                        // 2. Show Success Toast
                        document.getElementById('toast-p-name').innerText = productName;
                        const toast = document.getElementById('cart-toast');
                        toast.classList.add('show');
                        setTimeout(() => toast.classList.remove('show'), 3000);

                        // 3. Button Animation
                        this.innerHTML = '<i class="fas fa-check"></i>';
                        this.style.background = '#10B981';
                        setTimeout(() => {
                            this.innerHTML = '<i class="fas fa-plus"></i>';
                            this.style.background = 'var(--brand-gradient)';
                        }, 2000);
                    }
                })
                .catch(err => console.error("Error:", err));
        });
    });
</script>

</body>
</html>