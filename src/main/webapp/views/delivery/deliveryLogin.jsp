<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Partner Login | Mazi Mandai</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: #121212; color: #fff; font-family: 'Inter', sans-serif; display: flex; align-items: center; height: 100vh; }
        .card-login { background: #1e1e1e; border: 1px solid #333; border-radius: 20px; padding: 30px; width: 100%; max-width: 400px; margin: auto; }
        .form-control { background: #2d2d2d; border: 1px solid #444; color: #fff; border-radius: 10px; }
        .form-control:focus { background: #333; color: #fff; border-color: #27ae60; }
        .btn-partner { background: #27ae60; border: none; font-weight: bold; padding: 12px; border-radius: 10px; }
    </style>
</head>
<body>
    <div class="card-login shadow">
        <div class="text-center mb-4">
            <i class="fas fa-shipping-fast fa-3x text-success mb-3"></i>
            <h4 class="font-weight-bold">Partner Login</h4>
            <p class="text-muted small">Mazi Mandai Logistics • Dharashiv</p>
        </div>
        
        <c:if test="${not empty param.msg}"><div class="alert alert-success small">${param.msg}</div></c:if>
        <c:if test="${not empty param.error}"><div class="alert alert-danger small">Invalid Credentials</div></c:if>

        <form action="/delivery/login/process" method="post">
            <div class="form-group">
                <label class="small">EMAIL ID</label>
                <input type="email" name="username" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="small">PASSWORD</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-partner btn-block text-white mt-4">LOGIN TO FLEET</button>
        </form>
        <div class="text-center mt-3">
            <a href="/delivery/register" class="small text-success">New Partner? Register Here</a>
        </div>
    </div>
</body>
</html>