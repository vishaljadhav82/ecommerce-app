package com.jtspringproject.JtSpringProject.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.jtspringproject.JtSpringProject.dao.ProductRepository;
import com.jtspringproject.JtSpringProject.models.Category;
import com.jtspringproject.JtSpringProject.models.Product;

import jakarta.transaction.Transactional;

@Service
public class productService {

	@Autowired
	private ProductRepository productRepository;
	@Autowired
	private categoryService categoryService;

	public List<Product> getProducts() {
		return productRepository.findAll();
	}

	public Product addProduct(Product product) {
		return productRepository.save(product);
	}

	public Product getProduct(Long id) {
		return productRepository.findById(id).orElse(null);
	}

	public Product updateProduct(Long id, Product product) {
		Product existing = productRepository.findById(id).orElse(null);

		if (existing != null) {
			existing.setName(product.getName());
			existing.setPrice(product.getPrice());
			existing.setCategory(product.getCategory());
			return productRepository.save(existing);
		}

		return null;
	}

	public boolean deleteProduct(Long id) {
		if (productRepository.existsById(id)) {
			productRepository.deleteById(id);
			return true;
		}
		return false;
	}

	public List<Product> findByCategoryId(Long id) {
		// TODO Auto-generated method stub
		return productRepository.findByCategoryId(id);
	}

	public Page<Product> getFilteredProducts(String search, Long categoryId, int page, int size, String sortDir) {
	    Sort sort = sortDir.equalsIgnoreCase("asc") ? Sort.by("id").ascending() : Sort.by("id").descending();
	    Pageable pageable = PageRequest.of(page, size, sort);	    // Check if search is actually provided (not null and not empty)
	    boolean hasSearch = (search != null && !search.trim().isEmpty());
	    boolean hasCategory = (categoryId != null);

	    if (hasSearch && hasCategory) {
	        // Match the repository method name: findByNameContainingIgnoreCaseAndCategoryId
	        return productRepository.findByNameContainingIgnoreCaseAndCategoryId(search, categoryId, pageable);
	    } else if (hasSearch) {
	        // Match the repository method name: findByNameContainingIgnoreCase
	        return productRepository.findByNameContainingIgnoreCase(search, pageable);
	    } else if (hasCategory) {
	        return productRepository.findByCategoryId(categoryId, pageable);
	    } else {
	        return productRepository.findAll(pageable);
	    }
	}
	
	@Transactional
	public void seedAllDatabaseProducts() {
	    // Structure: {Name, ImageURL, Price, Description, Quantity, Weight, CategoryID}
	    String[][] allData = {
	        // --- CATEGORY 1: MOBILES (30) ---
	        {"iPhone 15 Pro", "https://images.unsplash.com/photo-1696446701796-da61225697cc?w=400", "134900", "Titanium build", "10", "187g", "1"},
	        {"Samsung S24 Ultra", "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400", "129999", "AI Integrated", "15", "232g", "1"},
	        {"Google Pixel 8", "https://images.unsplash.com/photo-1699363382755-65487779743c?w=400", "75000", "Best Camera", "8", "187g", "1"},
	        {"OnePlus 12", "https://images.unsplash.com/photo-1707212620779-79776a33282f?w=400", "64999", "Smooth Performance", "20", "220g", "1"},
	        {"Nothing Phone 2", "https://images.unsplash.com/photo-1690184489906-ef696d557342?w=400", "44999", "Glyph Interface", "12", "201g", "1"},
	        {"Xiaomi 14", "https://images.unsplash.com/photo-1621330396173-e41b1cafd17f?w=400", "69999", "Leica Optics", "10", "193g", "1"},
	        {"Moto Edge 50", "https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=400", "35999", "Slim Design", "18", "180g", "1"},
	        {"iPhone 13", "https://images.unsplash.com/photo-1633110385270-47548a736c2a?w=400", "48999", "Classic Choice", "25", "174g", "1"},
	        {"Galaxy A54", "https://images.unsplash.com/photo-1678911820864-e2c567c655d7?w=400", "34999", "Mid-range King", "30", "202g", "1"},
	        {"Realme 12 Pro", "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400", "29999", "Luxury Watch Design", "40", "190g", "1"},
	        {"Vivo V30", "https://images.unsplash.com/photo-1592890288564-76628a30a657?w=400", "33999", "Portrait Expert", "15", "186g", "1"},
	        {"Oppo Reno 11", "https://images.unsplash.com/photo-1546054454-aa26e2b734c7?w=400", "28999", "Natural Aesthetics", "20", "182g", "1"},
	        {"IQOO 12", "https://images.unsplash.com/photo-1556656793-062ff9878258?w=400", "52999", "Gaming Beast", "10", "203g", "1"},
	        {"Poco X6 Pro", "https://images.unsplash.com/photo-1565849906461-0e443ba2e163?w=400", "26999", "Speed Reimagined", "50", "186g", "1"},
	        {"Samsung M34", "https://images.unsplash.com/photo-1580910051074-3eb694886505?w=400", "18999", "Monster Battery", "60", "208g", "1"},
	        {"Redmi Note 13", "https://images.unsplash.com/photo-1601784551446-20c9e07cdbea?w=400", "17999", "Super AMOLED", "100", "173g", "1"},
	        {"iPhone SE", "https://images.unsplash.com/photo-1523206489230-c012c64b2b48?w=400", "42900", "Compact Power", "15", "144g", "1"},
	        {"Z Fold 5", "https://images.unsplash.com/photo-1610945415295-d9baf06025a1?w=400", "154999", "Large Screen", "5", "253g", "1"},
	        {"Z Flip 5", "https://images.unsplash.com/photo-1523206489230-c012c64b2b48?w=400", "99999", "Pocketable", "10", "187g", "1"},
	        {"Asus ROG 8", "https://images.unsplash.com/photo-1542487354-feaf934a4acc?w=400", "94999", "Ultimate Gaming", "5", "225g", "1"},
	        {"Lava Agni 2", "https://images.unsplash.com/photo-1533228100845-08145b01de14?w=400", "19999", "Indian Pride", "40", "210g", "1"},
	        {"Nothing Phone 2a", "https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=400", "23999", "Powerful Budget", "35", "190g", "1"},
	        {"OnePlus Nord 4", "https://images.unsplash.com/photo-1520923179273-9204207907f1?w=400", "29999", "Metal Unibody", "25", "199g", "1"},
	        {"Infinix Note 40", "https://images.unsplash.com/photo-1567581935884-3349723552ca?w=400", "15999", "Fast Charging", "45", "190g", "1"},
	        {"Tecno Pova 6", "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=400", "14999", "Dynamic Light", "30", "195g", "1"},
	        {"Honor 90", "https://images.unsplash.com/photo-1609203542858-472dfbe41423?w=400", "32999", "Flicker-free", "12", "183g", "1"},
	        {"JioPhone Next", "https://images.unsplash.com/photo-1584433144859-1fc3ab84a9ec?w=400", "4499", "Digital India", "200", "150g", "1"},
	        {"Nokia G42", "https://images.unsplash.com/photo-1541140532154-b0247335c913?w=400", "12999", "Repairable", "50", "193g", "1"},
	        {"Sony Xperia 1", "https://images.unsplash.com/photo-1585060544812-6b45742d762f?w=400", "110000", "Cinema Grade", "3", "187g", "1"},
	        {"Pixel 7a", "https://images.unsplash.com/photo-1683526315570-38148b320d39?w=400", "36999", "Reliable", "20", "193g", "1"},

	        // --- CATEGORY 2: FRUITS (30) ---
	        {"Red Apple", "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400", "180", "Kashmiri Sweet", "100", "1kg", "2"},
	        {"Nagpur Orange", "https://images.unsplash.com/photo-1557800636-894a64c1696f?w=400", "80", "Juicy Citrus", "150", "1kg", "2"},
	        {"Hapus Mango", "https://images.unsplash.com/photo-1553279768-865429fa0078?w=400", "600", "Ratnagiri", "50", "1 Dozen", "2"},
	        {"Green Grapes", "https://images.unsplash.com/photo-1537640538966-79f369b41e8f?w=400", "70", "Seedless", "80", "500g", "2"},
	        {"Banana", "https://images.unsplash.com/photo-1571771894821-ad9b5886464a?w=400", "50", "Energy Rich", "200", "1 Dozen", "2"},
	        {"Pomegranate", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "140", "Blood Red", "60", "1kg", "2"},
	        {"Papaya", "https://images.unsplash.com/photo-1517282009859-f000ec3b26fe?w=400", "45", "Farm Fresh", "40", "1 Unit", "2"},
	        {"Watermelon", "https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400", "40", "Hydrating", "30", "1 Unit", "2"},
	        {"Pineapple", "https://images.unsplash.com/photo-1550258114-b834e70e9be1?w=400", "60", "Rani variety", "25", "1 Unit", "2"},
	        {"Guava", "https://images.unsplash.com/photo-1536657464919-892534f60d6e?w=400", "60", "Pink Guava", "70", "1kg", "2"},
	        {"Dragon Fruit", "https://images.unsplash.com/photo-1527325241048-21815c42446c?w=400", "90", "Exotic White", "20", "1 Unit", "2"},
	        {"Black Grapes", "https://images.unsplash.com/photo-1423483641154-5411ec9c0ddf?w=400", "90", "Sweet", "50", "500g", "2"},
	        {"Kiwi", "https://images.unsplash.com/photo-1585059895524-72359e061380?w=400", "120", "Imported", "35", "3 Units", "2"},
	        {"Musk Melon", "https://images.unsplash.com/photo-1573246123716-6b1782abb499?w=400", "50", "Ripened", "30", "1 Unit", "2"},
	        {"Chickoo", "https://images.unsplash.com/photo-1601033405528-72016ed24cc4?w=400", "60", "Gholvad", "60", "1kg", "2"},
	        {"Mosambi", "https://images.unsplash.com/photo-1550506389-e1977adbb110?w=400", "90", "Sweet Lime", "80", "1kg", "2"},
	        {"Pear", "https://images.unsplash.com/photo-1514983693054-554268248561?w=400", "150", "Crunchy", "40", "1kg", "2"},
	        {"Plums", "https://images.unsplash.com/photo-1595124253349-20f016cae65b?w=400", "200", "High Fiber", "20", "500g", "2"},
	        {"Strawberry", "https://images.unsplash.com/photo-1464965211926-1d5295883d02?w=400", "80", "Fresh", "45", "250g", "2"},
	        {"Green Apple", "https://images.unsplash.com/photo-1464454709131-ffd692591ee5?w=400", "220", "Sour & Crisp", "25", "1kg", "2"},
	        {"Sitaphal", "https://images.unsplash.com/photo-1590425712124-7476510360a0?w=400", "120", "Custard Apple", "35", "1kg", "2"},
	        {"Anjeer", "https://images.unsplash.com/photo-1589363412581-2244249a60e0?w=400", "100", "Fresh Figs", "25", "250g", "2"},
	        {"Litchi", "https://images.unsplash.com/photo-1629828456257-2e118931102e?w=400", "250", "Shahi", "15", "500g", "2"},
	        {"Peach", "https://images.unsplash.com/photo-1521236306692-06830cc9e315?w=400", "180", "Soft", "20", "500g", "2"},
	        {"Apricot", "https://images.unsplash.com/photo-1501743029101-30d87600868f?w=400", "300", "Sweet", "15", "250g", "2"},
	        {"Cherries", "https://images.unsplash.com/photo-1528821128474-27f9e78e574b?w=400", "250", "Red", "20", "250g", "2"},
	        {"Blueberry", "https://images.unsplash.com/photo-1498557850523-fd3d118b962e?w=400", "350", "Superfood", "10", "125g", "2"},
	        {"Raspberry", "https://images.unsplash.com/photo-1577069861033-55d04cec4ef5?w=400", "400", "Tangy", "10", "125g", "2"},
	        {"Avocado", "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400", "150", "Healthy", "15", "1 Unit", "2"},
	        {"Passion Fruit", "https://images.unsplash.com/photo-1541604505967-1647e30da6ba?w=400", "180", "Tropical", "12", "4 Units", "2"},

	        // --- CATEGORY 3: GROCERIES (30) ---
	        {"Basmati Rice", "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400", "110", "Long Grain", "100", "1kg", "3"},
	        {"Wheat Atta", "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400", "280", "Chakki Fresh", "50", "5kg", "3"},
	        {"Sunflower Oil", "https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400", "145", "Pure Gold", "60", "1L", "3"},
	        {"Toor Dal", "https://images.unsplash.com/photo-1585996177647-d1103383086a?w=400", "160", "Unpolished", "80", "1kg", "3"},
	        {"Refined Sugar", "https://images.unsplash.com/photo-1581441363689-1f3c3c414635?w=400", "45", "Sulphur Free", "120", "1kg", "3"},
	        {"Iodized Salt", "https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=400", "25", "Pure White", "200", "1kg", "3"},
	        {"Poha", "https://images.unsplash.com/photo-1613254025696-6f7090884638?w=400", "60", "Indori Flaked", "90", "1kg", "3"},
	        {"Moong Dal", "https://images.unsplash.com/photo-1545114110-062e20aa025c?w=400", "140", "Yellow split", "70", "1kg", "3"},
	        {"Cow Ghee", "https://images.unsplash.com/photo-1589927986089-35812388d1f4?w=400", "650", "A2 Desi", "40", "500ml", "3"},
	        {"Brown Bread", "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400", "45", "Whole Wheat", "30", "400g", "3"},
	        {"Fresh Milk", "https://images.unsplash.com/photo-1550583724-125581fe2f8a?w=400", "60", "Full Cream", "100", "1L", "3"},
	        {"Brown Eggs", "https://images.unsplash.com/photo-1516448620398-c5f44bf9f441?w=400", "90", "Farm Fresh", "50", "6 Units", "3"},
	        {"Tea Powder", "https://images.unsplash.com/photo-1544787210-22166f4705ec?w=400", "130", "Assam Strong", "80", "250g", "3"},
	        {"Coffee", "https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400", "250", "Instant Gold", "60", "100g", "3"},
	        {"Honey", "https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400", "190", "Natural Forest", "45", "250g", "3"},
	        {"Pasta", "https://images.unsplash.com/photo-1551462147-ff29053fad31?w=400", "120", "Durum Wheat", "50", "500g", "3"},
	        {"Oats", "https://images.unsplash.com/photo-1586444248902-2f64eddf13cf?w=400", "180", "Rolled Oats", "40", "1kg", "3"},
	        {"Corn Flakes", "https://images.unsplash.com/photo-1509482560494-4126f8225994?w=400", "150", "Crispy Gold", "35", "500g", "3"},
	        {"Besan", "https://images.unsplash.com/photo-1627485601819-74ce35aa8d8d?w=400", "85", "Gram Flour", "70", "1kg", "3"},
	        {"Maida", "https://images.unsplash.com/photo-1627485601819-74ce35aa8d8d?w=400", "55", "Fine Flour", "60", "1kg", "3"},
	        {"Soybean Oil", "https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400", "130", "Healthy Heart", "80", "1L", "3"},
	        {"Kabuli Chana", "https://images.unsplash.com/photo-1515543904379-3d757afe72e2?w=400", "150", "Big Size", "50", "1kg", "3"},
	        {"Rajma", "https://images.unsplash.com/photo-1551462147-3a88547464e8?w=400", "160", "Chitra Kidney", "40", "1kg", "3"},
	        {"Urad Dal", "https://images.unsplash.com/photo-1515543904379-3d757afe72e2?w=400", "180", "Black Whole", "35", "1kg", "3"},
	        {"Masoor Dal", "https://images.unsplash.com/photo-1515543904379-3d757afe72e2?w=400", "120", "Red Split", "60", "1kg", "3"},
	        {"Jaggery", "https://images.unsplash.com/photo-1622359744406-f0558e434254?w=400", "80", "Organic Block", "45", "1kg", "3"},
	        {"Pickle", "https://images.unsplash.com/photo-1601055283742-990572d82bb5?w=400", "120", "Mango Spicy", "50", "500g", "3"},
	        {"Tomato Ketchup", "https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400", "110", "Classic Red", "40", "1kg", "3"},
	        {"Butter", "https://images.unsplash.com/photo-1589927986089-35812388d1f4?w=400", "250", "Salted Amul", "60", "500g", "3"},
	        {"Cheese Slices", "https://images.unsplash.com/photo-1528280048315-23ce286d7dfd?w=400", "150", "Processed", "45", "200g", "3"},

	        // --- CATEGORY 4: SPICES (30) ---
	        {"Turmeric", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "30", "Pure Haldi", "100", "100g", "4"},
	        {"Chili Powder", "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400", "45", "Lal Mirch", "80", "100g", "4"},
	        {"Cumin Seed", "https://images.unsplash.com/photo-1628554271148-396bb43544a1?w=400", "60", "Jeera", "70", "100g", "4"},
	        {"Black Pepper", "https://images.unsplash.com/photo-1532336414038-cf19250c5757?w=400", "85", "Kali Mirch", "50", "100g", "4"},
	        {"Cinnamon", "https://images.unsplash.com/photo-1510006851064-e6056cd0e3a8?w=400", "120", "Dalchini", "40", "100g", "4"},
	        {"Cardamom", "https://images.unsplash.com/photo-1599940824399-b87987cb972d?w=400", "250", "Elaichi", "30", "50g", "4"},
	        {"Cloves", "https://images.unsplash.com/photo-1599307767316-776533bb941c?w=400", "180", "Lavang", "40", "50g", "4"},
	        {"Coriander", "https://images.unsplash.com/photo-1608797178974-15b35a6401c2?w=400", "40", "Dhaniya Powder", "90", "100g", "4"},
	        {"Garam Masala", "https://images.unsplash.com/photo-1532336414038-cf19250c5757?w=400", "70", "Spicy Mix", "100", "100g", "4"},
	        {"Hing", "https://images.unsplash.com/photo-1532336414038-cf19250c5757?w=400", "90", "Asafoetida", "50", "50g", "4"},
	        {"Mustard Seeds", "https://images.unsplash.com/photo-1628554271148-396bb43544a1?w=400", "40", "Rai", "80", "200g", "4"},
	        {"Fenugreek", "https://images.unsplash.com/photo-1532336414038-cf19250c5757?w=400", "50", "Methi", "70", "100g", "4"},
	        {"Star Anise", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "150", "Chakra Phool", "20", "50g", "4"},
	        {"Bay Leaf", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "30", "Tej Patta", "60", "20g", "4"},
	        {"Nutmeg", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "200", "Jaiphal", "15", "2 Units", "4"},
	        {"Fennel", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "50", "Saunf", "80", "100g", "4"},
	        {"Dry Ginger", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "70", "Saunth", "45", "100g", "4"},
	        {"Saffron", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "450", "Kesar", "5", "1g", "4"},
	        {"Black Salt", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "35", "Kala Namak", "100", "100g", "4"},
	        {"Amchur", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "55", "Mango Powder", "60", "100g", "4"},
	        {"Ajwain", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "40", "Carom Seeds", "80", "100g", "4"},
	        {"Kalonji", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "60", "Black Seed", "40", "50g", "4"},
	        {"Poppy Seeds", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "300", "Khus Khus", "20", "100g", "4"},
	        {"Sesame", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "90", "Til White", "70", "200g", "4"},
	        {"Dry Chili", "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400", "120", "Whole Red", "40", "200g", "4"},
	        {"Curry Leaves", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "20", "Fresh Kadi Patta", "50", "1 Bunch", "4"},
	        {"Mace", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "350", "Javitri", "10", "20g", "4"},
	        {"Peppercorns", "https://images.unsplash.com/photo-1532336414038-cf19250c5757?w=400", "160", "White Pepper", "25", "100g", "4"},
	        {"Red Chili Flex", "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400", "80", "Crushed", "50", "100g", "4"},
	        {"Basil Seeds", "https://images.unsplash.com/photo-1615485245452-11af33f21e93?w=400", "100", "Sabja", "40", "100g", "4"},

	        // --- CATEGORY 5: SNACKS (30) ---
	        {"Potato Chips", "https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400", "20", "Classic Salted", "100", "50g", "5"},
	        {"Cookies", "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400", "35", "Choco Chip", "80", "120g", "5"},
	        {"Noodles", "https://images.unsplash.com/photo-1612927601601-6638404737ce?w=400", "14", "Instant Maggi", "200", "70g", "5"},
	        {"Kurkure", "https://images.unsplash.com/photo-1600271886395-d04bfcd9e2e4?w=400", "20", "Masala Munch", "150", "80g", "5"},
	        {"Roasted Peanuts", "https://images.unsplash.com/photo-1567894340315-735d7c361db0?w=400", "40", "Salted", "100", "100g", "5"},
	        {"Bhujia Sev", "https://images.unsplash.com/photo-1600271886395-d04bfcd9e2e4?w=400", "55", "Aloo Bhujia", "120", "150g", "5"},
	        {"Popcorn", "https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=400", "30", "Butter Pop", "60", "50g", "5"},
	        {"Dark Chocolate", "https://images.unsplash.com/photo-1511381939415-e44015466834?w=400", "80", "70% Cocoa", "50", "80g", "5"},
	        {"Fruit Juice", "https://images.unsplash.com/photo-1600271886395-d04bfcd9e2e4?w=400", "100", "Mixed Fruit", "40", "1L", "5"},
	        {"Soft Drink", "https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400", "40", "Cola 500ml", "100", "500ml", "5"},
	        {"Nachos", "https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?w=400", "60", "Cheese Flavor", "70", "150g", "5"},
	        {"Protein Bar", "https://images.unsplash.com/photo-1612141812379-80d75d58426d?w=400", "120", "Berry Nuts", "30", "50g", "5"},
	        {"Wafer Biscuits", "https://images.unsplash.com/photo-1590080875515-8a03b1447d19?w=400", "25", "Strawberry", "90", "100g", "5"},
	        {"Energy Drink", "https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=400", "110", "Red Bull", "50", "250ml", "5"},
	        {"Makhana", "https://images.unsplash.com/photo-1600271886395-d04bfcd9e2e4?w=400", "180", "Roasted Foxnut", "40", "100g", "5"},
	        {"Corn Puffs", "https://images.unsplash.com/photo-1600271886395-d04bfcd9e2e4?w=400", "10", "Cheese Balls", "200", "30g", "5"},
	        {"Fruit Cake", "https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=400", "25", "Sliced", "80", "100g", "5"},
	        {"Soan Papdi", "https://images.unsplash.com/photo-1600271886395-d04bfcd9e2e4?w=400", "140", "Desi Ghee", "30", "250g", "5"},
	        {"Gulab Jamun", "https://images.unsplash.com/photo-1589119908995-c6837fa14848?w=400", "200", "Instant Mix", "40", "500g", "5"},
	        {"Pasta Kit", "https://images.unsplash.com/photo-1551462147-ff29053fad31?w=400", "50", "Cheese Pasta", "60", "150g", "5"},
	        {"Oats Biscuits", "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400", "40", "Healthy", "100", "150g", "5"},
	        {"Namkeen", "https://images.unsplash.com/photo-1600271886395-d04bfcd9e2e4?w=400", "90", "Khatta Meetha", "70", "400g", "5"},
	        {"Milk Chocolate", "https://images.unsplash.com/photo-1548907040-4baa42d10919?w=400", "40", "Dairy Milk", "150", "50g", "5"},
	        {"Lollipops", "https://images.unsplash.com/photo-1534073828943-f801091bb18c?w=400", "5", "Fruit Pop", "500", "10g", "5"},
	        {"Gum", "https://images.unsplash.com/photo-1559181567-c3190cb9959b?w=400", "1", "Mint Fresh", "1000", "2g", "5"},
	        {"Wafers", "https://images.unsplash.com/photo-1599490659223-930b44ceef7d?w=400", "30", "Potato Spicy", "80", "50g", "5"},
	        {"Mixed Nuts", "https://images.unsplash.com/photo-1596591606975-97ee5cef3a1e?w=400", "450", "Premium", "25", "200g", "5"},
	        {"Papad", "https://images.unsplash.com/photo-1600271886395-d04bfcd9e2e4?w=400", "60", "Lijjat Urad", "100", "200g", "5"},
	        {"Ice Cream", "https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400", "250", "Vanilla 1L", "20", "1L", "5"},
	        {"Peanut Butter", "https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400", "180", "Creamy", "40", "350g", "5"}
	    };

	    seedCategories();
	    
	    for (String[] data : allData) {
	        Product p = new Product();
	        p.setName(data[0]);
	        p.setImage(data[1]);
	        p.setPrice(Integer.parseInt(data[2]));
	        p.setDescription(data[3]);
	        p.setQuantity(Integer.parseInt(data[4]));
	        p.setWeight(data[5]);
	        
	        // Dynamic Category Setup
	      Category category =  categoryService.getCategory(Long.parseLong(data[6]));
	       // cat.setCategory(Integer.parseInt(data[6])); 
	        p.setCategory(category);

	        this.addProduct(p); // Your existing addProduct logic
	    }
	}
	
	// Private helper to ensure Categories 1-5 exist
	private void seedCategories() {
	    String[] categories = {"Mobiles", "Fruits", "Groceries", "Spices", "Snacks"};
	    for (int i = 0; i < categories.length; i++) {
	        categoryService.addCategory(categories[i]);
	    }
	}

	public List<Product> searchProductsByName(String query) {
		// TODO Auto-generated method stub
		return productRepository.findByNameContainingIgnoreCase(query);
	}

	public Product getProductById(Long id) {
		// TODO Auto-generated method stub
		return productRepository.findById(id).get();
	}
}