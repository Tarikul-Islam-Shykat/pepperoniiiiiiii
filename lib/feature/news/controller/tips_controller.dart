import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/global_widegts/app_snackbar.dart';
import 'package:prettyrini/core/global_widegts/loading_screen.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/feature/news/data/category_model.dart';
import 'package:prettyrini/feature/news/data/health_card.dart';

class NewsController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();
  // Observable list of health cards
  final RxList<HealthCard> _healthCards = <HealthCard>[].obs;
  final RxList<HealthCard> _filteredCards = <HealthCard>[].obs;
  final Rx<HealthType?> _selectedType = Rx<HealthType?>(null);
  final RxBool _isLoading = false.obs;

  // Getters
  List<HealthCard> get healthCards => _healthCards;
  List<HealthCard> get filteredCards => _filteredCards;
  HealthType? get selectedType => _selectedType.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    // Replace the old method call with the new one
    loadHealthCardsv2();
  }

  Future<bool> loadHealthCardsv2() async {
    try {
      _isLoading.value = true;

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.getNews,
        json.encode({}),
        is_auth: true,
      );
      log("loadHealthCardsv2 response: ${response.toString()}");

      if (response != null && response['success'] == true) {
        // Parse the data from API response
        final data = response['data'];
        if (data != null && data['data'] != null) {
          final List<dynamic> newsItems = data['data'];

          // Convert API data to HealthCard objects using factory constructor
          final List<HealthCard> cards = newsItems.map((item) {
            return HealthCard.fromJson(item);
          }).toList();

          // Update the observable lists
          _healthCards.value = cards;
          _filteredCards.value = cards;

          log("Successfully loaded News");
          // AppSnackbar.show(
          //     message: "News loaded successfully", isSuccess: true);
        } else {
          log("No data found in response");
          AppSnackbar.show(message: "No News found", isSuccess: false);
        }
        return true;
      } else {
        final errorMessage =
            response?['message'] ?? 'Failed to load health cards';
        AppSnackbar.show(message: errorMessage, isSuccess: false);
        return false;
      }
    } catch (e) {
      log("Error loading health cards: $e");
      AppSnackbar.show(message: "Failed to load News: $e", isSuccess: false);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  void refreshData() {
    loadHealthCardsv2();
  }

  // Clear filter
  void clearFilter() {
    _selectedType.value = null;
    _filteredCards.value = _healthCards;
  }

  // Check if filter is active
  bool get isFilterActive => _selectedType.value != null;

  // Get filtered count
  int get filteredCount => _filteredCards.length;

  // Get total count
  int get totalCount => _healthCards.length;
}
