<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Mazi Mandai</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-dark bg-success sticky-top">
        <a class="navbar-brand font-weight-bold" href="#">Mazi Mandai Logistics</a>
        <span class="navbar-text text-white small">Hi, ${partner.username}</span>
    </nav>

    <div class="container py-4">
        <h5 class="mb-4 font-weight-bold">Orders Ready for Pickup</h5>
        
        <c:if test="${empty orders}">
            <div class="text-center py-5">
                <p class="text-muted">No orders to deliver right now. Check back soon!</p>
            </div>
        </c:if>

        <div class="row">
            <c:forEach items="${orders}" var="order">
                <div class="col-md-6 mb-3">
                    <div class="card border-0 shadow-sm rounded-lg">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="badge badge-warning">SHIPPED</span>
                                <span class="small text-muted">ID: #${order.id}</span>
                            </div>
                            <h6 class="font-weight-bold mb-1">Customer Address:</h6>
                            <p class="small text-dark mb-3">${order.address}</p>
                            <form action="/delivery/order/complete" method="post">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <button type="submit" class="btn btn-success btn-sm btn-block font-weight-bold">
                                    MARK AS DELIVERED
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>