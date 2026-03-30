<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Directory | Mazi Mandai Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root {
            --brand-orange: #FF6F00;
            --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --royal-dark: #0F172A;
            --cool-blue: #3B82F6;
        }

        body { font-family: 'Plus Jakarta Sans', sans-serif; background-color: #F8FAFC; color: var(--royal-dark); }

        /* Navbar & Header */
        .navbar { background: white !important; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border-bottom: 3px solid var(--brand-orange); }
        .crm-header { background: var(--royal-dark); padding: 50px 0; color: white; border-radius: 0 0 40px 40px; margin-bottom: 30px; }
        
        /* Table Design */
        .crm-card { background: white; border-radius: 25px; box-shadow: 0 15px 40px rgba(0,0,0,0.03); overflow: hidden; border: none; }
        .table thead th { background: #F1F5F9; border: none; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; color: #64748B; padding: 20px; }
        .table td { padding: 20px; vertical-align: middle !important; border-top: 1px solid #F1F5F9; }

        /* Customer Elements */
        .avatar-circle {
            width: 45px; height: 45px;
            background: var(--brand-gradient);
            color: white;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 800; font-size: 1.1rem;
            margin-right: 15px;
            box-shadow: 0 4px 10px rgba(255,111,0,0.2);
        }
        
        .email-link { color: var(--cool-blue); text-decoration: none; font-weight: 600; }
        .email-link:hover { text-decoration: underline; }
        
        .address-box { font-size: 0.85rem; color: #64748B; max-width: 250px; line-height: 1.4; }
        
        .role-badge {
            font-size: 0.7rem; font-weight: 800; text-transform: uppercase;
            padding: 4px 10px; border-radius: 6px;
            background: #E0F2FE; color: #0369A1;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg sticky-top">
        <div class="container">
            <a class="navbar-brand font-weight-bold" href="/admin/Dashboard">Mazi<span style="color:var(--brand-orange)">Mandai</span>.crm</a>
            <div class="ml-auto">
                <a href="/admin/Dashboard" class="btn btn-light btn-sm rounded-pill px-4 mr-2">Dashboard</a>
                <a href="/admin/logout" class="btn btn-outline-danger btn-sm rounded-pill px-4">Logout</a>
            </div>
        </div>
    </nav>

    <div class="crm-header text-center">
        <div class="container">
            <h1 class="font-weight-bold">Customer Directory</h1>
            <p class="text-muted mb-0" style="color: #94A3B8 !important;">Manage and support your Dharashiv community members.</p>
        </div>
    </div>

    <div class="container mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4 px-2">
            <h5 class="font-weight-bold mb-0">Registered Users (${customers.size()})</h5>
            <button onclick="window.print()" class="btn btn-outline-dark btn-sm rounded-pill px-3">
                <i class="fas fa-print mr-2"></i> Print List
            </button>
        </div>

        <div class="crm-card">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th width="30%">Customer</th>
                        <th width="30%">Contact Info</th>
                        <th width="25%">Shipping Address</th>
                        <th width="15%" class="text-right">Management</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="customer" items="${customers}">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-circle">
                                        ${customer.username.substring(0,1).toUpperCase()}
                                    </div>
                                    <div>
                                        <h6 class="font-weight-bold mb-0">${customer.username}</h6>
                                        <span class="role-badge">Verified User</span>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="d-flex flex-column">
                                    <a href="mailto:${customer.email}" class="email-link">
                                        <i class="far fa-envelope mr-2"></i>${customer.email}
                                    </a>
                                    <small class="text-muted mt-1"><i class="fas fa-id-card mr-2"></i>ID: #CUST-${customer.id}</small>
                                </div>
                            </td>
                            <td>
                                <div class="address-box">
                                    <i class="fas fa-map-marker-alt mr-2 text-warning"></i>
                                    <c:choose>
                                        <c:when test="${not empty customer.address}">
                                            ${customer.address}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="font-italic">No address provided</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                            <td class="text-right">
                                <a href="/admin/customers/delete?id=${customer.id}" 
                                   class="btn btn-sm btn-outline-danger rounded-circle p-2" 
                                   onclick="return confirm('Remove this user? This action cannot be undone.')"
                                   style="width: 35px; height:35px;">
                                    <i class="fas fa-user-minus"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            
            <c:if test="${empty customers}">
                <div class="text-center py-5">
                    <i class="fas fa-users-slash fa-3x text-light mb-3"></i>
                    <p class="text-muted">No customers found in the system.</p>
                </div>
            </c:if>
        </div>
    </div>

    <footer class="py-4 text-center text-muted small bg-white border-top">
        &copy; 2026 Mazi Mandai CRM | Dharashiv Support Team
    </footer>

    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</body>
</html>