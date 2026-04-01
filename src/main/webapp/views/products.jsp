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
            --slate-50: #F8FAFC;
            --slate-200: #E2E8F0;
        }

        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: var(--slate-50); color: var(--royal-dark); }

        /* Navbar & Header */
        .navbar { background: white !important; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border-bottom: 3px solid var(--brand-orange); }
        .inventory-header { background: var(--royal-dark); padding: 50px 0; color: white; border-radius: 0 0 40px 40px; margin-bottom: -40px; position: relative; z-index: 1; }
        
        /* Search & Filter Bar */
        .filter-card { background: white; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); padding: 25px; margin-bottom: 30px; border: none; position: relative; z-index: 2; }
        .form-control-custom { border-radius: 12px; border: 1px solid var(--slate-200); padding: 12px 15px; height: auto; font-size: 0.9rem; transition: 0.3s; }
        .form-control-custom:focus { border-color: var(--brand-orange); box-shadow: 0 0 0 4px rgba(255, 111, 0, 0.1); }

        /* Table Design */
        .table-card { background: white; border-radius: 25px; box-shadow: 0 15px 40px rgba(0,0,0,0.03); overflow: hidden; border: none; }
        .table thead th { background: #F1F5F9; border: none; font-size: 0.75rem; text-transform: uppercase; color: #64748B; padding: 20px; letter-spacing: 0.5px; }
        .table thead th a { color: inherit; text-decoration: none; display: block; width: 100%; }
        .table td { padding: 18px; vertical-align: middle !important; border-top: 1px solid #F1F5F9; }

        /* Product Elements */
        .prod-img { width: 60px; height: 60px; object-fit: cover; border-radius: 14px; transition: 0.3s; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .prod-img:hover { transform: scale(1.1); }
        .price-badge { background: #DCFCE7; color: #15803D; font-weight: 800; padding: 6px 14px; border-radius: 10px; display: inline-block; white-space: nowrap; }
        .stock-tag { font-size: 0.75rem; font-weight: 700; color: #64748B; background: #F1F5F9; padding: 4px 12px; border-radius: 8px; }

        /* Pagination */
        .page-link { border: none; margin: 0 3px; border-radius: 10px !important; color: var(--royal-dark); font-weight: 600; padding: 10px 18px; transition: 0.3s; }
        .page-link:hover { background: var(--slate-200); color: var(--brand-orange); }
        .page-item.active .page-link { background: var(--brand-gradient); color: white; box-shadow: 0 4px 12px rgba(255, 111, 0, 0.3); }
        
        .sort-icon { font-size: 0.7rem; margin-left: 5px; opacity: 0.6; }
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

    <div class="inventory-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1 class="font-weight-bold mb-2">Inventory Control</h1>
                    <p class="text-white-50 mb-0">Smart stock management for Dharashiv Diaries</p>
                </div>
                <div class="col-md-6 text-md-right">
                    <a href="/admin/products/add" class="btn btn-lg btn-primary rounded-pill px-5 font-weight-bold shadow-lg" style="background: var(--brand-gradient); border:none;">
                        <i class="fas fa-plus-circle mr-2"></i> New Product
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div class="filter-card">
            <form action="/admin/products" method="GET" class="row align-items-end">
                <input type="hidden" name="sortDir" value="${sortDir}">
                
                <div class="col-md-5 mb-3 mb-md-0">
                    <label class="small font-weight-bold text-muted text-uppercase">Search Product</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text bg-white border-right-0" style="border-radius: 12px 0 0 12px;"><i class="fas fa-search text-muted"></i></span>
                        </div>
                        <input type="text" name="search" class="form-control form-control-custom border-left-0" value="${search}" placeholder="Search name or description...">
                    </div>
                </div>
                <div class="col-md-4 mb-3 mb-md-0">
                    <label class="small font-weight-bold text-muted text-uppercase">Category Filter</label>
                    <select name="categoryId" class="form-control form-control-custom">
                        <option value="">All Categories</option>
                        <c:forEach items="${categories}" var="cat">
                            <option value="${cat.id}" ${cat.id == categoryId ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-dark btn-block rounded-pill font-weight-bold py-2 shadow">
                        Apply Filters
                    </button>
                </div>
            </form>
        </div>

        <div class="table-card">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th width="10%">
                            <a href="/admin/products?page=${currentPage}&search=${search}&categoryId=${categoryId}&sortDir=${reverseSortDir}">
                                ID <i class="fas ${sortDir == 'asc' ? 'fa-sort-up' : 'fa-sort-down'} sort-icon"></i>
                            </a>
                        </th>
                        <th width="30%">Product Details</th>
                        <th width="15%">Category</th>
                        <th width="15%">Inventory</th>
                        <th width="15%">Price</th>
                        <th width="15%" class="text-right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${products}">
                        <tr>
                            <td><span class="text-muted font-weight-bold">#${product.id}</span></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="${product.image}" class="prod-img mr-3" onerror="this.src='https://via.placeholder.com/60'">
                                    <div>
                                        <h6 class="font-weight-bold mb-0">${product.name}</h6>
                                        <small class="text-muted text-truncate d-block" style="max-width: 200px;">${product.description}</small>
                                    </div>
                                </div>
                            </td>
                            <td><span class="badge badge-light border px-3 py-2 text-uppercase" style="font-size: 10px; letter-spacing: 0.5px;">${product.category.name}</span></td>
                            <td>
                                <div class="font-weight-bold text-dark">${product.quantity} <small class="text-muted">Units</small></div>
                                <div class="progress mt-1" style="height: 4px; width: 70px; border-radius: 10px;">
                                    <div class="progress-bar ${product.quantity < 10 ? 'bg-danger' : 'bg-success'}" 
                                         role="progressbar" 
                                         style="width: ${product.quantity > 100 ? 100 : product.quantity}%"></div>
                                </div>
                            </td>
                            <td><span class="price-badge">&#8377;${product.price}</span></td>
                            <td class="text-right">
                                <a href="/admin/products/update/${product.id}" class="btn btn-sm btn-white border shadow-sm rounded-lg px-3 mr-1 text-warning" title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="/admin/products/delete?id=${product.id}" class="btn btn-sm btn-white border shadow-sm rounded-lg px-3 text-danger" title="Delete" onclick="return confirm('Permanently delete ${product.name}?')">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty products}">
                <div class="text-center py-5">
                    <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" width="80" class="mb-3" style="opacity: 0.3;">
                    <h5 class="text-muted font-weight-bold">No results found</h5>
                    <p class="small text-muted">Try adjusting your filters or search keywords.</p>
                    <a href="/admin/products" class="btn btn-sm btn-outline-primary rounded-pill px-4 mt-2">View All Products</a>
                </div>
            </c:if>

            <div class="p-4 border-top bg-light">
                <nav class="d-flex justify-content-between align-items-center">
                    <div>
                        <p class="mb-0 text-muted small font-weight-bold">
                            Showing Page <span class="text-dark">${currentPage + 1}</span> of <span class="text-dark">${totalPages}</span>
                        </p>
                    </div>
                    <ul class="pagination mb-0">
                        <c:if test="${currentPage > 0}">
                            <li class="page-item">
                                <a class="page-link shadow-sm" href="/admin/products?page=${currentPage - 1}&search=${search}&categoryId=${categoryId}&sortDir=${sortDir}">
                                    <i class="fas fa-chevron-left mr-2"></i> Prev
                                </a>
                            </li>
                        </c:if>
                        
                        <c:if test="${currentPage + 1 < totalPages}">
                            <li class="page-item">
                                <a class="page-link shadow-sm" href="/admin/products?page=${currentPage + 1}&search=${search}&categoryId=${categoryId}&sortDir=${sortDir}">
                                    Next <i class="fas fa-chevron-right ml-2"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <footer class="py-4 text-center text-muted small bg-white border-top">
        &copy; 2026 <strong>Mazi Mandai Premium</strong> | Handcrafted by Vishal Jadhav
    </footer>

    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</body>
</html>