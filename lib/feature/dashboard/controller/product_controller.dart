import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prettyrini/feature/dashboard/model/new_item_model.dart';
import 'package:prettyrini/feature/dashboard/model/user_profile_model.dart';
import 'package:prettyrini/feature/dashboard/model/weather_data_model.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var userProfile = Rx<UserProfile?>(null);
  var weather = Rx<WeatherData?>(null);
  var newsList = <NewsItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
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

  void loadNewsData() {
    newsList.value = [
      NewsItem(
        title: 'US egg industry kills 350 million chicks',
        description: 'The US egg industry kills about 350 million male chicks...',
        imageUrl: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400',
      ),
      NewsItem(
        title: 'Climate Change Impact on Agriculture',
        description: 'New study reveals significant impact of climate change on global food production...',
        imageUrl: 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400',
      ),
      NewsItem(
        title: 'Technology Innovation in Healthcare',
        description: 'Revolutionary breakthrough in medical technology promises better patient outcomes...',
        imageUrl: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
      ),
    ];
  }
}