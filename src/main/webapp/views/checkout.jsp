<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
    <title>Secure Checkout | Mazi Mandai</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <style>
        .checkout-box { border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .btn-place { background: #FF6F00; color: white; font-weight: 800; border-radius: 12px; padding: 15px; }
    </style>
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card checkout-box p-4">
                <h3 class="font-weight-bold text-center mb-4">Delivery Address</h3>
                <form action="/cart/placeOrder" method="post">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" class="form-control" value="${user.username}" readonly>
                    </div>
                    <div class="form-group">
                        <label>Area / Locality in Dharashiv</label>
                        <textarea name="address" class="form-control" placeholder="Flat No, Landmark, Area..." required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-6">
                            <label>Pincode</label>
                            <input type="text" name="pincode" class="form-control" placeholder="413501" required>
                        </div>
                        <div class="col-6">
                            <label>Contact Number</label>
                            <input type="text" name="contact" class="form-control" placeholder="+91" required>
                        </div>
                    </div>
                    
                    <h5 class="mt-4 font-weight-bold">Payment Method</h5>
                    <div class="custom-control custom-radio mb-2">
                        <input type="radio" id="cod" name="paymentMethod" value="COD" class="custom-control-input" checked>
                        <label class="custom-control-label" for="cod">Cash on Delivery (Pay at Mandai)</label>
                    </div>
                    <div class="custom-control custom-radio mb-4">
                        <input type="radio" id="upi" name="paymentMethod" value="UPI" class="custom-control-input">
                        <label class="custom-control-label" for="upi">Online UPI / PhonePe</label>
                    </div>

                    <div class="bg-dark text-white p-3 rounded mb-4 d-flex justify-content-between">
                        <span>Final Amount:</span>
                        <span class="h4 mb-0">₹${total}</span>
                    </div>

                    <button type="submit" class="btn btn-place btn-block">CONFIRM ORDER</button>
                </form>
            </div>
        </div>
    </div>
</div>

</body>
</html>