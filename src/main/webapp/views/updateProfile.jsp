<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Account | Mazi Mandai Premium</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root {
            --brand-orange: #FF6F00;
            --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --royal-dark: #0F172A;
            --bg-light: #F1F5F9;
        }

        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--bg-light); color: var(--royal-dark); }

        /* Navbar Styling */
        .navbar { background: white !important; border-bottom: 2px solid var(--brand-orange); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .navbar-brand { font-weight: 800; }
        .navbar-brand span { color: var(--brand-orange); }

        /* Dashboard Sidebar */
        .dashboard-wrapper { margin-top: 40px; margin-bottom: 60px; }
        .profile-sidebar { background: white; border-radius: 20px; padding: 25px; box-shadow: 0 10px 25px rgba(0,0,0,0.03); }
        
        .sidebar-link {
            display: flex; align-items: center; padding: 12px 15px; color: #64748B;
            font-weight: 600; border-radius: 12px; transition: 0.3s; text-decoration: none !important;
        }
        .sidebar-link i { width: 30px; }
        .sidebar-link:hover, .sidebar-link.active { background: rgba(255, 111, 0, 0.1); color: var(--brand-orange); }

        /* Form Styling */
        .main-content { background: white; border-radius: 20px; padding: 40px; box-shadow: 0 10px 25px rgba(0,0,0,0.03); }
        .form-label { font-weight: 700; font-size: 0.75rem; color: #94A3B8; text-transform: uppercase; letter-spacing: 1px; }
        .form-control { border: 2px solid #E2E8F0; border-radius: 12px; padding: 12px; font-weight: 600; height: auto; }
        .form-control:focus { border-color: var(--brand-orange); box-shadow: 0 0 0 4px rgba(255, 111, 0, 0.1); }
        
        .btn-save { background: var(--brand-gradient); color: white; border: none; border-radius: 12px; padding: 15px; font-weight: 800; transition: 0.3s; }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(255, 111, 0, 0.2); color: white; }

        /* Alert Styling */
        .custom-alert { border-radius: 15px; border: none; font-weight: 600; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/">Mazi<span>Mandai</span></a>
        <div class="ml-auto">
            <a href="/logout" class="btn btn-sm btn-outline-danger px-3 rounded-pill font-weight-bold">Logout</a>
        </div>
    </div>
</nav>

<div class="container dashboard-wrapper">
    <c:if test="${param.success eq 'true'}">
        <div class="alert alert-success custom-alert shadow-sm mb-4">
            <i class="fas fa-check-circle mr-2"></i> Profile updated successfully! Dharashiv Mandai has saved your changes.
        </div>
    </c:if>

    <div class="row">
        <div class="col-lg-3 mb-4">
            <div class="profile-sidebar text-center mb-4">
                <div class="bg-light rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width: 70px; height: 70px;">
                    <i class="fas fa-user-circle fa-3x text-warning"></i>
                </div>
                <h5 class="font-weight-bold mb-0">${user.username}</h5>
                <p class="small text-muted">MCA Student Member</p>
            </div>

            <div class="profile-sidebar p-2">
                <a href="/user/profile" class="sidebar-link active"><i class="fas fa-id-card"></i> Profile Info</a>
                <a href="/user/orders" class="sidebar-link"><i class="fas fa-shopping-bag"></i> My Orders</a>
                <a href="/" class="sidebar-link"><i class="fas fa-store"></i> Shop Fresh</a>
                <a href="/logout" class="sidebar-link text-danger"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="main-content">
                <h3 class="font-weight-bold mb-4">Update Profile Details</h3>
                
                <form action="/user/profile/update" method="post">
                    <input type="hidden" name="id" value="${user.id}">

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Full Name</label>
                            <input type="text" class="form-control" value="${user.username}" >
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Email Address (Permanent)</label>
                            <input type="email" name="email" class="form-control" value="${user.email}" readonly style="background: #f8fafc; cursor: not-allowed;">
                        </div>

                        <div class="col-md-12 mb-4">
                            <label class="form-label">Delivery Address in Dharashiv</label>
                            <textarea name="address" class="form-control" rows="4" required placeholder="Apartment, Street, Landmark...">${user.address}</textarea>
                        </div>

                        <div class="col-md-5">
                            <button type="submit" class="btn btn-save btn-block">
                                SAVE CHANGES <i class="fas fa-check-double ml-2"></i>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<footer class="text-center text-muted py-5">
    <small>&copy; 2026 Mazi Mandai | Local E-Commerce for Dharashiv</small>
</footer>

</body>
</html>