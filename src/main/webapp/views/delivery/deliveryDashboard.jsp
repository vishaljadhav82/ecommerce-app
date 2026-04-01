<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mazi Mandai | Logistics</title>
    
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine@3.2.12/dist/leaflet-routing-machine.css" />

    <style>
        :root { --brand: #10ac84; }
        body { background-color: #f1f2f6; font-family: 'Segoe UI', sans-serif; }
        .navbar { background-color: var(--brand) !important; }
        .order-card { border: none; border-radius: 12px; margin-bottom: 20px; }
        
        /* Ensure map has height and is visible */
        .map-wrapper { display: none; margin-top: 15px; }
        .map-container { 
            height: 300px; 
            width: 100%; 
            background: #eee; 
            border-radius: 10px; 
            border: 2px solid #ddd;
        }
        
        /* Hide the annoying text instructions box */
        .leaflet-routing-container { display: none !important; }
        
        .btn-route { background: #e8f5e9; color: var(--brand); font-weight: bold; border: 1px solid var(--brand); }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand font-weight-bold" href="#">🥦 Mazi Mandai Logistics</a>
        </div>
    </nav>

    <div class="container py-4">
        <div class="row">
            <c:forEach items="${orders}" var="order">
                <div class="col-md-6 col-lg-4">
                    <div class="card order-card shadow-sm">
                        <div class="card-body">
                            <h6 class="font-weight-bold">Order #${order.id}</h6>
                            <p class="small text-muted">${order.houseNo}, ${order.area}, ${order.city}</p>
                            
                            <button class="btn btn-sm btn-route btn-block" 
                                    onclick="initLiveRoute('${order.id}', ${order.latitude}, ${order.longitude})">
                                📍 View Live Route
                            </button>

                            <div id="wrapper-${order.id}" class="map-wrapper">
                                <div id="map-${order.id}" class="map-container"></div>
                                <div id="error-${order.id}" class="small text-danger mt-1"></div>
                            </div>

                            <form action="/delivery/order/complete" method="post" class="mt-3">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <button type="submit" class="btn btn-success btn-block btn-sm font-weight-bold">MARK AS DELIVERED</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet-routing-machine@3.2.12/dist/leaflet-routing-machine.js"></script>
    
    <script>
        let maps = {}; 

        function initLiveRoute(orderId, destLat, destLng) {
            const wrapper = document.getElementById('wrapper-' + orderId);
            const errorDiv = document.getElementById('error-' + orderId);
            
            // Toggle visibility
            if (wrapper.style.display === 'block') {
                wrapper.style.display = 'none';
                return;
            }
            wrapper.style.display = 'block';

            // Check if coordinates exist
            if (!destLat || !destLng) {
                errorDiv.innerText = "Error: Customer coordinates missing in DB!";
                return;
            }

            if (!maps[orderId]) {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(
                        (pos) => {
                            const userLat = pos.coords.latitude;
                            const userLng = pos.coords.longitude;

                            // Initialize Map
                            const map = L.map('map-' + orderId).setView([userLat, userLng], 13);
                            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

                            // Setup Routing
                            const control = L.Routing.control({
                                waypoints: [
                                    L.latLng(userLat, userLng),
                                    L.latLng(destLat, destLng)
                                ],
                                router: L.Routing.osrmv1({
                                    serviceUrl: 'https://router.project-osrm.org/route/v1' // Force HTTPS OSRM
                                }),
                                lineOptions: {
                                    styles: [{ color: '#10ac84', weight: 6, opacity: 0.9 }]
                                },
                                addWaypoints: false,
                                draggableWaypoints: false,
                                fitSelectedRoutes: true,
                                showAlternatives: false
                            }).addTo(map);

                            // Error handling for routing
                            control.on('routingerror', function(e) {
                                errorDiv.innerText = "Routing Failed: " + (e.error.message || "Address unreachable by road.");
                            });

                            maps[orderId] = map;
                            // Fix for map appearing grey/blank inside hidden div
                            setTimeout(() => { map.invalidateSize(); }, 200);
                        },
                        (err) => {
                            errorDiv.innerText = "GPS Error: Please enable location in browser settings.";
                        }
                    );
                } else {
                    errorDiv.innerText = "Browser does not support GPS.";
                }
            }
        }
    </script>
</body>
</html>