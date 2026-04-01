<!DOCTYPE html>
<html lang="en">
<head>
    <title>Checkout | Secure Order</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css"/>

    <style>
        :root {
            --accent: #4834d4;
            --accent-soft: rgba(72, 52, 212, 0.1);
            --detect: #f0932b;
            --text-main: #2d3436;
            --text-sub: #636e72;
            --border: #dfe6e9;
            --bg-body: #f1f2f6;
        }

        body { 
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; 
            background-color: var(--bg-body); 
            color: var(--text-main);
            margin: 0;
            padding: 15px;
            display: flex;
            justify-content: center;
        }

        .checkout-card { 
            max-width: 600px; 
            width: 100%;
            background: #ffffff; 
            padding: 30px; 
            border-radius: 16px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        h2 { 
            text-align: center; 
            font-size: 1.6rem;
            margin-bottom: 25px;
            color: #2f3542;
        }

        /* Detect Location Button */
        .btn-detect {
            background: var(--detect);
            color: white;
            border: none;
            padding: 14px;
            width: 100%;
            font-weight: 700;
            cursor: pointer;
            border-radius: 10px;
            transition: all 0.2s ease;
            margin-bottom: 20px;
            font-size: 0.95rem;
            box-shadow: 0 4px 12px rgba(240, 147, 43, 0.2);
        }

        .btn-detect:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn-detect:active { transform: scale(0.98); }

        /* Form Styling */
        .form-row { display: flex; gap: 15px; }
        .form-group { flex: 1; margin-bottom: 18px; }
        
        label { 
            display: block; 
            margin-bottom: 6px; 
            font-size: 0.85rem;
            font-weight: 600; 
            color: var(--text-sub); 
        }
        
        input, textarea, select {
            width: 100%;
            padding: 12px;
            border: 1.5px solid var(--border);
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 14px;
            transition: border-color 0.2s;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: var(--accent);
            background-color: #fff;
        }

        /* Map Styling */
        #map { 
            height: 280px; 
            margin: 20px 0; 
            border-radius: 12px; 
            z-index: 1;
        }

        .btn-submit {
            background: var(--accent);
            color: white;
            border: none;
            padding: 16px;
            width: 100%;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            border-radius: 10px;
            box-shadow: 0 6px 15px rgba(72, 52, 212, 0.25);
        }

        .btn-submit:hover { background: #3c2bb3; }

        .status-loader { 
            text-align: center;
            font-size: 0.8rem;
            color: var(--accent);
            font-weight: bold;
            display: none;
            margin-bottom: 10px;
        }

        /* Responsive UI */
        @media (max-width: 500px) {
            .form-row { flex-direction: column; gap: 0; }
            .checkout-card { padding: 20px; border-radius: 12px; }
        }
    </style>
</head>
<body>

<div class="checkout-card">
    <h2>Secure Checkout</h2>

    <form action="/cart/placeOrder" method="post">
        <input type="hidden" name="latitude" id="latitude">
        <input type="hidden" name="longitude" id="longitude">

        <button type="button" class="btn-detect" onclick="getLocation()">
            📍 USE MY CURRENT LOCATION
        </button>
        
        <div id="statusMsg" class="status-loader">Detecting your address...</div>

        <div class="form-row">
            <div class="form-group">
                <label>Country</label>
                <input name="country" id="country" placeholder="Country">
            </div>
            <div class="form-group">
                <label>State</label>
                <input name="state" id="state" placeholder="State">
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>City</label>
                <input name="city" id="city" placeholder="City">
            </div>
            <div class="form-group">
                <label>PIN Code</label>
                <input name="pincode" id="pincode" placeholder="Postal Code">
            </div>
        </div>

        <div class="form-group">
            <label>Area / Suburb</label>
            <input name="area" id="area" placeholder="Locality or Neighborhood">
        </div>

        <div class="form-group">
            <label>Road / Landmark</label>
            <input name="road" id="road" placeholder="House No, Street, Landmark">
        </div>

        <div class="form-group">
            <label>Full Address</label>
            <textarea name="address" id="fullAddress" rows="2" placeholder="Complete address will appear here"></textarea>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Mobile Number</label>
                <input name="contact" type="tel" required placeholder="Phone">
            </div>
            <div class="form-group">
                <label>Payment</label>
                <select name="paymentMethod">
                    <option value="COD">Cash on Delivery</option>
                    <option value="UPI">UPI / GPay / PhonePe</option>
                    <option value="CARD">Credit/Debit Card</option>
                </select>
            </div>
        </div>

        <div id="map"></div>

        <button type="submit" class="btn-submit">PLACE ORDER NOW</button>
    </form>
</div>

<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

<script>
    // 1. Initial Map Setup
    let map = L.map('map').setView([20, 0], 2); 
    let marker;

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap'
    }).addTo(map);

    // 2. Get Coordinates
    function getLocation() {
        const loader = document.getElementById("statusMsg");
        if (!navigator.geolocation) {
            alert("Browser doesn't support geolocation.");
            return;
        }
        loader.style.display = "block";
        navigator.geolocation.getCurrentPosition(success, error, {
            enableHighAccuracy: true,
            timeout: 8000
        });
    }

    // 3. Handle Success
    function success(position) {
        const lat = position.coords.latitude;
        const lon = position.coords.longitude;
        const loader = document.getElementById("statusMsg");

        document.getElementById("latitude").value = lat;
        document.getElementById("longitude").value = lon;

        map.setView([lat, lon], 16);
        if (marker) map.removeLayer(marker);
        marker = L.marker([lat, lon]).addTo(map).bindPopup("Deliver here").openPopup();

        // Reverse Geocoding (Convert Lat/Lon to Address)
        fetch(`https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lon}&addressdetails=1`)
            .then(res => res.json())
            .then(data => {
                loader.style.display = "none";
                const a = data.address || {};

                document.getElementById("country").value = a.country || "";
                document.getElementById("state").value = a.state || "";
                document.getElementById("city").value = a.city || a.town || a.village || "";
                document.getElementById("area").value = a.suburb || a.neighbourhood || a.district || "";
                document.getElementById("road").value = a.road || a.residential || "";
                document.getElementById("pincode").value = a.postcode || "";
                document.getElementById("fullAddress").value = data.display_name || "";
            })
            .catch(() => {
                loader.style.display = "none";
                alert("Location pinpointed, please confirm address manually.");
            });
    }

    function error(err) {
        document.getElementById("statusMsg").style.display = "none";
        alert("Please enable Location Permissions in your browser.");
    }
</script>

</body>
</html>