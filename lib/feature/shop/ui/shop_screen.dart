import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/feature/shop/controller/shop_controller.dart';
import 'package:prettyrini/feature/shop/ui/shop_product_details_screen.dart';
import 'package:prettyrini/feature/shop/ui/shop_product_list_screen.dart';
import 'package:prettyrini/feature/shop/widgets/categoru_card.dart';
import 'package:prettyrini/feature/shop/widgets/shop_products_card.dart';

class ShopScreen extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: TextField(
            onChanged: (value) => controller.searchProducts(value),
            decoration: InputDecoration(
              hintText: "I am looking for",
              hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories Section
              _buildCategoriesSection(),
              SizedBox(height: 24.h),

              // Top Selling Section
              _buildTopSellingSection(),
              SizedBox(height: 24.h),

              // New Products Section
              _buildNewProductsSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingText(text: "Categories", color: Colors.black),
        SizedBox(height: 16.h),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: CategoryCard(
                  category: category,
                  onTap: () {
                    controller.selectCategory(category);
                    Get.to(() => ProductListScreen());
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopSellingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            headingText(text: "Top Selling", color: Colors.black),
            GestureDetector(
              onTap: () {
                // Navigate to see all top selling products
                controller.filteredProducts.value =
                    controller.topSellingProducts;
                Get.to(() => ProductListScreen(title: "Top Selling"));
              },
              child: smallText(
                text: "See all",
                color: const Color(0xff008080),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.topSellingProducts.length,
            itemBuilder: (context, index) {
              final product = controller.topSellingProducts[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: ProductCard(
                  product: product,
                  onTap: () {
                    Get.to(() => ProductDetailScreen(productId: product.id));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            headingText(text: "New Product", color: Colors.black),
            GestureDetector(
              onTap: () {
                // Navigate to see all new products
                controller.filteredProducts.value = controller.newProducts;
                Get.to(() => ProductListScreen(title: "New Products"));
              },
              child: smallText(
                text: "See all",
                color: const Color(0xff008080),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 280.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.newProducts.length,
            itemBuilder: (context, index) {
              final product = controller.newProducts[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: ProductCard(
                  product: product,
                  onTap: () {
                    Get.to(() => ProductDetailScreen(productId: product.id));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
