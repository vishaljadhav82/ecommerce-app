<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <title>Admin Order Manager | Mazi Mandai</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f4f7f6; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .order-table-card { border-radius: 15px; border: none; box-shadow: 0 5px 20px rgba(0,0,0,0.05); }
        .status-select { border-radius: 20px; font-size: 0.8rem; font-weight: bold; }
        .badge-preparing { background: #fff3cd; color: #856404; }
        .badge-shipped { background: #d1ecf1; color: #0c5460; }
        .badge-delivered { background: #d4edda; color: #155724; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-dark shadow-sm px-4">
    <a class="navbar-brand font-weight-bold" href="/admin/Dashboard">Admin Console | <span class="text-warning">Orders</span></a>
    <a href="/admin/Dashboard" class="btn btn-outline-light btn-sm">Back to Dashboard</a>
</nav>

<div class="container-fluid mt-4">
    <div class="card order-table-card">
        <div class="card-body p-4">
            <h4 class="font-weight-bold mb-4">Incoming & Past Orders</h4>
            
            <div class="table-responsive">
                <table class="table table-hover border-0">
                    <thead class="thead-light">
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Total</th>
                            <th>Address</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td class="font-weight-bold">#MM-${order.id}</td>
                                <td>
                                    <strong>${order.customer.username}</strong><br>
                                    <small class="text-muted">${order.contact}</small>
                                </td>
                                <td class="text-success font-weight-bold">₹${order.totalAmount}</td>
                                <td style="max-width: 200px;"><small>${order.address}, ${order.pincode}</small></td>
                                <td>
                                    <form action="/admin/orders/updateStatus" method="post" class="d-flex align-items-center">
                                        <input type="hidden" name="orderId" value="${order.id}">
                                        <select name="status" class="form-control form-control-sm status-select mr-2">
                                            <option value="PREPARING" ${order.status == 'PREPARING' ? 'selected' : ''}>Preparing</option>
                                            <option value="SHIPPED" ${order.status == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                                            <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                            <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-primary rounded-circle">
                                            <i class="fas fa-check"></i>
                                        </button>
                                    </form>
                                </td>
                                <td>
                                    <a href="/admin/orders/delete/${order.id}" class="text-danger" onclick="return confirm('Delete this order record?')">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <c:if test="${empty orders}">
                <div class="text-center py-5">
                    <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                    <p class="text-muted">No orders found in the database.</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

</body>
</html>