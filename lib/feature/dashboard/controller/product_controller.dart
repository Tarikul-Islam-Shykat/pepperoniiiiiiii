import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prettyrini/core/global_widegts/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/core/services_class/local/user_info.dart';
import 'package:prettyrini/feature/dashboard/model/new_item_model.dart';
import 'package:prettyrini/feature/dashboard/model/user_profile_model.dart';
import 'package:prettyrini/feature/dashboard/model/weather_data_model.dart';
import 'package:prettyrini/feature/news/data/health_card.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var userProfile = Rx<UserProfile?>(null);
  var weather = Rx<WeatherData?>(null);
  var newsList = <NewsItem>[].obs;
  final NetworkConfig _networkConfig = NetworkConfig();

  @override
  void onInit() {
    super.onInit();
    loadData();
    loadUserInfo();
  }

  var name = ''.obs;
  var image = ''.obs;

  Future<void> loadUserInfo() async {
    final LocalService localService = LocalService();
    final savedName = await localService.getName();
    final savedImage = await localService.getImagePath();
    log("loadUserInfo $savedImage - $savedName");
    name.value = savedName;
    image.value = savedImage;
  }

  Future<void> loadData() async {
    fetchUserProfile();
    loadWeatherData();
    loadNewsData();

    isLoading.value = false;
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userProfile.value = UserProfile.fromJson(data['results'][0]);
      }
    } catch (e) {
      // Fallback data
      userProfile.value = UserProfile(
        name: 'Kathryn Murphy',
        imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
      );
    }
  }

  void loadWeatherData() {
    // Using dummy data since you mentioned any free package
    weather.value = WeatherData(
      temperature: 17.0,
      location: 'Dhaka',
      condition: 'Rainy',
      date: '20 March',
    );
  }

  // void loadNewsData() {
  //   newsList.value = [
  //     NewsItem(
  //       title: 'US egg industry kills 350 million chicks',
  //       description: 'The US egg industry kills about 350 million male chicks...',
  //       imageUrl: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400',
  //     ),
  //     NewsItem(
  //       title: 'Climate Change Impact on Agriculture',
  //       description: 'New study reveals significant impact of climate change on global food production...',
  //       imageUrl: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400',
  //     ),
  //     NewsItem(
  //       title: 'Technology Innovation in Healthcare',
  //       description: 'Revolutionary breakthrough in medical technology promises better patient outcomes...',
  //       imageUrl: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
  //     ),
  //   ];
  // }
  final RxBool _isLoading = false.obs;
  final RxList<HealthCard> _healthCards = <HealthCard>[].obs;

  Future<bool> loadNewsData() async {
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
}
