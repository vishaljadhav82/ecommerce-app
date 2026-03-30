<%-- 1. ADD THIS AT THE VERY TOP TO FIX THE GARBLED SYMBOLS --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            --glass: rgba(255, 255, 255, 0.95);
            --dark-bg: #0F172A;
            --success-bg: #DCFCE7;
            --success-text: #15803D;
        }

        body { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            background-color: #F8FAFC; 
            color: #1E293B;
            overflow-x: hidden;
        }

        /* --- 1. MODERN NAVBAR --- */
        .navbar {
            background: var(--glass) !important;
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(0,0,0,0.05);
            padding: 15px 0;
        }
        .navbar-brand { font-weight: 800; font-size: 1.5rem; color: var(--dark-bg) !important; }
        .navbar-brand span { color: #FF6F00; }

        /* --- 2. HERO JUMBOTRON --- */
        .admin-hero {
            background: var(--dark-bg);
            padding: 60px 0;
            color: white;
            border-radius: 0 0 50px 50px;
            margin-bottom: -50px;
        }
        .hero-badge {
            background: rgba(255,255,255,0.1);
            padding: 8px 20px;
            border-radius: 50px;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        /* --- 3. 100x STAT CARDS --- */
        .stat-card {
            background: white;
            border: none;
            border-radius: 24px;
            padding: 30px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            position: relative;
            overflow: hidden;
        }
        .stat-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
        }
        .icon-box {
            width: 60px; height: 60px;
            border-radius: 18px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem; margin-bottom: 20px;
            color: white;
        }
        .bg-purple { background: var(--primary-gradient); }
        .bg-orange { background: var(--orange-gradient); }
        .bg-green { background: linear-gradient(135deg, #22C55E 0%, #10B981 100%); }
        .bg-blue { background: linear-gradient(135deg, #3B82F6 0%, #2563EB 100%); }

        .card-link-btn {
            background: #F1F5F9;
            color: #475569;
            font-weight: 700;
            border-radius: 12px;
            padding: 10px 20px;
            text-decoration: none !important;
            display: block;
            transition: 0.3s;
        }
        .card-link-btn:hover { background: var(--dark-bg); color: white; }

        /* --- 4. QUICK ACTION BAR --- */
        .action-bar {
            background: white;
            padding: 25px;
            border-radius: 24px;
            margin-top: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
            border: 1px solid #F1F5F9;
        }
        .growth-badge {
            background: var(--success-bg);
            color: var(--success-text);
            padding: 4px 10px;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 800;
            margin-left: 10px;
        }
    </style>
</head>

<body>

    <nav class="navbar navbar-expand-lg sticky-top">
        <div class="container">
            <a class="navbar-brand" href="#">Mazi<span>Mandai</span>.admin</a>
            <div class="ml-auto">
                <a href="/admin/logout" class="btn btn-outline-danger btn-sm rounded-pill font-weight-bold px-4">
                    <i class="fas fa-power-off mr-2"></i>Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="admin-hero text-center">
        <div class="container">
            <span class="hero-badge">System Status: Operational</span>
            <h1 class="display-4 font-weight-bold mt-3">Executive Dashboard</h1>
            <p class="lead opacity-75">Welcome back, Vishal. Managing Dharashiv Operations.</p>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="icon-box bg-purple shadow-lg">
                        <i class="fas fa-layer-group"></i>
                    </div>
                    <h5 class="font-weight-bold text-muted mb-1 text-uppercase small" style="letter-spacing: 1px;">Catalog</h5>
                    <h3 class="font-weight-bold">Categories</h3>
                    <p class="small text-secondary mb-4">Group products by type.</p>
                    <a href="/admin/categories" class="card-link-btn text-center">Open Manager</a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="icon-box bg-orange shadow-lg">
                        <i class="fas fa-apple-alt"></i>
                    </div>
                    <h5 class="font-weight-bold text-muted mb-1 text-uppercase small" style="letter-spacing: 1px;">Inventory</h5>
                    <h3 class="font-weight-bold">Products</h3>
                    <p class="small text-secondary mb-4">Add or Edit items.</p>
                    <a href="/admin/products" class="card-link-btn text-center">Manage Stock</a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="icon-box bg-green shadow-lg">
                        <i class="fas fa-users text-white"></i>
                    </div>
                    <h5 class="font-weight-bold text-muted mb-1 text-uppercase small" style="letter-spacing: 1px;">Community</h5>
                    <h3 class="font-weight-bold">Customers</h3>
                    <p class="small text-secondary mb-4">Support your users.</p>
                    <a href="/admin/customers" class="card-link-btn text-center">User Records</a>
                </div>
            </div>

            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stat-card">
                    <div class="icon-box bg-blue shadow-lg">
                        <i class="fas fa-truck"></i>
                    </div>
                    <h5 class="font-weight-bold text-muted mb-1 text-uppercase small" style="letter-spacing: 1px;">Fulfillment</h5>
                    <h3 class="font-weight-bold">Active Orders</h3>
                    <p class="small text-secondary mb-4">Track deliveries.</p>
                    <a href="/admin/orders" class="card-link-btn text-center" style="background: var(--dark-bg); color: white;">Manage Orders</a>
                </div>
            </div>
        </div>

        <div class="action-bar d-flex justify-content-between align-items-center mb-5">
            <div>
                <h6 class="text-uppercase font-weight-bold text-muted small mb-1" style="letter-spacing: 1px;">System Performance</h6>
                <div class="d-flex align-items-center">
                    <h4 class="mb-0 font-weight-bold">Revenue: <span class="text-success">&#8377;1,24,500</span></h4>
                    <span class="growth-badge"><i class="fas fa-arrow-up mr-1"></i> 12%</span>
                </div>
                <p class="text-muted small mb-0 mt-1">Calculated for current billing cycle (March 2026)</p>
            </div>
            <div class="d-flex">
                <button class="btn btn-light rounded-pill mr-2 font-weight-bold"><i class="fas fa-file-export mr-2 text-primary"></i>Export Report</button>
                <a href="/" class="btn btn-primary rounded-pill px-4 shadow font-weight-bold">Visit Shop <i class="fas fa-external-link-alt ml-2"></i></a>
            </div>
        </div>
    </div>

    <footer class="text-center py-5 text-muted small">
        &copy; 2026 Mazi Mandai | Admin Portal v4.0 | Developed for Dharashiv Diaries
    </footer>

    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</body>
</html>