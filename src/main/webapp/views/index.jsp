<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mazi Mandai | Dharashiv's Fresh Hub</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">

    <style>
        :root {
            --brand-orange: #FF6F00;
            --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --royal-dark: #0F172A;
            --soft-bg: #F8FAFC;
            --glass: rgba(255, 255, 255, 0.96);
        }

        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--soft-bg); color: var(--royal-dark); padding-top: 80px; }

        /* --- NAVIGATION --- */
        .navbar-custom { background: var(--glass); backdrop-filter: blur(15px); border-bottom: 1px solid rgba(0,0,0,0.05); height: 80px; z-index: 1100; }
        .nav-logo { font-weight: 800; font-size: 1.6rem; color: var(--royal-dark) !important; text-decoration: none !important;}
        .nav-logo span { color: var(--brand-orange); }

        /* --- SMART SEARCH BAR --- */
        .search-container { position: relative; width: 100%; max-width: 550px; }
        .search-input { 
            border-radius: 50px; border: 1px solid #e2e8f0; 
            padding: 12px 50px 12px 50px !important; 
            background: #f1f5f9; transition: 0.3s; font-size: 0.95rem; height: 50px;
        }
        .search-input:focus { background: white; border-color: var(--brand-orange); box-shadow: 0 0 0 4px rgba(255, 111, 0, 0.1); outline: none; }
        .search-icon { position: absolute; left: 20px; top: 50%; transform: translateY(-50%); color: #94a3b8; z-index: 5; }
        .clear-icon { position: absolute; right: 20px; top: 50%; transform: translateY(-50%); color: #94a3b8; cursor: pointer; font-size: 1.2rem; z-index: 10; display: none; }

        /* --- CATEGORY BAR --- */
        .category-bar { background: white; border-bottom: 1px solid #edf2f7; position: sticky; top: 80px; z-index: 1000; padding: 15px 0; }
        .scroll-wrapper { display: flex; overflow-x: auto; gap: 12px; scrollbar-width: none; }
        .scroll-wrapper::-webkit-scrollbar { display: none; }
        .cat-pill { background: #f1f5f9; padding: 10px 24px; border-radius: 50px; font-weight: 700; color: #64748B; white-space: nowrap; transition: 0.3s; text-decoration: none !important; }
        .cat-pill.active { background: var(--brand-orange); color: white; box-shadow: 0 4px 12px rgba(255, 111, 0, 0.2); }

        /* --- PRODUCT CARDS --- */
        .product-card { background: white; border-radius: 24px; padding: 20px; border: none; transition: 0.4s; height: 100%; display: flex; flex-direction: column; }
        .product-card:hover { transform: translateY(-8px); box-shadow: 0 15px 35px rgba(0,0,0,0.06); }
        .img-holder { height: 180px; background: #f8fafc; border-radius: 18px; display: flex; align-items: center; justify-content: center; margin-bottom: 15px; }
        .img-holder img { max-height: 140px; transition: 0.5s; object-fit: contain; }
        
        /* --- BUTTONS & ALERTS --- */
        .add-cart-btn { background: var(--brand-orange); color: white; border: none; width: 45px; height: 45px; border-radius: 14px; transition: 0.3s; cursor: pointer; }
        .add-cart-btn:disabled { background: #cbd5e1; cursor: not-allowed; }
        
        .toast-notification {
            position: fixed; top: 100px; right: 20px; background: var(--royal-dark); color: white; 
            padding: 16px 24px; border-radius: 16px; z-index: 3000; display: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2); font-weight: 600;
        }

        .cart-float { position: fixed; bottom: 30px; right: 30px; background: var(--royal-dark); color: white !important; padding: 15px 30px; border-radius: 50px; z-index: 2000; box-shadow: 0 20px 40px rgba(0,0,0,0.3); text-decoration: none !important; }
    </style>
</head>
<body>

<div id="cartToast" class="toast-notification">
    <i class="fas fa-shopping-basket text-warning mr-2"></i> Added to your Dharashiv basket!
</div>

<nav class="navbar navbar-expand-lg navbar-custom fixed-top">
    <div class="container">
        <a class="navbar-brand nav-logo" href="/">MAZI<span>MANDAI</span></a>
        
        <form action="/" method="GET" id="searchForm" class="search-container d-none d-lg-block mx-auto">
            <i class="fa fa-search search-icon"></i>
            <input type="text" name="search" id="productSearch" class="form-control search-input" 
                   placeholder="Search fresh mangoes, veggies..." value="${search}" autocomplete="off">
            <i class="fa fa-times-circle clear-icon" id="clearSearch"></i>
            <input type="hidden" name="categoryId" value="${categoryId}">
        </form>

        <div class="ml-auto d-flex align-items-center">
            <div class="mr-3 text-right d-none d-sm-block">
                <small class="text-muted d-block">Welcome,</small>
                <span class="font-weight-bold text-uppercase" style="font-size:0.8rem;">${username}</span>
            </div>
            <a href="/user/profile" class="text-dark bg-light rounded-circle" style="width:45px; height:45px; display:flex; align-items:center; justify-content:center; text-decoration:none;">
                <i class="fa fa-user"></i>
            </a>
        </div>
    </div>
</nav>

<div class="category-bar shadow-sm">
    <div class="container">
        <div class="scroll-wrapper">
            <a href="/?search=${search}" class="cat-pill ${empty categoryId ? 'active' : ''}">All Fresh Items</a>
            <c:forEach var="cat" items="${categories}">
                <a href="/?categoryId=${cat.id}&search=${search}" class="cat-pill ${cat.id == categoryId ? 'active' : ''}">${cat.name}</a>
            </c:forEach>
        </div>
    </div>
</div>

<div class="container mt-4">
    <div class="row">
        <c:forEach var="p" items="${products}">
            <div class="col-6 col-md-4 col-lg-3 mb-4">
                <div class="product-card shadow-sm">
                    <div class="img-holder">
                        <img src="${p.image}" alt="${p.name}" onerror="this.src='https://via.placeholder.com/200?text=Mandai+Fresh'">
                    </div>
                    <div class="flex-grow-1">
                        <small class="font-weight-bold text-uppercase" style="color: var(--brand-orange); font-size: 0.6rem;">${p.category.name}</small>
                        <h6 class="font-weight-bold text-truncate mt-1">${p.name}</h6>
                        <p class="text-muted small text-truncate">${p.description}</p>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mt-auto">
                        <span class="h5 font-weight-800 mb-0">₹${p.price}</span>
                        <button class="add-cart-btn btn-ajax-add" data-id="${p.id}">
                            <i class="fa fa-plus"></i>
                        </button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<a href="/cart/view" class="cart-float shadow-lg">
    <i class="fa fa-shopping-basket mr-3"></i>
    <div class="text-left d-inline-block">
        <small class="d-block opacity-75" style="line-height:1; font-size:0.6rem;">Checkout</small>
        <span class="font-weight-bold">My Basket</span>
    </div>
</a>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>

<script>
$(document).ready(function() {
    const $search = $("#productSearch");
    const $clear = $("#clearSearch");

    // 1. Search Logic
    function checkSearch() { $search.val().length > 0 ? $clear.show() : $clear.hide(); }
    checkSearch();
    $search.on("input", checkSearch);
    $clear.on("click", function() { $search.val(""); checkSearch(); window.location.href="/"; });

    $search.autocomplete({
        source: "/searchSuggestions",
        minLength: 2,
        select: function(event, ui) { $search.val(ui.item.value); $("#searchForm").submit(); }
    });

    // 2. PREMIUM AJAX ADD TO CART (Fixes JSON redirect)
    $(".btn-ajax-add").on("click", function(e) {
        e.preventDefault();
        const productId = $(this).data("id");
        const $btn = $(this);
        const originalIcon = $btn.html();

        // Loading state
        $btn.html('<i class="fas fa-spinner fa-spin"></i>').prop('disabled', true);

        $.ajax({
            url: '/cart/add/' + productId,
            type: 'POST',
            success: function(res) {
                $("#cartToast").fadeIn().delay(2000).fadeOut();
                $btn.html('<i class="fas fa-check"></i>').css('background', '#28a745');
                setTimeout(() => {
                    $btn.html(originalIcon).css('background', '').prop('disabled', false);
                }, 1500);
            },
            error: function() {
                alert("Please login to add items to your basket.");
                $btn.html(originalIcon).prop('disabled', false);
            }
        });
    });
});
</script>
</body>
</html>