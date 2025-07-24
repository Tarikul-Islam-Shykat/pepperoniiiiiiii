import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/feature/dashboard/controller/product_controller.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 20.h),
                _buildNoticeCard(),
                SizedBox(height: 20.h),
                _buildWeatherCard(),
                SizedBox(height: 20.h),
                _buildPopularProduct(),
                SizedBox(height: 20.h),
                _buildTopNews(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundImage: NetworkImage(
            controller.userProfile.value?.imageUrl ?? 
            'https://randomuser.me/api/portraits/women/1.jpg',
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            smallText(text: 'Good Morning', color: Colors.grey),
            normalText(
              text: controller.userProfile.value?.name ?? 'Kathryn Murphy',
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        const Spacer(),
        Icon(Icons.shopping_bag_outlined, size: 24.sp),
        SizedBox(width: 16.w),
        Icon(Icons.notifications_outlined, size: 24.sp),
      ],
    );
  }

  Widget _buildNoticeCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.green, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: normalText(
              text: 'Diagnosis is available without login.',
              color: Colors.green.shade700,
            ),
          ),
          Icon(Icons.close, color: Colors.green, size: 20.sp),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        normalText(text: 'Today Weather', fontWeight: FontWeight.w600),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E8B8B), Color(0xFF4A9B9B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headingText(
                      text: '${controller.weather.value?.temperature.toInt()}°',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    smallText(
                      text: controller.weather.value?.date ?? '20 March',
                      color: Colors.white70,
                    ),
                    SizedBox(height: 16.h),
                    smallText(text: 'Current Location', color: Colors.white70),
                    normalText(
                      text: controller.weather.value?.location ?? 'Dhaka',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(Icons.cloud, color: Colors.white, size: 32.sp),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: List.generate(
                      4,
                      (index) => Container(
                        margin: EdgeInsets.only(right: 4.w),
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Colors.lightBlueAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  smallText(text: 'Rainy', color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            normalText(text: 'Popular Product', fontWeight: FontWeight.w600),
            smallText(text: 'See All', color: Colors.blue),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              children: [
                Positioned(
                  right: 20.w,
                  top: 20.h,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=200',
                    width: 80.w,
                    height: 80.h,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  left: 20.w,
                  top: 20.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headingText(
                        text: '30%',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      normalText(
                        text: 'Discount only',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      normalText(
                        text: 'valid for today!',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        width: index == 0 ? 20.w : 8.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: index == 0 ? Colors.white : Colors.white54,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopNews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            normalText(text: 'Top News', fontWeight: FontWeight.w600),
            smallText(text: 'See All', color: Colors.blue),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.newsList.length,
            itemBuilder: (context, index) {
              final news = controller.newsList[index];
              return Container(
                width: 280.w,
                margin: EdgeInsets.only(right: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        news.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      // Gradient overlay for fading effect
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16.h,
                        left: 16.w,
                        right: 16.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            normalText(
                              text: news.title,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              maxLines: 2,
                            ),
                            SizedBox(height: 4.h),
                            smallText(
                              text: news.description,
                              color: Colors.white70,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 16.h,
                        right: 16.w,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}