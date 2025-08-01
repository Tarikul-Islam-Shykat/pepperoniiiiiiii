class Urls {
  static const String baseUrl = 'https://pepperoniiiiii.vercel.app/api/v1';
  static const String login = '$baseUrl/auth/login';
  static const String signUp = '$baseUrl/users';
  static const String getProfile = '$baseUrl/users/profile';
  static const String getNews = '$baseUrl/news?';
  static const String getProduct = '$baseUrl/product';
  static const String addToCart = '$baseUrl/cart';
  static const String websocketUrl = "ws://10.0.10.97:1122";
  static const String resetPassword = "$baseUrl/auth/reset-password";

  static const String otpVerification = '$baseUrl/auth/verify-otp';

  static const String setupProfile = '$baseUrl/users/update-profile';
  static const String authentication = '$baseUrl/auth/verify-auth';
  static const String logout = '$baseUrl/auth/logout';
  static const String forgotPass = '$baseUrl/auth/forgot-password';
  static const String pickUpLocation = '$baseUrl/user/pickup-locations';
  static String getCalendar(String date, String locationUuid) =>
      '$baseUrl/calendar?date=$date&pickup_location_uuid=$locationUuid';
}
