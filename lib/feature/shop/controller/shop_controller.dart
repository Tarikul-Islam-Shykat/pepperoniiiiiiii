import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:prettyrini/core/global_widegts/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
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
  final NetworkConfig _networkConfig = NetworkConfig();

  @override
  void onInit() {
    super.onInit();
    loadData();
    loadProducts();
  }

  final isCartLoading = false.obs;
  Future<void> addToCart(String id) async {
    try {
      isCartLoading.value = true;
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.addToCart,
        json.encode({"productId": id}),
        is_auth: true,
      );
      log("Single Product API Response: ${response.toString()}");
      if (response != null && response['success'] == true) {
        if (response['data'] != null) {
          AppSnackbar.show(message: "Item Added Successfully", isSuccess: true);
        } else {
          AppSnackbar.show(message: "Product data not found", isSuccess: false);
        }
      } else {
        AppSnackbar.show(
            message: response?['message'] ?? 'Failed to load product',
            isSuccess: false);
      }
    } catch (e) {
      log("Error loading single product: $e");
      AppSnackbar.show(message: "Failed to load product: $e", isSuccess: false);
    } finally {
      isCartLoading.value = false;
    }
  }

  void clearCurrentProduct() {
    currentProduct.value = null;
  }

  final isSingleProductsLoading = false.obs;
  var currentProduct = Rxn<Product>();
  Future<Product?> getSingleProduct(String id) async {
    try {
      isSingleProductsLoading.value = true;
      currentProduct.value = null; // Clear previous product

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        "${Urls.getProduct}/$id",
        json.encode({}),
        is_auth: true,
      );

      log("Single Product API Response: ${response.toString()}");

      if (response != null && response['success'] == true) {
        if (response['data'] != null) {
          final product = Product.fromJson(response['data']);
          currentProduct.value = product;

          // AppSnackbar.show(
          //     message: "Product loaded successfully", isSuccess: true);
          return product;
        } else {
          AppSnackbar.show(message: "Product data not found", isSuccess: false);
          return null;
        }
      } else {
        AppSnackbar.show(
            message: response?['message'] ?? 'Failed to load product',
            isSuccess: false);
        return null;
      }
    } catch (e) {
      log("Error loading single product: $e");
      AppSnackbar.show(message: "Failed to load product: $e", isSuccess: false);
      return null;
    } finally {
      isSingleProductsLoading.value = false;
    }
  }

  final isProductLoading = false.obs;

  Future<bool> loadProducts() async {
    try {
      isProductLoading.value = true;
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.getProduct,
        json.encode({}),
        is_auth: true,
      );

      log("Product API Response: ${response.toString()}");

      if (response != null && response['success'] == true) {
        // Extract products from the nested data structure
        final Map<String, dynamic> data = response['data'];
        final List<dynamic> productList = data['data'];

        // Convert to Product objects
        products.value = productList
            .map((productJson) => Product.fromJson(productJson))
            .toList();

        // Update filtered products
        filteredProducts.value = products.value;

        // Separate top selling and new products if needed
        topSellingProducts.value = products.value.toList();
        newProducts.value = products.value.toList();

        // topSellingProducts.value =
        //     products.where((p) => p.isTopSelling).toList();
        // newProducts.value = products.where((p) => p.isNewProduct).toList();

        AppSnackbar.show(
            message: "Products loaded successfully", isSuccess: true);
        return true;
      } else {
        AppSnackbar.show(
            message: response?['message'] ?? 'Failed to load products',
            isSuccess: false);
        return false;
      }
    } catch (e) {
      log("Error loading products: $e");
      AppSnackbar.show(
          message: "Failed to load products: $e", isSuccess: false);
      return false;
    } finally {
      isProductLoading.value = false;
    }
  }

  void loadData() {
    isLoading.value = true;

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      categories.value = DummyData.getCategories();
      //  products.value = DummyData.getProducts();

      // Filter top selling and new products
      topSellingProducts.value =
          products.where((product) => product.isTopSelling).toList();
      newProducts.value =
          products.where((product) => product.isNewProduct).toList();

      isLoading.value = false;
    });
  }

  void selectCategory(Category category) {
    selectedCategory.value = category;
    filterProductsByCategory(category.id);
  }

  void filterProductsByCategory(int categoryId) {
    filteredProducts.value =
        products.where((product) => product.categoryId == categoryId).toList();
  }

  // void searchProducts(String query) {
  //   searchQuery.value = query;
  //   if (query.isEmpty) {
  //     if (selectedCategory.value != null) {
  //       filterProductsByCategory(selectedCategory.value!.id);
  //     } else {
  //       filteredProducts.clear();
  //     }
  //   } else {
  //     var searchResults = products
  //         .where((product) =>
  //             product.name.toLowerCase().contains(query.toLowerCase()) ||
  //             product.description.toLowerCase().contains(query.toLowerCase()))
  //         .toList();

  //     if (selectedCategory.value != null) {
  //       searchResults = searchResults
  //           .where(
  //               (product) => product.categoryId == selectedCategory.value!.id)
  //           .toList();
  //     }

  //     filteredProducts.value = searchResults;
  //   }
  // }

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
    return products
        .where((product) => product.categoryId == categoryId)
        .toList();
  }
}
