<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category Management | Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root {
            --brand-orange: #FF6F00;
            --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --royal-dark: #0F172A;
        }

        body { 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            background-color: #F8FAFC; 
            color: var(--royal-dark);
        }

        /* --- MODERN NAVBAR --- */
        .navbar { background: white !important; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border-bottom: 2px solid var(--brand-orange); }
        .navbar-brand { font-weight: 800; color: var(--royal-dark) !important; }
        .navbar-brand span { color: var(--brand-orange); }

        /* --- PAGE HEADER --- */
        .page-header { background: var(--royal-dark); padding: 40px 0; color: white; border-radius: 0 0 30px 30px; margin-bottom: 30px; }

        /* --- TABLE DESIGN --- */
        .data-card { border: none; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.03); background: white; overflow: hidden; }
        .table { margin-bottom: 0; }
        .table thead th { background: #F1F5F9; border: none; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 1px; color: #64748B; padding: 20px; }
        .table tbody td { padding: 20px; vertical-align: middle; border-top: 1px solid #F1F5F9; }

        /* --- BUTTONS & MODALS --- */
        .btn-brand { background: var(--brand-gradient); color: white; border: none; font-weight: 700; border-radius: 12px; transition: 0.3s; }
        .btn-brand:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(255,111,0,0.3); color: white; }
        
        .modal-content { border: none; border-radius: 25px; box-shadow: 0 25px 50px rgba(0,0,0,0.1); }
        .modal-header { border-bottom: 1px solid #F1F5F9; padding: 25px; }
        .form-control { border-radius: 12px; padding: 12px; border: 2px solid #E2E8F0; }
        .form-control:focus { border-color: var(--brand-orange); box-shadow: none; }

        .sn-badge { background: #F1F5F9; color: #475569; padding: 5px 12px; border-radius: 8px; font-weight: 800; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg sticky-top">
        <div class="container">
            <a class="navbar-brand" href="/admin/Dashboard">Mazi<span>Mandai</span></a>
            <div class="ml-auto">
                <a href="/admin/Dashboard" class="btn btn-light btn-sm rounded-pill px-3 mr-2">Dashboard</a>
                <a href="/admin/logout" class="btn btn-outline-danger btn-sm rounded-pill px-3">Logout</a>
            </div>
        </div>
    </nav>

    <div class="page-header">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <h2 class="font-weight-bold mb-0">Category Vault</h2>
                <p class="text-muted mb-0" style="color: #94A3B8 !important;">Organize your Dharashiv inventory</p>
            </div>
            <button class="btn btn-brand px-4 py-2" data-toggle="modal" data-target="#addCategoryModal">
                <i class="fas fa-plus-circle mr-2"></i> Add New Category
            </button>
        </div>
    </div>

    <div class="container mb-5">
        <div class="data-card">
            <table class="table">
                <thead>
                    <tr>
                        <th width="10%">ID</th>
                        <th width="60%">Category Name</th>
                        <th width="30%" class="text-right">Management</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="category" items="${categories}">
                        <tr>
                            <td><span class="sn-badge">${category.id}</span></td>
                            <td><h6 class="font-weight-bold mb-0 text-dark">${category.name}</h6></td>
                            <td class="text-right">
                                <div class="btn-group">
                                    <button class="btn btn-sm btn-outline-warning mr-2 rounded-lg" 
                                            onclick="openUpdateModal('${category.id}', '${category.name}')">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <a href="/admin/categories/delete?id=${category.id}" 
                                       class="btn btn-sm btn-outline-danger rounded-lg"
                                       onclick="return confirm('Archive this category?')">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="addCategoryModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content p-3">
                <form action="categories" method="post">
                    <div class="modal-header border-0">
                        <h4 class="font-weight-bold">New Category</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <label class="small font-weight-bold">CATEGORY NAME</label>
                        <input type="text" name="categoryname" class="form-control" placeholder="e.g. Organic Fruits" required>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="submit" class="btn btn-brand btn-block py-3">Save Category</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="updateCategoryModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content p-3">
                <form action="categories/update" method="get">
                    <div class="modal-header border-0">
                        <h4 class="font-weight-bold">Update Category</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group mb-3">
                            <label class="small font-weight-bold">ID (Read Only)</label>
                            <input type="text" name="categoryid" id="upd_id" class="form-control bg-light" readonly>
                        </div>
                        <div class="form-group">
                            <label class="small font-weight-bold">RENAME CATEGORY</label>
                            <input type="text" name="categoryname" id="upd_name" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="submit" class="btn btn-brand btn-block py-3">Apply Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Efficient Update Handler: No more loop-based modals!
        function openUpdateModal(id, name) {
            document.getElementById('upd_id').value = id;
            document.getElementById('upd_name').value = name;
            $('#updateCategoryModal').modal('show');
        }
    </script>

    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
</body>
</html>