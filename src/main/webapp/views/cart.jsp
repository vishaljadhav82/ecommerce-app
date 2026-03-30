<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Basket | Mazi Mandai</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root { 
            --brand-orange: #FF6F00; 
            --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --royal-dark: #0F172A; 
            --bg-soft: #F8FAFC;
            --success-green: #22C55E;
        }

        body { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            background-color: var(--bg-soft); 
            color: var(--royal-dark);
        }

        /* --- MODERN STEPPER --- */
        .stepper-container { padding: 40px 0; }
        .step-item { position: relative; text-align: center; flex: 1; }
        .step-circle {
            width: 45px; height: 45px;
            background: #E2E8F0; color: #64748B;
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            margin: 0 auto 10px; font-weight: 800; z-index: 2; position: relative;
        }
        .step-item.active .step-circle {
            background: var(--brand-gradient); color: white;
            box-shadow: 0 10px 20px rgba(255, 111, 0, 0.3);
        }
        .step-item.active span { color: var(--brand-orange); font-weight: 800; }
        .step-line {
            position: absolute; top: 22px; left: 50%; width: 100%;
            height: 3px; background: #E2E8F0; z-index: 1;
        }

        /* --- PREMIUM BASKET CARDS --- */
        .cart-main-card {
            background: white; border-radius: 30px; border: none;
            box-shadow: 0 10px 40px rgba(0,0,0,0.03); overflow: hidden;
        }
        .item-row {
            padding: 25px; border-bottom: 1px solid #F1F5F9;
            transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .item-row:hover { background: #FFFBF7; }
        .prod-img-box {
            width: 100px; height: 100px; background: #F1F5F9;
            border-radius: 20px; padding: 10px; display: flex; align-items: center; justify-content: center;
        }
        .prod-img-box img { max-width: 100%; max-height: 100%; object-fit: contain; }

        /* --- DYNAMIC QUANTITY CONTROLLER --- */
        .qty-box {
            background: #F1F5F9; border-radius: 12px;
            display: inline-flex; align-items: center; padding: 5px;
        }
        .qty-btn {
            width: 35px; height: 35px; border: none; background: white;
            border-radius: 8px; color: var(--royal-dark);
            font-weight: 800; transition: 0.2s; cursor: pointer;
        }
        .qty-btn:hover { background: var(--brand-orange); color: white; transform: scale(1.05); }

        /* --- STICKY SUMMARY --- */
        .summary-card {
            background: white; border-radius: 30px; border: 1px solid rgba(0,0,0,0.05);
            position: sticky; top: 100px; padding: 30px;
        }
        .price-row { display: flex; justify-content: space-between; margin-bottom: 12px; font-weight: 600; }
        .total-row { border-top: 2px dashed #E2E8F0; padding-top: 20px; margin-top: 20px; }
        
        .btn-pay {
            background: var(--brand-gradient); color: white; border: none;
            border-radius: 18px; padding: 18px; font-weight: 800; font-size: 1.1rem;
            width: 100%; transition: 0.3s; box-shadow: 0 10px 25px rgba(255, 111, 0, 0.3);
            display: block; text-align: center;
        }
        .btn-pay:hover { transform: translateY(-3px); box-shadow: 0 15px 30px rgba(255, 111, 0, 0.4); color: white; text-decoration: none; }
        
        .remove-note {
            background: #FFF4E5; border-radius: 12px; padding: 12px;
            font-size: 0.8rem; color: #B45309; border: 1px solid #FED7AA;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-light bg-white border-bottom py-3">
    <div class="container d-flex justify-content-between">
        <a class="navbar-brand font-weight-bold" href="/">Mazi<span style="color:var(--brand-orange)">Mandai</span></a>
        <div class="text-muted small font-weight-bold"><i class="fas fa-shield-check text-success mr-1"></i> SECURE CHECKOUT</div>
    </div>
</nav>

<div class="container">
    <div class="row justify-content-center stepper-container">
        <div class="col-md-9 d-flex">
            <div class="step-item active">
                <div class="step-circle">1</div>
                <span>Basket</span>
                <div class="step-line"></div>
            </div>
            <div class="step-item text-muted">
                <div class="step-circle">2</div>
                <span>Address</span>
                <div class="step-line"></div>
            </div>
            <div class="step-item text-muted">
                <div class="step-circle">3</div>
                <span>Payment</span>
            </div>
        </div>
    </div>

    <div class="row pb-5">
        <div class="col-lg-8 mb-4">
            <div class="cart-main-card">
                <div class="p-4 border-bottom d-flex justify-content-between align-items-center bg-light">
                    <h5 class="font-weight-bold mb-0">Review Items <span class="text-muted small ml-2" id="header-count">(${cartItems.size()} Items)</span></h5>
                    <span class="badge badge-success px-3 py-2 rounded-pill">⚡ Dharashiv Express Delivery</span>
                </div>

                <div id="cart-items-container">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="item-row" id="product-row-${item.product.id}">
                            <div class="row align-items-center">
                                <div class="col-md-2 col-4">
                                    <div class="prod-img-box">
                                        <img src="${item.product.image}" alt="item">
                                    </div>
                                </div>
                                <div class="col-md-7 col-8">
                                    <span class="text-uppercase small font-weight-bold" style="color:var(--brand-orange)">${item.product.category.name}</span>
                                    <h5 class="font-weight-bold mb-1">${item.product.name}</h5>
                                    
                                    <div class="qty-box mt-2">
                                        <button class="qty-btn" onclick="handleQtyUpdate(${item.product.id}, 'minus')"><i class="fas fa-minus"></i></button>
                                        <span class="mx-4 font-weight-bold text-dark" id="qty-val-${item.product.id}">${item.quantity}</span>
                                        <button class="qty-btn" onclick="handleQtyUpdate(${item.product.id}, 'plus')"><i class="fas fa-plus"></i></button>
                                    </div>
                                </div>
                                <div class="col-md-3 text-md-right mt-3 mt-md-0">
                                    <h4 class="font-weight-bold mb-1">₹<span id="row-total-${item.product.id}">${item.product.price * item.quantity}</span></h4>
                                    <small class="text-muted d-block mb-2 unit-price-ref">₹${item.product.price} / unit</small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${empty cartItems}">
                    <div class="text-center py-5" id="empty-cart-msg">
                        <i class="fas fa-shopping-basket fa-4x text-light mb-3"></i>
                        <h4 class="text-muted">Your basket is empty</h4>
                        <a href="/" class="btn btn-warning rounded-pill px-5 mt-3 shadow">Shop Now</a>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="summary-card shadow-lg">
                <h5 class="font-weight-bold mb-4">Order Summary</h5>
                
                <div class="remove-note mb-4">
                    <i class="fas fa-info-circle mr-1"></i> <strong>Note:</strong> Items are removed if quantity is reduced to 0. Use the trash icon for instant removal.
                </div>

                <div class="price-row">
                    <span class="text-muted">Subtotal</span>
                    <span id="summary-subtotal">₹${total}</span>
                </div>
                <div class="price-row">
                    <span class="text-muted">Delivery Fee</span>
                    <span class="text-success font-weight-bold">FREE</span>
                </div>
                
                <div class="total-row d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="font-weight-bold mb-0">Total Payable</h6>
                        <small class="text-muted">Final Amount</small>
                    </div>
                    <h3 class="font-weight-bold text-danger mb-0" id="summary-total">₹${total}</h3>
                </div>

                <a href="/cart/checkout" class="btn btn-pay mt-4">
                    PROCEED TO CHECKOUT <i class="fas fa-chevron-right ml-2"></i>
                </a>
            </div>
        </div>
    </div>
</div>

<script>
/**
 * Handles Plus and Minus updates.
 * If 'minus' is clicked and quantity results in 0, the item is removed.
 */
function handleQtyUpdate(productId, action) {
    fetch('/cart/updateQty/' + productId + '/' + action)
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                // 1. Update quantity display
                const qtySpan = document.getElementById('qty-val-' + productId);
                
                // 2. Logic: If quantity is 0, remove the row with animation
                if (data.itemQty <= 0) {
                    removeRowWithAnimation(productId);
                } else {
                    qtySpan.innerText = data.itemQty;
                    // Update row subtotal
                    const rowTotal = document.getElementById('row-total-' + productId);
                    const unitPriceElement = document.querySelector('#product-row-' + productId + ' .unit-price-ref');
                    const unitPrice = parseInt(unitPriceElement.innerText.replace(/[^\d]/g, ''));
                    rowTotal.innerText = unitPrice * data.itemQty;
                }

                // 3. Update global totals
                updateGlobalUI(data.newTotal, data.cartSize);
            }
        });
}

/**
 * Handles the 'Remove' link. 
 * Instantly removes product regardless of quantity.
 */
function handleRemoveCompletely(productId) {
    if(confirm('Remove this fresh item from your basket?')) {
        fetch('/cart/removeItem/' + productId)
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    removeRowWithAnimation(productId);
                    updateGlobalUI(data.newTotal, data.cartSize);
                }
            });
    }
}

function updateGlobalUI(newTotal, cartSize) {
    document.getElementById('summary-subtotal').innerText = '₹' + newTotal;
    document.getElementById('summary-total').innerText = '₹' + newTotal;
    document.getElementById('header-count').innerText = '(' + cartSize + ' Items)';
    
    if(cartSize === 0) {
        setTimeout(() => location.reload(), 500); // Small delay to allow removal animation to finish
    }
}

function removeRowWithAnimation(productId) {
    const row = document.getElementById('product-row-' + productId);
    if(row) {
        row.style.transform = "translateX(30px)";
        row.style.opacity = "0";
        setTimeout(() => row.remove(), 400);
    }
}
</script>

</body>
</html>