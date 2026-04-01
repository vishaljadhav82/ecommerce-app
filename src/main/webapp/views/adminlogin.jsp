<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>Admin Portal | Mazi Mandai</title>

<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
:root {
	--primary-accent: #00d2ff;
	--secondary-accent: #3a7bd5;
	--glass-bg: rgba(255, 255, 255, 0.05);
}

body {
	font-family: 'Inter', sans-serif;
	background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
	min-height: 100vh; /* Changed to min-height for mobile scrolling */
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0;
	padding: 20px; /* Prevents card from touching screen edges on mobile */
}

/* Background Blur Elements */
.bg-circle {
	position: fixed; /* Fixed so they don't move on scroll */
	border-radius: 50%;
	filter: blur(80px);
	z-index: -1;
}

.circle-1 {
	width: 300px;
	height: 300px;
	background: rgba(0, 210, 255, 0.15);
	top: 5%;
	left: 5%;
}

.circle-2 {
	width: 350px;
	height: 350px;
	background: rgba(58, 123, 213, 0.1);
	bottom: 5%;
	right: 5%;
}

.login-card {
	background: rgba(255, 255, 255, 0.03);
	backdrop-filter: blur(20px);
	-webkit-backdrop-filter: blur(20px); /* Safari Support */
	border: 1px solid rgba(255, 255, 255, 0.1);
	border-radius: 28px;
	padding: 40px;
	width: 100%;
	max-width: 420px;
	box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
}

/* RESPONSIVE ADJUSTMENTS */
@media ( max-width : 576px) {
	.login-card {
		padding: 30px 20px;
		border-radius: 20px;
	}
	h2 {
		font-size: 1.5rem;
	}
	.circle-1, .circle-2 {
		width: 150px;
		height: 150px;
	} /* Smaller blurs for mobile performance */
}

.brand-logo {
	width: 60px;
	height: 60px;
	background: linear-gradient(to right, var(--primary-accent),
		var(--secondary-accent));
	border-radius: 18px;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 20px;
	font-size: 24px;
	color: white;
	box-shadow: 0 10px 20px rgba(0, 210, 255, 0.3);
}

h2 {
	color: white;
	font-weight: 700;
	text-align: center;
	margin-bottom: 5px;
	letter-spacing: -0.5px;
}

.subtitle {
	color: #94a3b8;
	text-align: center;
	font-size: 0.85rem;
	margin-bottom: 35px;
}

.form-group label {
	color: #94a3b8;
	font-size: 0.8rem;
	font-weight: 600;
	margin-bottom: 8px;
	display: block;
}

.input-group {
	background: rgba(255, 255, 255, 0.04);
	border-radius: 14px;
	border: 1px solid rgba(255, 255, 255, 0.08);
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	overflow: hidden;
}

.input-group:focus-within {
	border-color: var(--primary-accent);
	background: rgba(255, 255, 255, 0.08);
	box-shadow: 0 0 0 4px rgba(0, 210, 255, 0.1);
}

.input-group-text {
	background: transparent;
	border: none;
	color: #64748b;
	padding-left: 18px;
}

.form-control {
	background: transparent !important;
	border: none;
	color: white !important;
	height: 54px;
	font-size: 1rem;
}

.form-control::placeholder {
	color: #475569;
}

.form-control:focus {
	box-shadow: none;
	outline: none;
}

.btn-login {
	background: linear-gradient(to right, var(--primary-accent),
		var(--secondary-accent));
	border: none;
	border-radius: 14px;
	height: 56px;
	color: white;
	font-weight: 700;
	width: 100%;
	margin-top: 15px;
	transition: all 0.3s ease;
	text-transform: uppercase;
	letter-spacing: 1px;
}

.btn-login:hover {
	transform: translateY(-2px);
	box-shadow: 0 10px 20px rgba(0, 210, 255, 0.3);
}

.btn-login:active {
	transform: translateY(0);
}

.error-msg {
	background: rgba(239, 68, 68, 0.1);
	color: #f87171;
	border-radius: 10px;
	padding: 12px;
	font-size: 0.85rem;
	text-align: center;
	margin-top: 20px;
	border: 1px solid rgba(239, 68, 68, 0.2);
}
</style>
</head>
<body>

	<div class="bg-circle circle-1"></div>
	<div class="bg-circle circle-2"></div>

	<div class="login-card">
		<div class="brand-logo">
			<i class="fas fa-shield-alt"></i>
		</div>
		<h2>Admin Access</h2>
		<p class="subtitle">Secure Node | Mazi Mandai Dharashiv</p>

		<form action="/admin/adminloginvalidate" method="post">
			<div class="form-group">
				<label>Admin Username</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"><i
							class="fas fa-user-circle"></i></span>
					</div>
					<input type="text" name="username" placeholder="Enter ID" required
						class="form-control">
				</div>
			</div>

			<div class="form-group mt-3">
				<label>Secret Password</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"><i class="fas fa-key"></i></span>
					</div>
					<input type="password" name="password" placeholder="••••••••"
						required class="form-control">
				</div>
			</div>

			<button type="submit" class="btn btn-login btn-block">
				Authorize Session <i class="fas fa-arrow-right ml-2"></i>
			</button>

			<c:if test="${not empty msg}">
				<div class="error-msg">
					<i class="fas fa-exclamation-circle mr-1"></i> ${msg}
				</div>
			</c:if>
		</form>

		<p class="footer-text">
			Protected by Mazi Mandai Security Protocols<br> © 2026 Dharashiv
			Infrastructure
		</p>
	</div>

</body>
</html>