<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Master | Mazi Mandai Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root {
            --brand-orange: #FF6F00;
            --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --royal-dark: #0F172A;
        }

        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: #F8FAFC; color: var(--royal-dark); }

        /* Navbar & Header */
        .navbar { background: white !important; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border-bottom: 3px solid var(--brand-orange); }
        .inventory-header { background: var(--royal-dark); padding: 40px 0; color: white; border-radius: 0 0 40px 40px; margin-bottom: 30px; }
        
        /* Stats Card */
        .stat-box { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); padding: 20px; border-radius: 20px; text-align: center;}

        /* Table Design */
        .table-card { background: white; border-radius: 25px; box-shadow: 0 15px 40px rgba(0,0,0,0.03); overflow: hidden; border: none; }
        .table thead th { background: #F1F5F9; border: none; font-size: 0.7rem; text-transform: uppercase; color: #64748B; padding: 20px; }
        .table td { padding: 18px; vertical-align: middle !important; border-top: 1px solid #F1F5F9; }

        /* Product Elements */
        .prod-img { width: 60px; height: 60px; object-fit: cover; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .price-badge { background: #DCFCE7; color: #15803D; font-weight: 800; padding: 6px 12px; border-radius: 10px; display: inline-block; white-space: nowrap; }
        .stock-tag { font-size: 0.75rem; font-weight: 700; color: #64748B; background: #F1F5F9; padding: 4px 10px; border-radius: 6px; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg sticky-top">
        <div class="container">
            <a class="navbar-brand font-weight-bold" href="/admin/Dashboard" style="font-size: 1.5rem;">Mazi<span style="color:var(--brand-orange)">Mandai</span></a>
            <div class="ml-auto">
                <a href="/admin/Dashboard" class="btn btn-light btn-sm rounded-pill px-4 mr-2">Dashboard</a>
                <a href="/admin/logout" class="btn btn-outline-danger btn-sm rounded-pill px-4">Logout</a>
            </div>
        </div>
    </nav>

    <c:set var="totalValue" value="${0}" />
    <c:forEach var="p" items="${products}">
        <c:set var="totalValue" value="${totalValue + (p.price * p.quantity)}" />
    </c:forEach>

    <div class="inventory-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-7">
                    <h2 class="font-weight-bold mb-0">Product Inventory</h2>
                    <p class="text-muted mb-0" style="color: #94A3B8 !important;">Manage items for Dharashiv Diaries</p>
                </div>
                <div class="col-md-5">
                    <div class="stat-box">
                        <small class="text-uppercase font-weight-bold text-white-50" style="letter-spacing: 1px;">Stock Valuation</small>
                        <h3 class="font-weight-bold text-success mt-1">&#8377;${totalValue}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container-fluid px-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4 px-2">
            <h5 class="font-weight-bold mb-0">Active Items (${products.size()})</h5>
            <a href="/admin/products/add" class="btn btn-primary rounded-pill px-4 font-weight-bold" style="background: var(--brand-gradient); border:none;">
                <i class="fas fa-plus mr-2"></i> Add Product
            </a>
        </div>

        <div class="table-card">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th width="5%">ID</th>
                        <th width="10%">Preview</th>
                        <th width="25%">Product Details</th>
                        <th width="15%">Category</th>
                        <th width="15%">Inventory</th>
                        <th width="15%">Price</th>
                        <th width="15%" class="text-right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td><span class="text-muted small font-weight-bold">#${product.id}</span></td>
                            <td><img src="${product.image}" class="prod-img" onerror="this.src='https://via.placeholder.com/60'"></td>
                            <td>
                                <h6 class="font-weight-bold mb-0">${product.name}</h6>
                                <small class="text-muted d-block text-truncate" style="max-width: 180px;">${product.description}</small>
                            </td>
                            <td><span class="badge badge-light border px-2 py-1">${product.category.name}</span></td>
                            <td>
                                <div class="mb-1"><span class="stock-tag">${product.quantity} Units</span></div>
                                <small class="text-muted"><i class="fas fa-weight-hanging mr-1"></i>${product.weight}g</small>
                            </td>
                            <td>
                                <span class="price-badge">&#8377;${product.price}</span>
                            </td>
                            <td class="text-right">
                                <a href="/admin/products/update/${product.id}" class="btn btn-sm btn-outline-warning rounded-lg px-3 mr-1">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="/admin/products/delete?id=${product.id}" class="btn btn-sm btn-outline-danger rounded-lg px-3" onclick="return confirm('Delete this product permanently?')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty products}">
                <div class="text-center py-5">
                    <i class="fas fa-box-open fa-3x text-light mb-3"></i>
                    <p class="text-muted">No products found in the database.</p>
                </div>
            </c:if>
        </div>
    </div>

    <footer class="py-4 text-center text-muted small bg-white border-top">
        &copy; 2026 Mazi Mandai Premium | Dharashiv IT Solutions
    </footer>

    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</body>
</html>