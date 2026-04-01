<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Orders | Mazi Mandai Premium</title>

<link
	href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

<style>
:root {
	--brand-orange: #FF6F00;
	--brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
	--royal-dark: #0F172A;
	--bg-light: #F1F5F9;
}

body {
	font-family: 'Plus Jakarta Sans', sans-serif;
	background-color: var(--bg-light);
	color: var(--royal-dark);
}

/* --- PREMIUM NAVBAR --- */
.navbar {
	background: white !important;
	border-bottom: 2px solid var(--brand-orange);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.navbar-brand {
	font-weight: 800;
}

.navbar-brand span {
	color: var(--brand-orange);
}

/* --- SIDEBAR --- */
.sidebar-card {
	background: white;
	border-radius: 20px;
	overflow: hidden;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.03);
	border: none;
}

.sidebar-link {
	display: flex;
	align-items: center;
	padding: 12px 20px;
	color: #64748B;
	font-weight: 600;
	transition: 0.3s;
	text-decoration: none !important;
}

.sidebar-link:hover, .sidebar-link.active {
	background: #FFF7ED;
	color: var(--brand-orange);
	border-right: 4px solid var(--brand-orange);
}

/* --- ORDER CONTAINER --- */
.order-container {
	background: white;
	border-radius: 24px;
	border: 1px solid #E2E8F0;
	margin-bottom: 30px;
	transition: 0.3s;
	overflow: hidden;
}

.order-container:hover {
	box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
	transform: translateY(-3px);
}

.order-header {
	background: #F8FAFC;
	padding: 20px 30px;
	border-bottom: 1px solid #E2E8F0;
}

/* --- PRODUCT VIEW WITHIN ORDER --- */
.product-strip {
	padding: 20px 30px;
	border-bottom: 1px dashed #E2E8F0;
	transition: 0.2s;
}

.product-strip:hover {
	background: #FCFCFD;
}

.product-img {
	width: 70px;
	height: 70px;
	object-fit: cover;
	border-radius: 12px;
	background: #f1f5f9;
	border: 1px solid #eee;
}

/* --- AMAZON STYLE TRACKING --- */
.track-bar {
	display: flex;
	justify-content: space-between;
	margin-top: 20px;
	position: relative;
}

.track-step {
	flex: 1;
	text-align: center;
	position: relative;
	z-index: 1;
}

.track-step::before {
	content: "";
	position: absolute;
	top: 15px;
	left: -50%;
	width: 100%;
	height: 3px;
	background: #E2E8F0;
	z-index: -1;
}

.track-step:first-child::before {
	display: none;
}

.dot {
	width: 32px;
	height: 32px;
	border-radius: 50%;
	background: #E2E8F0;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	margin-bottom: 8px;
	color: white;
	font-size: 0.8rem;
	border: 4px solid white;
}

.track-step.active .dot {
	background: var(--brand-orange);
	box-shadow: 0 0 0 1px var(--brand-orange);
}

.track-step.active::before {
	background: var(--brand-orange);
}

.track-step.active span {
	color: var(--brand-orange);
	font-weight: 800;
}

.btn-invoice {
	border-radius: 10px;
	font-weight: 700;
	border: 1px solid #E2E8F0;
	color: #64748B;
	background: white;
	transition: 0.3s;
}

.btn-invoice:hover {
	background: var(--royal-dark);
	color: white;
}
</style>
</head>
<body>

	<nav class="navbar navbar-expand-lg sticky-top">
		<div class="container">
			<a class="navbar-brand" href="/">Mazi<span>Mandai</span></a>
			<div class="ml-auto d-flex align-items-center">
				<span
					class="mr-3 d-none d-md-inline text-muted small font-weight-bold">DHARASHIV
					EXPRESS <i class="fa fa-bolt text-warning"></i>
				</span> <a href="/" class="btn btn-dark btn-sm rounded-pill px-4">Continue
					Shopping</a>
			</div>
		</div>
	</nav>

	<div class="container mt-5 pb-5">
		<div class="row">
			<div class="col-lg-3">
				<div class="sidebar-card mb-4">
					<div class="p-4 text-center border-bottom bg-light">
						<div
							class="rounded-circle bg-white shadow-sm d-inline-flex align-items-center justify-content-center mb-3"
							style="width: 70px; height: 70px; border: 2px solid var(--brand-orange);">
							<i class="fas fa-user text-warning fa-2x"></i>
						</div>
						<h6 class="font-weight-800 mb-0">${username}</h6>
						<p class="small text-muted mb-0">Verified Customer</p>
					</div>
					<div class="py-2">
						<a href="/user/profile" class="sidebar-link"><i
							class="fas fa-id-card mr-3"></i> Profile</a> <a href="/user/orders"
							class="sidebar-link active"><i
							class="fas fa-shopping-bag mr-3"></i> My Orders</a> <a href="/logout"
							class="sidebar-link text-danger"><i
							class="fas fa-power-off mr-3"></i> Logout</a>
					</div>
				</div>
			</div>

			<div class="col-lg-9">
				<div class="d-flex justify-content-between align-items-end mb-4">
					<h3 class="font-weight-800 mb-0">Order History</h3>
					<p class="text-muted small mb-0">${orders.size()}orders placed</p>
				</div>

				<c:choose>
					<c:when test="${empty orders}">
						<div
							class="card border-0 shadow-sm rounded-xl p-5 text-center bg-white">
							<i class="fas fa-shopping-basket fa-4x text-light mb-3"></i>
							<h5 class="text-muted">No orders found!</h5>
							<a href="/"
								class="btn btn-warning mt-3 px-5 rounded-pill font-weight-bold">Order
								Fresh Veggies</a>
						</div>
					</c:when>
					<c:otherwise>
						<c:forEach var="order" items="${orders}">
							<div class="order-container shadow-sm">
								<div class="order-header row mx-0 align-items-center">
									<div class="col-md-3 border-right">
										<p class="small text-muted font-weight-bold mb-0">ORDER
											DATE</p>
										<span class="font-weight-bold">${order.getFormattedDate()}</span>
									</div>
									<div class="col-md-2 border-right">
										<p class="small text-muted font-weight-bold mb-0">TOTAL</p>
										<span class="font-weight-bold text-success">₹${order.totalAmount}</span>
									</div>
									<div class="col-md-4 border-right">
										<p class="small text-muted font-weight-bold mb-0">SHIP TO</p>
										<span class="font-weight-bold text-dark text-truncate d-block">${order.area}</span>
									</div>
									<div class="col-md-3 text-md-right">
										<p class="small text-muted font-weight-bold mb-0">ORDER ID</p>
										<span class="font-weight-bold">#MM-${order.id}</span>
									</div>
								</div>

								<div class="bg-white">
									<c:forEach var="item" items="${order.items}">
										<div class="product-strip">
											<a href="/product/view?id=${item.product.id}"
												class="text-decoration-none">
												<div class="row align-items-center">
													<div class="col-auto">
														<img src="${item.product.image}" class="product-img"
															onerror="this.src='https://via.placeholder.com/100?text=Mandai'">
													</div>
													<div class="col pl-0">
														<h6 class="font-weight-800 mb-0 text-dark">${item.product.name}</h6>
														<small class="text-muted">Quantity:
															${item.quantity} | Price: ₹${item.priceAtPurchase}</small>
													</div>
													<div class="col-md-3 text-right">
														<span class="font-weight-bold text-dark">₹${item.priceAtPurchase * item.quantity}</span>
													</div>
												</div>
											</a>
										</div>
									</c:forEach>
								</div>

								<div class="p-4 bg-white">
									<div class="track-bar mb-4">
										<div class="track-step active">
											<div class="dot">
												<i class="fas fa-check"></i>
											</div>
											<span class="d-block small font-weight-bold">Confirmed</span>
										</div>
										<div
											class="track-step ${order.status == 'DISPATCHED' || order.status == 'DELIVERED' ? 'active' : ''}">
											<div class="dot">
												<i class="fas fa-shipping-fast"></i>
											</div>
											<span class="d-block small font-weight-bold">Out for
												Delivery</span>
										</div>
										<div
											class="track-step ${order.status == 'DELIVERED' ? 'active' : ''}">
											<div class="dot">
												<i class="fas fa-home"></i>
											</div>
											<span class="d-block small font-weight-bold">Arrived</span>
										</div>
									</div>

									<div
										class="d-flex justify-content-between align-items-center pt-3 border-top mt-4">
										<div class="small">
											<span class="text-muted">Payment:</span> <strong
												class="text-uppercase">${order.paymentMethod}</strong>
										</div>
										<div class="d-flex align-items-center">
											<button class="btn btn-invoice btn-sm px-3 mr-2">
												<i class="fas fa-file-alt mr-2"></i>Invoice
											</button>
											<button class="btn btn-warning btn-sm px-3 font-weight-bold"
												style="background: var(--brand-gradient); border: none; color: white; border-radius: 10px;">Support</button>
										</div>
									</div>
								</div>
							</div>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<footer class="text-center py-5 text-muted border-top bg-white mt-5">
		<p class="small mb-1 font-weight-bold text-dark">MAZI MANDAI
			DHARASHIV</p>
		<p class="small">© 2026 Crafted by Vishal Jadhav</p>
	</footer>

</body>
</html>