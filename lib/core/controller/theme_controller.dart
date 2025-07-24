import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;
  final _prefs = Rx<SharedPreferences?>(null);
  static const String _themeKey = 'is_dark_mode';

  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    _prefs.value = await SharedPreferences.getInstance();
    _isDarkMode.value = _prefs.value?.getBool(_themeKey) ?? false;
    update(); // Update all listeners
  }

  void setTheme(bool isDark) {
    _isDarkMode.value = isDark;
    _saveThemeToPrefs();
    update(); // Update all listeners
  }

  void _saveThemeToPrefs() {
    if (_prefs.value != null) {
      _prefs.value!.setBool(_themeKey, _isDarkMode.value);
    }
  }
}
