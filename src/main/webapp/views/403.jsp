<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied | Mazi Mandai</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --primary-green: #27ae60;
            --dark-bg: #1a1a2e;
            --text-muted: #6c757d;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8fbf9;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            color: #333;
        }

        .error-card {
            background: white;
            padding: 50px 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.08);
            max-width: 500px;
            width: 90%;
            text-align: center;
            border-top: 8px solid var(--primary-green);
            transition: transform 0.3s ease;
        }

        .error-card:hover {
            transform: translateY(-5px);
        }

        .icon-box {
            font-size: 80px;
            color: #e74c3c;
            margin-bottom: 20px;
            animation: shake 0.5s ease-in-out infinite alternate;
        }

        @keyframes shake {
            from { transform: rotate(-5deg); }
            to { transform: rotate(5deg); }
        }

        h1 {
            margin: 10px 0;
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-bg);
        }

        p {
            color: var(--text-muted);
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .btn {
            padding: 12px 25px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background-color: var(--primary-green);
            color: white;
        }

        .btn-primary:hover {
            background-color: #219150;
            box-shadow: 0 5px 15px rgba(39, 174, 96, 0.3);
        }

        .btn-outline {
            border: 2px solid #dee2e6;
            color: #495057;
        }

        .btn-outline:hover {
            background-color: #f8f9fa;
            border-color: #adb5bd;
        }

        .brand-footer {
            margin-top: 30px;
            font-size: 0.85rem;
            color: #adb5bd;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
    </style>
</head>
<body>

    <div class="error-card">
        <div class="icon-box">
            <i class="fas fa-user-lock"></i>
        </div>
        
        <h1>Strictly Private!</h1>
        <p>It looks like you're trying to enter a restricted area of <strong>Mazi Mandai</strong>. Only admins have access here.</p>
        
        <div class="btn-group">
            <a href="/" class="btn btn-primary">
                <i class="fas fa-shopping-basket"></i> Back to Shopping
            </a>
            
            <a href="/admin/adminLogin" class="btn btn-outline">
                <i class="fas fa-sign-in-alt"></i> Admin Login
            </a>
        </div>

        <div class="brand-footer">
            Dharashiv's Fresh Marketplace
        </div>
    </div>

</body>
</html>