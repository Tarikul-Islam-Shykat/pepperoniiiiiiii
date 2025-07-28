import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:prettyrini/core/global_widegts/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/feature/cart/model/cart_model.dart';

class CartController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();

  @override
  void onInit() {
    getCart();
    super.onInit();
  }

  // Add cart data observable
  final cartData = Rxn<CartData>();

  // Debouncing for quantity updates
  Timer? _debounceTimer;
  final Map<String, int> _pendingUpdates = {};

  final isCartLoading = false.obs;
  Future<void> getCart() async {
    try {
      isCartLoading.value = true;
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.addToCart, // Keep your existing URL
        json.encode({}),
        is_auth: true,
      );
      log("Get Cart API Response: ${response.toString()}");
      if (response != null && response['success'] == true) {
        if (response['data'] != null) {
          // Parse cart data using model - handle List response
          final cartItemsList = response['data'] as List<dynamic>;
          cartData.value = CartData.fromApiResponse(cartItemsList);
          AppSnackbar.show(
              message: "Cart loaded successfully", isSuccess: true);
        } else {
          cartData.value = CartData(items: [], totalAmount: 0, totalItems: 0);
          AppSnackbar.show(message: "Cart is empty", isSuccess: false);
        }
      } else {
        AppSnackbar.show(
            message: response?['message'] ?? 'Failed to load cart',
            isSuccess: false);
      }
    } catch (e) {
      log("Error loading cart: $e");
      AppSnackbar.show(message: "Failed to load cart: $e", isSuccess: false);
    } finally {
      isCartLoading.value = false;
    }
  }

  final isAddCartLoading = false.obs;
  Future<void> addToCart(String id) async {
    try {
      isAddCartLoading.value = true;
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.addToCart,
        json.encode({"productId": id}),
        is_auth: true,
      );
      log("Add to Cart API Response: ${response.toString()}");
      if (response != null && response['success'] == true) {
        if (response['data'] != null) {
          AppSnackbar.show(message: "Item Added Successfully", isSuccess: true);
          // Refresh cart after adding
          getCart();
        } else {
          AppSnackbar.show(message: "Product data not found", isSuccess: false);
        }
      } else {
        AppSnackbar.show(
            message: response?['message'] ?? 'Failed to add product',
            isSuccess: false);
      }
    } catch (e) {
      log("Error adding to cart: $e");
      AppSnackbar.show(message: "Failed to add product: $e", isSuccess: false);
    } finally {
      isAddCartLoading.value = false;
    }
  }

  // Local quantity update with debouncing
  void updateQuantityLocal(String itemId, int newQuantity) {
    if (cartData.value == null) return;

    // Update local data immediately
    final updatedItems = cartData.value!.items.map((item) {
      if (item.id == itemId) {
        item.quantity = newQuantity;
      }
      return item;
    }).toList();

    // Remove items with 0 quantity
    updatedItems.removeWhere((item) => item.quantity <= 0);

    // Recalculate totals
    final totalItems =
        updatedItems.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalAmount =
        updatedItems.fold<double>(0, (sum, item) => sum + item.totalPrice);

    cartData.value = CartData(
      items: updatedItems,
      totalAmount: totalAmount,
      totalItems: totalItems,
    );

    // Store for API sync
    _pendingUpdates[itemId] = newQuantity;

    // Debounce API call
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 800), () {
      _syncQuantityUpdate(itemId, newQuantity);
    });
  }

  // Sync quantity with API
  Future<void> _syncQuantityUpdate(String itemId, int quantity) async {
    try {
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.addToCart,
        json.encode({"productId": itemId}),
        is_auth: true,
      );

      if (response != null && response['success'] == true) {
        log("Quantity updated successfully");
      } else {
        // Revert on failure
        getCart();
      }
    } catch (e) {
      log("Error updating quantity: $e");
      // Revert on error
      getCart();
    }
  }

  // Helper methods for UI
  void incrementQuantity(String itemId) {
    final item =
        cartData.value?.items.firstWhereOrNull((item) => item.id == itemId);
    if (item != null) {
      updateQuantityLocal(itemId, item.quantity + 1);
    }
  }

  void decrementQuantity(String itemId) {
    final item =
        cartData.value?.items.firstWhereOrNull((item) => item.id == itemId);
    if (item != null && item.quantity > 1) {
      updateQuantityLocal(itemId, item.quantity - 1);
    }
  }

  // Getters for UI
  List<CartItem> get cartItems => cartData.value?.items ?? [];
  double get totalAmount => cartData.value?.totalAmount ?? 0.0;
  int get totalItems => cartData.value?.totalItems ?? 0;
  bool get isCartEmpty => cartItems.isEmpty;
}
