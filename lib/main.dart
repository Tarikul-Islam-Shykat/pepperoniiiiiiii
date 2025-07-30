import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/chat/ui/coach_view.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';
import 'package:prettyrini/feature/chat_v2/view/chat_list.dart';
import 'package:prettyrini/feature/chat_v2/view/chat_screen.dart';
import 'package:prettyrini/feature/diagnosis_v2/ui/diagnosis_image_selection.dart';
import 'package:prettyrini/route/route.dart';
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
    // final ChatController chatController = Get.put(ChatController());

    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'pepperoniiiiiiii',
        getPages: AppRoute.routes,
        initialRoute: AppRoute.splashScreen,
        builder: EasyLoading.init(),
        // home: LoginScreen(),
        //   home: SignUpScreen(),
        // home: OtpVeryScreen(),
        // home: EmailVerification(),
        // home: ShopScreen(),
        // home: HomeScreen(),
        // home: CameraScreen(),
        // home: ProfileScreen(),
        // home: NewsUi(),
        //home: ForumScreen(),
        //home: SalesBoardScreen(),
        //  home: ImageSelectionScreen(),
        // home: CartScreen(),
        //home: CoachView(),
        //home: UsersChatList(),
        // home: ChatScreen(
        //   receiverId: "",
        //   name: "logan",
        //   imageUrl:
        //       "https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
        // ),
      ),
    );
  }
}
