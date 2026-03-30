<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Mazi Mandai</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --brand-orange: #FF6F00;
            --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --royal-dark: #0F172A;
            --glass: rgba(255, 255, 255, 0.9);
        }

        * { box-sizing: border-box; transition: all 0.3s ease; }

        body {
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            font-family: 'Plus Jakarta Sans', sans-serif;
            /* Modern Mesh Gradient Background */
            background-color: #f8fafc;
            background-image: 
                radial-gradient(at 0% 0%, rgba(255, 111, 0, 0.15) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(99, 102, 241, 0.1) 0px, transparent 50%);
        }

        .login-card {
            width: 100%;
            max-width: 420px;
            background: var(--glass);
            backdrop-filter: blur(12px);
            padding: 40px;
            border-radius: 28px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.08);
            border: 1px solid rgba(255, 255, 255, 0.7);
            text-align: center;
        }

        .brand-logo {
            font-size: 2rem;
            font-weight: 800;
            color: var(--royal-dark);
            margin-bottom: 8px;
            letter-spacing: -1px;
        }
        .brand-logo span { color: var(--brand-orange); }

        h2 { font-weight: 700; color: #1e293b; margin-bottom: 30px; font-size: 1.25rem; }

        .form-group {
            text-align: left;
            margin-bottom: 20px;
            position: relative;
        }

        label {
            font-size: 0.85rem;
            font-weight: 600;
            color: #64748b;
            margin-left: 4px;
            margin-bottom: 8px;
            display: block;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 14px 16px 14px 45px;
            background: #f1f5f9;
            border: 2px solid transparent;
            border-radius: 14px;
            font-family: inherit;
            font-size: 1rem;
            color: var(--royal-dark);
        }

        input:focus {
            outline: none;
            background: #fff;
            border-color: var(--brand-orange);
            box-shadow: 0 0 0 4px rgba(255, 111, 0, 0.1);
        }

        .toggle-password {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #94a3b8;
        }

        .login-btn {
            width: 100%;
            padding: 16px;
            margin-top: 10px;
            background: var(--brand-gradient);
            border: none;
            color: white;
            font-size: 1rem;
            font-weight: 700;
            border-radius: 14px;
            cursor: pointer;
            box-shadow: 0 10px 15px -3px rgba(255, 111, 0, 0.3);
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 20px 25px -5px rgba(255, 111, 0, 0.4);
        }

        .footer-text {
            margin-top: 25px;
            font-size: 0.9rem;
            color: #64748b;
        }

        .footer-text a {
            color: var(--brand-orange);
            font-weight: 700;
            text-decoration: none;
        }

        .error-msg {
            background: #fef2f2;
            color: #dc2626;
            padding: 12px;
            border-radius: 10px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-top: 20px;
            border: 1px solid #fee2e2;
        }
    </style>
</head>

<body>

<div class="login-card">
    <div class="brand-logo">Mazi<span>Mandai</span></div>
    <h2>Welcome Back!</h2>

    <form action="/login/process" method="post">
        <div class="form-group">
            <label for="username">Username</label>
            <div class="input-wrapper">
                <i class="fas fa-user"></i>
                <input type="text" name="username" id="username" placeholder="Enter username" required>
            </div>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <div class="input-wrapper">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" id="password" placeholder="Enter password" required>
                <i class="fas fa-eye toggle-password" id="eyeIcon"></i>
            </div>
        </div>

        <button type="submit" class="login-btn">
            Sign In <i class="fas fa-arrow-right ml-2" style="margin-left: 8px;"></i>
        </button>

        <p class="footer-text">
            New here? <a href="/register">Create an account</a>
        </p>

        <c:if test="${not empty msg}">
            <div class="error-msg">
                <i class="fas fa-exclamation-circle mr-2"></i> ${msg}
            </div>
        </c:if>
    </form>
</div>

<script>
    // Password visibility toggle logic
    const togglePassword = document.querySelector('#eyeIcon');
    const password = document.querySelector('#password');

    togglePassword.addEventListener('click', function (e) {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        this.classList.toggle('fa-eye-slash');
    });
</script>

</body>
</html>