import 'package:get/get.dart';
import 'package:prettyrini/feature/shop/model/product_category_model.dart';
import 'package:prettyrini/feature/shop/model/product_data_model.dart';
import 'package:prettyrini/feature/shop/model/product_dummy_data.dart';

class ProductController extends GetxController {
  var categories = <Category>[].obs;
  var products = <Product>[].obs;
  var topSellingProducts = <Product>[].obs;
  var newProducts = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var selectedCategory = Rxn<Category>();
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    isLoading.value = true;
    
    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      categories.value = DummyData.getCategories();
      products.value = DummyData.getProducts();
      
      // Filter top selling and new products
      topSellingProducts.value = products.where((product) => product.isTopSelling).toList();
      newProducts.value = products.where((product) => product.isNewProduct).toList();
      
      isLoading.value = false;
    });
  }

  void selectCategory(Category category) {
    selectedCategory.value = category;
    filterProductsByCategory(category.id);
  }

  void filterProductsByCategory(int categoryId) {
    filteredProducts.value = products.where((product) => product.categoryId == categoryId).toList();
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      if (selectedCategory.value != null) {
        filterProductsByCategory(selectedCategory.value!.id);
      } else {
        filteredProducts.clear();
      }
    } else {
      var searchResults = products.where((product) => 
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
      if (selectedCategory.value != null) {
        searchResults = searchResults.where((product) => 
          product.categoryId == selectedCategory.value!.id
        ).toList();
      }
      
      filteredProducts.value = searchResults;
    }
  }

  void clearCategoryFilter() {
    selectedCategory.value = null;
    filteredProducts.clear();
    searchQuery.value = '';
  }

  Product? getProductById(int id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> getProductsByCategory(int categoryId) {
    return products.where((product) => product.categoryId == categoryId).toList();
  }
}