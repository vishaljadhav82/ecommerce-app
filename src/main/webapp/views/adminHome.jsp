<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Command Center | Mazi Mandai</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #6366F1 0%, #A855F7 100%);
            --orange-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --danger-soft: #FEF2F2;
            --glass: rgba(255, 255, 255, 0.95);
            --dark-bg: #0F172A;
        }

        body { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            background-color: #F8FAFC; 
            color: #1E293B;
        }

        /* --- MODERN UI COMPONENTS --- */
        .navbar {
            background: var(--glass) !important;
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(0,0,0,0.05);
            padding: 15px 0;
        }
        .navbar-brand { font-weight: 800; font-size: 1.5rem; color: var(--dark-bg) !important; }
        .navbar-brand span { color: #FF6F00; }

        .admin-hero {
            background: var(--dark-bg);
            padding: 60px 0 100px 0;
            color: white;
            border-radius: 0 0 50px 50px;
        }

        .stat-card {
            background: white;
            border: none;
            border-radius: 24px;
            padding: 30px;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            margin-top: -40px;
        }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 20px 40px rgba(0,0,0,0.08); }

        .icon-box {
            width: 50px; height: 50px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; margin-bottom: 15px; color: white;
        }
        .bg-purple { background: var(--primary-gradient); }
        .bg-orange { background: var(--orange-gradient); }
        .bg-green { background: linear-gradient(135deg, #22C55E 0%, #10B981 100%); }
        .bg-blue { background: linear-gradient(135deg, #3B82F6 0%, #2563EB 100%); }

        .card-link-btn {
            background: #F1F5F9; color: #475569;
            font-weight: 700; border-radius: 12px;
            padding: 10px; display: block; text-align: center;
            text-decoration: none !important; transition: 0.3s;
        }
        .card-link-btn:hover { background: var(--dark-bg); color: white; }

        /* --- SEEDER SECTION --- */
        .seeder-box {
            border: 2px dashed #FDA4AF !important;
            background: #FFF1F2;
            border-radius: 24px;
            padding: 25px;
            margin-top: 30px;
        }

        .modal-content { border-radius: 28px; border: none; }
    </style>
</head>

<body>

    <nav class="navbar navbar-expand-lg sticky-top">
        <div class="container">
            <a class="navbar-brand" href="#">Mazi<span>Mandai</span>.admin</a>
            <div class="ml-auto">
                <a href="/logout" class="btn btn-outline-danger btn-sm rounded-pill px-4">Logout</a>
            </div>
        </div>
    </nav>

    <div class="admin-hero text-center">
        <div class="container">
            <h1 class="display-4 font-weight-bold">Executive Dashboard</h1>
            <p class="lead opacity-75">Welcome back, Vishal. Managing Dharashiv Operations.</p>
        </div>
    </div>

    <div class="container">
        <c:if test="${param.seeded == 'true'}">
            <div class="alert alert-success border-0 shadow-sm rounded-pill px-4 mb-4 mt-2 d-flex align-items-center">
                <i class="fas fa-check-circle mr-3"></i>
                <strong>Database Populated!</strong> 150 products successfully added.
                <button type="button" class="close ml-auto" data-dismiss="alert">&times;</button>
            </div>
        </c:if>

        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="icon-box bg-purple"><i class="fas fa-layer-group"></i></div>
                    <h5 class="font-weight-bold text-muted small">CATALOG</h5>
                    <h3 class="font-weight-bold">Categories</h3>
                    <a href="/admin/categories" class="card-link-btn">Open Manager</a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="icon-box bg-orange"><i class="fas fa-apple-alt"></i></div>
                    <h5 class="font-weight-bold text-muted small">INVENTORY</h5>
                    <h3 class="font-weight-bold">Products</h3>
                    <a href="/admin/products" class="card-link-btn">Manage Stock</a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="icon-box bg-green"><i class="fas fa-users"></i></div>
                    <h5 class="font-weight-bold text-muted small">COMMUNITY</h5>
                    <h3 class="font-weight-bold">Users</h3>
                    <a href="/admin/customers" class="card-link-btn">View Records</a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="icon-box bg-blue"><i class="fas fa-truck"></i></div>
                    <h5 class="font-weight-bold text-muted small">FULFILLMENT</h5>
                    <h3 class="font-weight-bold">Orders</h3>
                    <a href="/admin/orders" class="card-link-btn" style="background: var(--dark-bg); color: white;">Manage Orders</a>
                </div>
            </div>
        </div>

        <div class="seeder-box">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h5 class="text-danger font-weight-bold mb-1">
                        <i class="fas fa-database mr-2"></i>Database Initialization
                    </h5>
                    <p class="text-muted small mb-0">
                        Automatically populate 150 products across Mobiles, Fruits, Groceries, Spices, and Snacks.
                    </p>
                </div>
                <div class="col-md-4 text-md-right mt-3 mt-md-0">
                    <button type="button" class="btn btn-danger rounded-pill px-4 font-weight-bold shadow-sm" data-toggle="modal" data-target="#seedModal">
                        Seed Initial Data
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="seedModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content shadow-lg">
                <div class="modal-body text-center p-5">
                    <div class="text-danger mb-4"><i class="fas fa-exclamation-circle fa-4x"></i></div>
                    <h3 class="font-weight-bold">Seed 150 Products?</h3>
                    <p class="text-secondary">This action will populate the catalog. Please ensure you haven't seeded already to avoid duplicates.</p>
                    
                    <div class="alert alert-warning small text-left py-2">
                        Requires Category IDs 1, 2, 3, 4, 5 to exist.
                    </div>

                    <div class="d-flex flex-column mt-4">
                        <a href="/admin/system/seed-data" class="btn btn-danger btn-lg rounded-pill font-weight-bold mb-2 shadow">
                            Confirm and Seed
                        </a>
                        <button type="button" class="btn btn-link text-muted" data-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="text-center py-5 text-muted small">
        &copy; 2026 Mazi Mandai | Developed for Dharashiv Diaries
    </footer>

    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</body>
</html>