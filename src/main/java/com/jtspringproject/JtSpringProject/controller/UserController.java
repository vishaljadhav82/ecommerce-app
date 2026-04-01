package com.jtspringproject.JtSpringProject.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.jtspringproject.JtSpringProject.dao.CategoryRepository;
import com.jtspringproject.JtSpringProject.dao.OrderRepository;
import com.jtspringproject.JtSpringProject.models.Cart;
import com.jtspringproject.JtSpringProject.models.CartProduct;
import com.jtspringproject.JtSpringProject.models.Category;
import com.jtspringproject.JtSpringProject.models.Order;
import com.jtspringproject.JtSpringProject.models.OrderItem;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.cartService;
import com.jtspringproject.JtSpringProject.services.productService;
import com.jtspringproject.JtSpringProject.services.userService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@CrossOrigin(origins = "*")
public class UserController {

	private final userService userService;
	private final productService productService;
	private final cartService cartService;
	private final OrderRepository orderRepository;

	@Autowired
	private CategoryRepository categoryRepository;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	public UserController(OrderRepository orderRepository, userService userService, productService productService,
			cartService cartService) {
		this.userService = userService;
		this.productService = productService;
		this.cartService = cartService;
		this.orderRepository = orderRepository;
	}

	// ================= HELPER: SECURE USER RETRIEVAL =================
	// 100x Logic: Prevents repeating authentication code in every single method.
	private User getAuthenticatedUser() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth == null || !auth.isAuthenticated() || auth instanceof AnonymousAuthenticationToken) {
			return null;
		}
		return userService.getUserByEmail(auth.getName());
	}

	// ================= 6. USER ONBOARDING (REGISTRATION) =================

	@GetMapping("/register")
	public String registerPage() {
		// Redirect if already logged in
		if (getAuthenticatedUser() != null)
			return "redirect:/";
		return "register"; // Returns register.jsp
	}

	@PostMapping("/register/process")
	@Transactional // 100x Logic: Ensures User and Cart are created together or not at all
	public String registerProcess(@RequestParam String username, @RequestParam String email,
			@RequestParam String password, @RequestParam String address, Model model) {

		// 1. Check if user already exists
		if (userService.getUserByEmail(username) != null) {
			model.addAttribute("msg", "Username already taken! Try another one.");
			return "register";
		}

		// 2. Create and Encrypt User
		User newUser = new User();
		newUser.setUsername(username);
		newUser.setEmail(email);
		newUser.setAddress(address);
		newUser.setPassword(passwordEncoder.encode(password.trim())); // Security First
		newUser.setRole("ROLE_USER"); // Standard customer role

		// 3. Save User to get an ID
		User savedUser = userService.addUser(newUser);

		// 4. 100x UX: Automatically create an empty cart for the new user
		// This prevents "NullPointerException" when they first click "Add to Cart"
		Cart newCart = new Cart();
		newCart.setCustomer(savedUser);
		cartService.addCart(newCart);

		System.out.println("New Member Joined Dharashiv Mandai: " + username);

		return "redirect:/login?registered=true";
	}

	// ================= 1. AUTHENTICATION & SESSION =================

	@GetMapping("/login")
	public ModelAndView userlogin(@RequestParam(required = false) String error) {
		if (getAuthenticatedUser() != null)
			return new ModelAndView("redirect:/");

		ModelAndView mv = new ModelAndView("userLogin");
		if ("true".equals(error))
			mv.addObject("msg", "Invalid Credentials. Try again.");
		return mv;
	}

	@PostMapping("/login/process")
	public String loginProcess(@RequestParam String username, @RequestParam String password,
			HttpServletRequest request) {
		User user = userService.getUserByEmail(username);
		if (user != null && passwordEncoder.matches(password.trim(), user.getPassword())) {
			UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(user.getEmail(), null,
					Collections.singletonList(new SimpleGrantedAuthority(user.getRole())));
			SecurityContextHolder.getContext().setAuthentication(auth);
			request.getSession(true).setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
			return "redirect:/";
		}
		return "redirect:/login?error=true";
	}

	@GetMapping("/logout")
	public String logout(HttpServletRequest request) {
		SecurityContextHolder.clearContext();
		HttpSession session = request.getSession(false);
		if (session != null)
			session.invalidate();
		return "redirect:/login?logout=true";
	}

	// ================= 2. SMART DISCOVERY =================
	@GetMapping("/")
	public ModelAndView indexPage(@RequestParam(required = false) String search,
			@RequestParam(required = false) Long categoryId, @RequestParam(defaultValue = "0") int page,
			@RequestParam(defaultValue = "12") int size) { // Larger size for grid view

		ModelAndView mv = new ModelAndView("index");
		User user = getAuthenticatedUser();

		// 1. Fetch categories for the sidebar/navigation
		List<Category> categories = categoryRepository.findAll();

		// 2. Fetch paginated/filtered products using your existing service method
		// We use "asc" or "desc" based on your preference (e.g., newest first)
		org.springframework.data.domain.Page<Product> productPage = productService.getFilteredProducts(search,
				categoryId, page, size, "desc");

		// 3. Add objects to the model
		mv.addObject("username", (user != null) ? user.getUsername() : "Guest");
		mv.addObject("categories", categories);
		mv.addObject("products", productPage.getContent());

		// Pagination Metadata for the UI
		mv.addObject("currentPage", page);
		mv.addObject("totalPages", productPage.getTotalPages());
		mv.addObject("search", search);
		mv.addObject("categoryId", categoryId);

		mv.addObject("deliveryPromise", "⚡ 45-min Fresh Delivery in Dharashiv");

		return mv;
	}
	
	@GetMapping("/searchSuggestions")
	@ResponseBody
	public List<String> getSearchSuggestions(@RequestParam("term") String query) {
	    // 1. Safety Check: Don't search for empty or very short strings
	    if (query == null || query.trim().length() < 2) {
	        return new ArrayList<>();
	    }

	    // 2. Fetch products where name contains the query (Case-Insensitive)
	    // We only need the names to keep the response lightweight
	    List<Product> products = productService.searchProductsByName(query);

	    // 3. Extract names and limit to top 8 results for a clean UI
	    return products.stream()
	            .map(Product::getName)
	            .distinct()
	            .limit(8)
	            .collect(Collectors.toList());
	}

	@GetMapping("/shop/category/{id}")
	public ModelAndView filterByCategory(@PathVariable("id") Long id) {
		ModelAndView mv = new ModelAndView("index"); // Reuses your 100x better index.jsp
		User user = getAuthenticatedUser();

		// 1. Fetch only products belonging to this specific category ID
		List<Product> filteredProducts = productService.findByCategoryId(id);

		// 2. We still need the full category list to show the navigation bar
		List<Category> categories = categoryRepository.findAll();

		mv.addObject("username", (user != null) ? user.getUsername() : "Guest");
		mv.addObject("products", filteredProducts);
		mv.addObject("categories", categories);

		// 3. Smart Delivery Promise: Dynamic text based on selection
		String categoryName = categories.stream().filter(c -> Long.valueOf(c.getId()).equals(id)).findFirst()
				.map(Category::getName).orElse("Fresh Items");

		mv.addObject("deliveryPromise", "⚡ 45-min Fresh " + categoryName + " Delivery in Dharashiv");

		// 4. Pass the active ID so the JSP can "glow" the selected pill
		mv.addObject("activeCatId", id);

		return mv;
	}

	@GetMapping("/shop/search")
	public ModelAndView searchProducts(@RequestParam(name = "query", required = false) String query) {
		ModelAndView mv = new ModelAndView("index");
		List<Product> results = this.productService.getProducts();
		if (query != null && !query.isEmpty()) {
			results = results.stream()
					.filter(p -> p.getName().toLowerCase().contains(query.toLowerCase())
							|| p.getCategory().getName().toLowerCase().contains(query.toLowerCase()))
					.collect(Collectors.toList());
		}
		mv.addObject("products", results);
		mv.addObject("searchQuery", query);
		return mv;
	}

	// ================= 3. CART OPERATIONS =================

//    @GetMapping("/cart/add/{id}")
//    public String addToCart(@PathVariable int id) {
//        User user = getAuthenticatedUser();
//        if (user == null) return "redirect:/login";
//
//        Product product = productService.getProduct((long) id);
//        if (product != null) {
//            Cart cart = cartService.getCartByUserId(user.getId());
//            cartService.addItemToCart(cart, product);
//        }
//        return "redirect:/cart/view?success=added";
//    }

	@PostMapping("/cart/add/{id}")
	@ResponseBody // 1. Prevents redirect, returns data directly to the floating cart
	public ResponseEntity<Map<String, Object>> addToCart(@PathVariable int id) {
		User user = getAuthenticatedUser();
		//System.out.println(user.getEmail());
		Map<String, Object> response = new HashMap<>();

		// 2. Security Check: If not logged in, tell AJAX to redirect to login
		if (user == null) {
			response.put("status", "unauthorized");
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
		}

		Product product = productService.getProduct((long) id);
		if (product != null) {
			Cart cart = cartService.getCartByUserId(user.getId());
			cartService.addItemToCart(cart, product);

			// 3. Send Success Data back to the Floating Cart
			response.put("status", "success");
			response.put("productName", product.getName());
			response.put("cartCount", cartService.getCartProducts(cart).size()); // Updates your badge number

			return ResponseEntity.ok(response);
		}

		response.put("status", "error");
		return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
	}

	@GetMapping("/cart/view")
	public ModelAndView viewCart() {
		User user = getAuthenticatedUser();
		if (user == null)
			return new ModelAndView("403");

		Cart cart = cartService.getCartByUserId(user.getId());
		List<CartProduct> items = cartService.getCartProducts(cart);

		ModelAndView mv = new ModelAndView("cart");
		mv.addObject("cartItems", items);
		mv.addObject("total", items.stream().mapToInt(i -> i.getProduct().getPrice()).sum());
		return mv;
	}

	// ================= 4. TRANSACTIONAL CHECKOUT =================

	@GetMapping("/cart/checkout")
	public ModelAndView checkoutPage() {
		User user = getAuthenticatedUser();
		if (user == null)
			return new ModelAndView("403");

		Cart cart = cartService.getCartByUserId(user.getId());
		List<CartProduct> items = cartService.getCartProducts(cart);

		if (items.isEmpty())
			return new ModelAndView("redirect:/?empty=true");

		ModelAndView mv = new ModelAndView("checkout");
		mv.addObject("total", items.stream().mapToInt(i -> i.getProduct().getPrice()).sum());
		mv.addObject("user", user);
		return mv;
	}

	@GetMapping("/cart/updateQty/{id}/{action}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> updateQuantity(@PathVariable int id, @PathVariable String action) {
		User user = getAuthenticatedUser();
		Map<String, Object> response = new HashMap<>();

		if (user == null)
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();

		Cart cart = cartService.getCartByUserId(user.getId());
		Product product = productService.getProduct((long) id);

		if (product != null) {
			if ("plus".equals(action)) {
				cartService.addItemToCart(cart, product);
			} else if ("minus".equals(action)) {
				// This should be your new method that reduces 'quantity' field
				cartService.reduceItemQuantity(cart, product);
			}
		}

		// --- 100x Recalculate Totals with Quantity ---
		List<CartProduct> cartItems = cartService.getCartProducts(cart);

		// Multiply price * quantity for every row
		int newTotal = cartItems.stream().mapToInt(item -> item.getProduct().getPrice() * item.getQuantity()).sum();

		// Count total physical items (Sum of all quantities)
		int totalItems = cartItems.stream().mapToInt(CartProduct::getQuantity).sum();

		// Get current quantity of the specific item updated
		int currentItemQty = cartItems.stream().filter(item -> item.getProduct().getId() == id)
				.mapToInt(CartProduct::getQuantity).findFirst().orElse(0);

		response.put("newTotal", newTotal);
		response.put("cartSize", totalItems);
		response.put("itemQty", currentItemQty); // Send back to update the specific row UI
		response.put("status", "success");

		return ResponseEntity.ok(response);
	}

	@GetMapping("/cart/removeItem/{id}")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> removeItem(@PathVariable int id) {
		User user = getAuthenticatedUser();
		Map<String, Object> response = new HashMap<>();

		if (user == null)
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();

		Cart cart = cartService.getCartByUserId(user.getId());
		Product product = productService.getProduct((long) id);

		if (product != null) {
			cartService.removeItemCompletely(cart, product); // New Service Method
		}

		// Recalculate everything for the UI
		List<CartProduct> cartItems = cartService.getCartProducts(cart);
		int newTotal = cartItems.stream().mapToInt(i -> i.getProduct().getPrice() * i.getQuantity()).sum();
		int totalItems = cartItems.stream().mapToInt(CartProduct::getQuantity).sum();

		response.put("status", "success");
		response.put("newTotal", newTotal);
		response.put("cartSize", totalItems);
		return ResponseEntity.ok(response);
	}

	@PostMapping("/cart/placeOrder")
	@Transactional
	public String placeOrder(

	        @RequestParam String address,   // full address from UI
	        @RequestParam String area,
	        @RequestParam String pincode,
	        @RequestParam String contact,
	        @RequestParam String paymentMethod,

	        // 🔥 NEW (optional fields from OSM autofill)
	        @RequestParam(required = false) String city,
	        @RequestParam(required = false) String state,
	        @RequestParam(required = false) String country,
	        @RequestParam(required = false) String road,
	        @RequestParam(required = false) String landmark,

	        @RequestParam(required = false) Double latitude,
	        @RequestParam(required = false) Double longitude
	) {

	    User user = getAuthenticatedUser();
	    if (user == null) return "redirect:/login";

	    Cart cart = cartService.getCartByUserId(user.getId());
	    List<CartProduct> cartItems = cartService.getCartProducts(cart);

	    if (cartItems.isEmpty()) return "redirect:/cart?error=empty";

	    // ✅ Create Order
	    Order order = new Order();
	    order.setCustomer(user);

	    // 🔹 Old fields (keep for compatibility)
	    order.setArea(area);
	    order.setPincode(pincode);

	    // 🔹 NEW structured fields
	    order.setCity(city);
	    order.setState(state);
	    order.setCountry(country);
	    order.setStreet(road);
	    order.setLandmark(landmark);

	    // 🔹 Full Address (IMPORTANT)
	   // order.setFullAddress(address);

	    // 🔹 Contact & Payment
	    order.setContact(contact);
	    order.setPaymentMethod(paymentMethod);
	    order.setPaymentStatus("PENDING");
	    order.setStatus("PREPARING");
	    order.setOrderDate(new Date());

	    // 📍 Geo Location
	    order.setLatitude(latitude);
	    order.setLongitude(longitude);

	    int grandTotal = 0;

	    // 🔁 Process Cart Items
	    for (CartProduct item : cartItems) {

	        Product product = item.getProduct();
	        int orderedQty = item.getQuantity();

	        // 🛡️ Stock Check
	        if (product.getQuantity() < orderedQty) {
	            return "redirect:/cart?error=out_of_stock&item=" + product.getName();
	        }

	        // 📉 Update Stock
	        product.setQuantity(product.getQuantity() - orderedQty);
	        productService.updateProduct(product.getId(), product);

	        // 🛍️ Order Item
	        OrderItem orderItem = new OrderItem();
	        orderItem.setProduct(product);
	        orderItem.setQuantity(orderedQty);
	        orderItem.setPriceAtPurchase(product.getPrice());

	        order.addOrderItem(orderItem);

	        grandTotal += product.getPrice() * orderedQty;
	    }

	    // 💰 Extra Fee
	    int mandaiFee = 35;
	    order.setTotalAmount(grandTotal + mandaiFee);

	    // 💾 Save
	    orderRepository.save(order);

	    // 🧹 Clear Cart
	    cartService.clearCart(cart);

	    return "redirect:/user/orders?success=true";
	}	// ================= 5. PROFILE & REAL HISTORY =================

	@GetMapping("/user/profile")
	public String profileDisplay(Model model) {
		User user = getAuthenticatedUser();
		if (user == null)
			return "redirect:/login";
		model.addAttribute("user", user);
		return "updateProfile";
	}

	@PostMapping("/user/profile/update")
	@Transactional // 100x Logic: Ensures database integrity during the update
	public String updateProfile(@RequestParam("id") Long id, @RequestParam("email") String email,
			@RequestParam("address") String address, Model model) {

		
		// 1. Fetch the existing user from the database
		User existingUser = userService.getUserById(id);

		if (existingUser != null) {
			// 2. Update the fields
			existingUser.setEmail(email);
			existingUser.setAddress(address);

			// 3. Save the updated object
			userService.addUser(existingUser); // Usually addUser handles updates if ID exists

			// 4. Update the Security Context
			// (So the header/session reflects changes immediately)
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			User user = getAuthenticatedUser();
			model.addAttribute("user", user);

			System.out.println("Profile Updated for: " + existingUser.getUsername());
			return "redirect:/user/profile?success=true";
		}

		return "redirect:/user/profile?error=true";
	}

	@GetMapping("/user/orders")
	public ModelAndView getUserOrders(@RequestParam(required = false) String success) {
		User user = getAuthenticatedUser();
		if (user == null)
			return new ModelAndView("403");

		// Corrected method name to match the Repository
		List<Order> history = orderRepository.findByCustomer_IdOrderByOrderDateDesc(user.getId());

		ModelAndView mv = new ModelAndView("uproduct");
		mv.addObject("orders", history); // Crucial: This 'orders' key is what the JSP loops over
		mv.addObject("username", user.getUsername());

		if ("true".equals(success)) {
			mv.addObject("msg", "Order Placed Successfully! Dharashiv Mandai is packing your items.");
		}

		return mv;
	}
	
	@GetMapping("/product/view")
	public ModelAndView viewProduct(@RequestParam Long id) {
		User user = getAuthenticatedUser();
		if (user == null)
			return new ModelAndView("403");

	    Product product = productService.getProductById(id);
	    ModelAndView mv = new ModelAndView("productView");
	    mv.addObject("product", product);
	    return mv;
	}
}