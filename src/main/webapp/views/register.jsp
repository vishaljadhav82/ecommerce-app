<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join the Community | Mazi Mandai</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">

    <style>
        :root {
            --brand-orange: #FF6F00;
            --brand-gradient: linear-gradient(135deg, #FF6F00 0%, #FF9100 100%);
            --royal-dark: #0F172A;
            --glass: rgba(255, 255, 255, 0.9);
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #F8FAFC;
            background-image: 
                radial-gradient(at 0% 0%, rgba(255, 111, 0, 0.1) 0px, transparent 50%),
                radial-gradient(at 100% 100%, rgba(59, 130, 246, 0.05) 0px, transparent 50%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* --- 1. PREMIUM REGISTRATION CARD --- */
        .registration-card {
            background: var(--glass);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.7);
            border-radius: 32px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 500px;
            padding: 45px;
            overflow: hidden;
        }

        .brand-logo { font-size: 1.8rem; font-weight: 800; color: var(--royal-dark); text-align: center; }
        .brand-logo span { color: var(--brand-orange); }

        h3 { font-weight: 700; color: #1E293B; text-align: center; margin-top: 10px; }
        .subtitle { color: #64748B; text-align: center; font-size: 0.9rem; margin-bottom: 35px; }

        /* --- 2. FLOATING INPUT DESIGN --- */
        .form-group { position: relative; margin-bottom: 22px; }
        
        .form-control-lg {
            background: #F1F5F9 !important;
            border: 2px solid transparent !important;
            border-radius: 16px !important;
            padding: 15px 15px 15px 48px !important;
            font-size: 0.95rem !important;
            font-weight: 500;
            transition: 0.3s all ease;
        }

        .form-control-lg:focus {
            background: #FFFFFF !important;
            border-color: var(--brand-orange) !important;
            box-shadow: 0 0 0 4px rgba(255, 111, 0, 0.1) !important;
            transform: translateY(-2px);
        }

        .input-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #94A3B8;
            z-index: 10;
            transition: 0.3s;
        }

        .form-control-lg:focus + .input-icon { color: var(--brand-orange); }

        /* --- 3. PASSWORD STRENGTH METER --- */
        #strength-bar {
            height: 4px;
            width: 0%;
            background: #E2E8F0;
            margin-top: 8px;
            border-radius: 10px;
            transition: 0.4s;
        }

        /* --- 4. ACTION BUTTONS --- */
        .btn-register {
            background: var(--brand-gradient);
            border: none;
            border-radius: 16px;
            padding: 16px;
            font-weight: 800;
            color: white;
            letter-spacing: 0.5px;
            box-shadow: 0 10px 20px rgba(255, 111, 0, 0.2);
            transition: 0.3s;
            margin-top: 15px;
        }

        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(255, 111, 0, 0.3);
            color: white;
        }

        .login-link { color: var(--brand-orange); font-weight: 700; text-decoration: none; }
        .login-link:hover { text-decoration: underline; }

        .error-msg {
            background: #FFF1F2;
            color: #E11D48;
            padding: 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
            border: 1px solid #FFE4E6;
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="registration-card">
    <div class="brand-logo">Mazi<span>Mandai</span></div>
    <h3>Sign Up Now</h3>
    <p class="subtitle">Join our community in Dharashiv for fresh delivery.</p>

    <form action="/register/process" method="post">
        <div class="form-group">
            <i class="fas fa-user input-icon"></i>
            <input type="text" name="username" class="form-control form-control-lg" required placeholder="Username*">
        </div>

        <div class="form-group">
            <i class="fas fa-envelope input-icon"></i>
            <input type="email" name="email" class="form-control form-control-lg" required placeholder="Email address*">
        </div>

        <div class="form-group">
            <i class="fas fa-lock input-icon"></i>
            <input type="password" name="password" id="password" class="form-control form-control-lg" required placeholder="Create Password*">
            <div id="strength-bar"></div>
        </div>

        <div class="form-group">
            <i class="fas fa-map-marker-alt input-icon" style="top: 25px;"></i>
            <textarea name="address" class="form-control form-control-lg" rows="3" placeholder="Delivery Address" style="padding-top: 12px !important;"></textarea>
        </div>

        <button type="submit" class="btn btn-register btn-block">
            Create Account <i class="fas fa-arrow-right ml-2"></i>
        </button>

        <div class="text-center mt-4">
            <span class="text-muted small">Already a member?</span> 
            <a class="login-link small" href="/">Login here</a>
        </div>

        <c:if test="${not empty msg}">
            <div class="error-msg">
                <i class="fas fa-exclamation-circle mr-2"></i> ${msg}
            </div>
        </c:if>
    </form>
</div>

<script>
    // Simple logic to show input focus effects
    const pwd = document.getElementById('password');
    const bar = document.getElementById('strength-bar');

    pwd.addEventListener('input', () => {
        const val = pwd.value;
        if(val.length === 0) bar.style.width = '0%';
        else if(val.length < 6) { bar.style.width = '30%'; bar.style.backgroundColor = '#EF4444'; }
        else if(val.length < 10) { bar.style.width = '60%'; bar.style.backgroundColor = '#F59E0B'; }
        else { bar.style.width = '100%'; bar.style.backgroundColor = '#10B981'; }
    });
</script>

<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</body>
</html>