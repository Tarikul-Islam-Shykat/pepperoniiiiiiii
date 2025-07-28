import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/cart/ui/cart_ui.dart';
import 'package:prettyrini/feature/shop/ui/shop_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/const/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configEasyLoading();
  await SharedPreferences.getInstance();
  Get.put(ThemeController());
  runApp(const MyApp());
}

void configEasyLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = AppColors.grayColor
    ..textColor = Colors.white
    ..indicatorColor = Colors.white
    ..maskColor = Colors.green
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  @override
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Foot Fitness',
        // getPages: AppRoute.routes,
        // initialRoute: AppRoute.splashScreen,
        // builder: EasyLoading.init(),
        // home: LoginScreen(),
        //   home: SignUpScreen(),
        // home: OtpVeryScreen(),h
        // home: EmailVerification(),
        // home: ShopScreen(),
        // home: HomeScreen(),
        //  home: CameraScreen(),
        // home: ProfileScreen(),
        //  home: NewsUi(),
        // home: ForumScreen(),
        // home: SalesBoardScreen(),
        //    home: ImageSelectionScreen(),
        home: CartScreen(),
      ),
    );
  }
}
