import 'package:prettyrini/feature/shop/model/product_category_model.dart';
import 'package:prettyrini/feature/shop/model/product_data_model.dart';


class DummyData {
  static List<Category> getCategories() {
    return [
      Category(id: 1, name: "Chicks", icon: "https://via.placeholder.com/60x60/4CAF50/FFFFFF?text=🐣"),
      Category(id: 2, name: "Feed", icon: "https://via.placeholder.com/60x60/FF9800/FFFFFF?text=🌾"),
      Category(id: 3, name: "Medicines", icon: "https://via.placeholder.com/60x60/F44336/FFFFFF?text=💊"),
      Category(id: 4, name: "Supplies", icon: "https://via.placeholder.com/60x60/9C27B0/FFFFFF?text=📦"),
      Category(id: 5, name: "Equipment", icon: "https://via.placeholder.com/60x60/2196F3/FFFFFF?text=⚙️"),
    ];
  }

  static List<Product> getProducts() {
    return [
      // Top Selling Products
      Product(
        id: 1,
        name: "Chick Starter Pack",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        price: 120.00,
        image: "https://via.placeholder.com/200x200/4CAF50/FFFFFF?text=Starter+Pack",
        rating: 4.5,
        weight: "11.34 Kg",
        categoryId: 1,
        isTopSelling: true,
      ),
      Product(
        id: 2,
        name: "Chick Starter Pack Premium",
        description: "Premium quality chick starter pack with enhanced nutrition formula for better growth and health.",
        price: 34.00,
        image: "https://via.placeholder.com/200x200/4CAF50/FFFFFF?text=Premium+Pack",
        rating: 4.8,
        weight: "5.5 Kg",
        categoryId: 1,
        isTopSelling: true,
      ),
      Product(
        id: 3,
        name: "Advanced Chick Formula",
        description: "Advanced formula designed for optimal chick development with essential vitamins and minerals.",
        price: 34.50,
        image: "https://via.placeholder.com/200x200/4CAF50/FFFFFF?text=Advanced",
        rating: 4.7,
        weight: "10 Kg",
        categoryId: 1,
        isTopSelling: true,
      ),

      // New Products
      Product(
        id: 4,
        name: "Organic Chick Feed",
        description: "100% organic feed made from natural ingredients, perfect for healthy chick growth without chemicals.",
        price: 34.00,
        image: "https://via.placeholder.com/200x200/FF9800/FFFFFF?text=Organic+Feed",
        rating: 4.6,
        weight: "8 Kg",
        categoryId: 2,
        isNewProduct: true,
      ),
      Product(
        id: 5,
        name: "Vitamin Booster Pack",
        description: "Essential vitamin supplement pack to boost immunity and overall health of your chicks.",
        price: 34.00,
        image: "https://via.placeholder.com/200x200/F44336/FFFFFF?text=Vitamins",
        rating: 4.4,
        weight: "2 Kg",
        categoryId: 3,
        isNewProduct: true,
      ),
      Product(
        id: 6,
        name: "Premium Feed Mix",
        description: "High-quality feed mix with balanced nutrition for all stages of chick development.",
        price: 34.75,
        image: "https://via.placeholder.com/200x200/FF9800/FFFFFF?text=Premium+Mix",
        rating: 4.9,
        weight: "12 Kg",
        categoryId: 2,
        isNewProduct: true,
      ),

      // Additional Products for different categories
      Product(
        id: 7,
        name: "Automatic Feeder",
        description: "Automatic feeding system that ensures consistent and timely feeding for your chicks.",
        price: 89.99,
        image: "https://via.placeholder.com/200x200/2196F3/FFFFFF?text=Auto+Feeder",
        rating: 4.3,
        weight: "3.2 Kg",
        categoryId: 5,
      ),
      Product(
        id: 8,
        name: "Health Monitor Kit",
        description: "Complete health monitoring kit with thermometer and basic medical supplies for chick care.",
        price: 45.50,
        image: "https://via.placeholder.com/200x200/F44336/FFFFFF?text=Health+Kit",
        rating: 4.2,
        weight: "1.5 Kg",
        categoryId: 3,
      ),
      Product(
        id: 9,
        name: "Bedding Supplies",
        description: "Soft and absorbent bedding material to keep your chicks comfortable and healthy.",
        price: 25.00,
        image: "https://via.placeholder.com/200x200/9C27B0/FFFFFF?text=Bedding",
        rating: 4.1,
        weight: "5 Kg",
        categoryId: 4,
      ),
      Product(
        id: 10,
        name: "Water System",
        description: "Clean and efficient water delivery system designed specifically for young chicks.",
        price: 67.25,
        image: "https://via.placeholder.com/200x200/2196F3/FFFFFF?text=Water+System",
        rating: 4.6,
        weight: "2.8 Kg",
        categoryId: 5,
      ),
    ];
  }

  static Map<String, dynamic> getDummyJson() {
    return {
      "categories": getCategories().map((category) => category.toJson()).toList(),
      "products": getProducts().map((product) => product.toJson()).toList(),
    };
  }
}