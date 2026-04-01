<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join Fleet | Mazi Mandai</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <style>
        body { background: #f4f7f6; padding: 30px 15px; }
        .card-reg { background: #fff; border-radius: 20px; max-width: 600px; margin: auto; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .btn-register { background: #27ae60; color: #fff; font-weight: bold; border-radius: 10px; padding: 12px; }
    </style>
</head>
<body>
    <div class="card-reg">
        <h3 class="font-weight-bold text-center mb-4">Partner Onboarding</h3>
        <form action="/delivery/register/process" method="post">
            <div class="row">
                <div class="col-md-6 form-group">
                    <label class="small font-weight-bold">FULL NAME</label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                <div class="col-md-6 form-group">
                    <label class="small font-weight-bold">EMAIL (FOR LOGIN)</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 form-group">
                    <label class="small font-weight-bold">VEHICLE TYPE</label>
                    <select name="vehicleType" class="form-control">
                        <option>Bike</option>
                        <option>Rickshaw</option>
                        <option>Bicycle</option>
                    </select>
                </div>
                <div class="col-md-6 form-group">
                    <label class="small font-weight-bold">VEHICLE NUMBER</label>
                    <input type="text" name="vehicleNumber" class="form-control" placeholder="MH-25-XX-0000" required>
                </div>
            </div>
            <div class="form-group">
                <label class="small font-weight-bold">AADHAR NUMBER</label>
                <input type="text" name="aadharNumber" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="small font-weight-bold">PASSWORD</label>
                <input type="password" name="password" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="small font-weight-bold">BASE ADDRESS (DHARASHIV)</label>
                <textarea name="address" class="form-control" rows="2" required></textarea>
            </div>
            <button type="submit" class="btn btn-register btn-block mt-3">SUBMIT APPLICATION</button>
        </form>
    </div>
</body>
</html>