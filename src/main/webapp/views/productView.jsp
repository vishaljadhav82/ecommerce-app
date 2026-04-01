<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} | Mazi Mandai</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root { --brand-orange: #FF6F00; --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%); }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: white; overflow-x: hidden; }

        /* --- PRODUCT STYLES --- */
        .product-gallery { background: #F8FAFC; border-radius: 30px; padding: 50px; text-align: center; }
        .product-gallery img { max-width: 100%; height: auto; transition: 0.3s; }
        .price-tag { font-size: 2rem; font-weight: 800; color: #2E7D32; }
        .badge-dharashiv { background: #FFF7ED; color: var(--brand-orange); border: 1px solid #FFEDD5; padding: 10px 20px; border-radius: 12px; font-weight: 700; }
        
        /* --- FLOATING CART SIDEBAR --- */
        #floatingCart {
            position: fixed; top: 0; right: -400px; width: 350px; height: 100%;
            background: white; box-shadow: -10px 0 30px rgba(0,0,0,0.1);
            z-index: 1050; transition: 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            display: flex; flex-direction: column;
        }
        #floatingCart.active { right: 0; }
        .cart-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5); z-index: 1040; display: none;
        }
        .cart-header { background: var(--brand-gradient); color: white; padding: 20px; }
        .btn-checkout { background: var(--brand-orange); color: white; font-weight: 800; border-radius: 12px; width: 100%; padding: 15px; border: none; }
        
        /* Animation for Cart Badge */
        .badge-pulse { animation: pulse 0.5s; }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.4); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>

<div class="cart-overlay" id="cartOverlay"></div>

<div id="floatingCart">
    <div class="cart-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0 font-weight-bold"><i class="fas fa-shopping-basket mr-2"></i> My Basket</h5>
        <button class="btn btn-sm text-white" onclick="toggleCart()"><i class="fas fa-times fa-lg"></i></button>
    </div>
    <div class="p-4 flex-grow-1 text-center" id="cartContent">
        <div class="py-5">
            <i class="fas fa-check-circle text-success fa-3 height mb-3" style="font-size: 3rem;"></i>
            <h5 class="font-weight-bold" id="addedMsg">Added to Basket!</h5>
            <p class="text-muted" id="addedProductName"></p>
        </div>
        <hr>
        <div class="d-flex justify-content-between mb-4">
            <span class="text-muted">Items in Cart:</span>
            <span class="font-weight-bold" id="floatingCartCount">0</span>
        </div>
    </div>
    <div class="p-4 border-top">
        <a href="/cart/view" class="btn btn-checkout shadow-sm">CHECKOUT NOW</a>
        <button class="btn btn-link btn-sm btn-block mt-2 text-muted" onclick="toggleCart()">Continue Shopping</button>
    </div>
</div>

<nav class="navbar navbar-expand-lg sticky-top bg-white border-bottom shadow-sm">
    <div class="container">
        <a class="navbar-brand font-weight-bold" href="/">Mazi<span style="color:var(--brand-orange)">Mandai</span></a>
        <div class="ml-auto">
            <a href="/cart/view" class="btn btn-light rounded-pill px-4">
                <i class="fas fa-shopping-basket mr-2"></i>
                <span class="badge badge-warning" id="navCartCount">${cartCount}</span>
            </a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <div class="row">
        <div class="col-lg-6 mb-4">
            <div class="product-gallery shadow-sm">
                <img src="${product.image}" alt="${product.name}" onerror="this.src='https://via.placeholder.com/500?text=Fresh+Product'">
            </div>
        </div>

        <div class="col-lg-6 pl-lg-5">
            <h1 class="font-weight-800 display-4 mb-3">${product.name}</h1>
            <div class="badge-dharashiv mb-4 d-inline-block">
                <i class="fas fa-leaf mr-2"></i> Harvested in Dharashiv
            </div>

            <div class="mb-4">
                <span class="price-tag">₹${product.price}</span>
                <span class="text-muted ml-3">/ per kg</span>
            </div>

            <p class="text-secondary mb-5" style="line-height: 1.8;">${product.description}</p>

            <button type="button" class="btn btn-block btn-lg p-3 text-white font-weight-bold shadow-lg" 
                    style="background: var(--brand-orange); border-radius: 15px;" 
                    onclick="addToCartAjax(${product.id})">
                <i class="fas fa-cart-plus mr-2"></i> ADD TO BASKET
            </button>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function toggleCart() {
        $("#floatingCart").toggleClass("active");
        $("#cartOverlay").fadeToggle();
    }

    $("#cartOverlay").click(function() { toggleCart(); });

    function addToCartAjax(productId) {
        // Match the PostMapping URL in your controller: /cart/add/{id}
        $.ajax({
            url: '/cart/add/' + productId,
            type: 'POST',
            success: function(response) {
                if (response.status === "success") {
                    // Update Content
                    $("#addedProductName").text(response.productName);
                    $("#navCartCount").text(response.cartCount).addClass("badge-pulse");
                    $("#floatingCartCount").text(response.cartCount);
                    
                    // Show Floating Cart
                    toggleCart();

                    // Remove pulse animation after it plays
                    setTimeout(() => {
                        $("#navCartCount").removeClass("badge-pulse");
                    }, 500);
                }
            },
            error: function(xhr) {
                if (xhr.status === 401) {
                    window.location.href = "/login"; // Redirect if unauthorized
                } else {
                    alert("Error adding product to cart. Please try again.");
                }
            }
        });
    }
</script>

</body>
</html>