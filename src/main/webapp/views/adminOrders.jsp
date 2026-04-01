<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <title>Admin Order Manager | Mazi Mandai</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', sans-serif; }
        .order-table-card { border-radius: 15px; border: none; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        .items-row { background-color: #fcfcfd; display: none; transition: 0.3s; }
        .product-mini-img { width: 40px; height: 40px; object-fit: cover; border-radius: 8px; margin-right: 10px; border: 1px solid #eee; }
        .clickable-row { cursor: pointer; transition: 0.2s; }
        .clickable-row:hover { background-color: #f8f9fa !important; }
        .status-select { border-radius: 20px; font-size: 0.75rem; font-weight: bold; width: 110px; height: 32px !important; }
        .id-badge { background: #e2e8f0; color: #475569; padding: 5px 12px; border-radius: 8px; font-size: 0.85rem; }
        .search-bar { border-radius: 20px 0 0 20px; border-right: none; }
        .search-btn { border-radius: 0 20px 20px 0; }
        .pagination .page-link { color: #475569; border-radius: 8px; margin: 0 3px; }
        .pagination .page-item.active .page-link { background-color: #007bff; border-color: #007bff; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark shadow-sm px-4">
    <a class="navbar-brand font-weight-bold" href="/admin/Dashboard">Admin Console | <span class="text-warning">Orders</span></a>
    <div class="ml-auto">
        <a href="/admin/Dashboard" class="btn btn-outline-light btn-sm">Back to Dashboard</a>
    </div>
</nav>

<div class="container-fluid mt-4 pb-5">
    
    <div class="card border-0 shadow-sm mb-4" style="border-radius: 15px;">
        <div class="card-body">
            <form action="/admin/orders" method="get" class="row align-items-center">
                <div class="col-md-4">
                    <div class="input-group">
                        <input type="text" name="search" value="${search}" class="form-control search-bar" placeholder="Search ID or Customer...">
                        <div class="input-group-append">
                            <button class="btn btn-primary search-btn" type="submit"><i class="fas fa-search"></i></button>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-control" onchange="this.form.submit()" style="border-radius: 20px;">
                        <option value="">All Order Statuses</option>
                        <option value="PREPARING" ${status == 'PREPARING' ? 'selected' : ''}>Preparing</option>
                        <option value="SHIPPED" ${status == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                        <option value="DELIVERED" ${status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="paymentStatus" class="form-control" onchange="this.form.submit()" style="border-radius: 20px;">
                        <option value="">All Payment Statuses</option>
                        <option value="PENDING" ${paymentStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                        <option value="PAID" ${paymentStatus == 'PAID' ? 'selected' : ''}>Paid</option>
                        <option value="FAILED" ${paymentStatus == 'FAILED' ? 'selected' : ''}>Failed</option>
                    </select>
                </div>
                <div class="col-md-2 text-right">
                    <a href="/admin/orders" class="btn btn-link text-muted small">Clear Filters</a>
                </div>
            </form>
        </div>
    </div>

    <div class="card order-table-card">
        <div class="card-body p-4">
            <div class="table-responsive">
                <table class="table table-borderless">
                    <thead class="text-muted small text-uppercase">
                        <tr class="border-bottom">
                            <th>ID & Items</th>
                            <th>Customer</th>
                            <th>Total & Method</th>
                            <th>Address</th>
                            <th>Order Status</th>
                            <th>Payment Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr class="clickable-row border-bottom">
                                <td onclick="toggleItems('items-${order.id}')">
                                    <span class="id-badge font-weight-bold">#MM-${order.id}</span>
                                    <div class="mt-1 small text-primary font-weight-bold"><i class="fas fa-eye mr-1"></i> ${order.items.size()} Items</div>
                                </td>
                                <td>
                                    <div class="font-weight-bold">${order.customer.username}</div>
                                    <div class="small text-muted">${order.contact}</div>
                                </td>
                                <td>
                                    <div class="text-success font-weight-bold">₹${order.totalAmount}</div>
                                    <div class="badge badge-light border text-uppercase" style="font-size: 0.65rem;">${order.paymentMethod}</div>
                                </td>
                                <td>
                                    <div class="small" style="max-width: 150px; line-height: 1.2;">
                                        <strong>${order.area}</strong>, ${order.pincode}
                                    </div>
                                </td>
                                <td>
                                    <form action="/admin/orders/updateStatus" method="post" class="d-flex align-items-center">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <select name="status" class="form-control status-select mr-1 border-primary">
                                            <option value="PREPARING" ${order.status == 'PREPARING' ? 'selected' : ''}>Preparing</option>
                                            <option value="SHIPPED" ${order.status == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                                            <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                            <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-primary rounded-circle"><i class="fas fa-sync-alt fa-xs"></i></button>
                                    </form>
                                </td>
                                <td>
                                    <form action="/admin/orders/updatePaymentStatus" method="post" class="d-flex align-items-center">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <select name="paymentStatus" class="form-control status-select mr-1 border-success">
                                            <option value="PENDING" ${order.paymentStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                                            <option value="PAID" ${order.paymentStatus == 'PAID' ? 'selected' : ''}>Paid</option>
                                            <option value="FAILED" ${order.paymentStatus == 'FAILED' ? 'selected' : ''}>Failed</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-success rounded-circle"><i class="fas fa-check fa-xs"></i></button>
                                    </form>
                                </td>
                                <td>
                                    <a href="/admin/orders/delete/${order.id}" class="text-danger" onclick="return confirm('Delete order record?')">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                </td>
                            </tr>
                            <tr id="items-${order.id}" class="items-row">
                                <td colspan="7" class="p-0">
                                    <div class="px-5 py-3 border-left border-warning bg-light" style="border-left-width: 5px !important;">
                                        <h6 class="font-weight-bold text-muted small mb-3 text-uppercase">Packing List</h6>
                                        <div class="row">
                                            <c:forEach var="item" items="${order.items}">
                                                <div class="col-md-3 mb-2">
                                                    <div class="d-flex align-items-center bg-white p-2 rounded border shadow-sm">
                                                        <img src="${item.product.image}" class="product-mini-img" onerror="this.src='https://via.placeholder.com/50?text=Veg'">
                                                        <div class="small">
                                                            <div class="font-weight-bold">${item.product.name}</div>
                                                            <div class="text-muted">${item.quantity} kg</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 1}">
                <nav class="mt-4">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 0}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&search=${search}&status=${status}&paymentStatus=${paymentStatus}">Previous</a>
                            </li>
                        </c:if>
                        
                        <c:forEach begin="0" end="${totalPages - 1}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&search=${search}&status=${status}&paymentStatus=${paymentStatus}">${i + 1}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages - 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&search=${search}&status=${status}&paymentStatus=${paymentStatus}">Next</a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>

            <c:if test="${empty orders}">
                <div class="text-center py-5">
                    <i class="fas fa-search fa-3x text-muted mb-3"></i>
                    <p class="text-muted">No orders match your current filters.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
    function toggleItems(rowId) {
        var row = document.getElementById(rowId);
        row.style.display = (row.style.display === "table-row") ? "none" : "table-row";
    }
</script>

</body>
</html>