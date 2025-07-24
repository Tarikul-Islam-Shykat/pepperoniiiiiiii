import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/feature/shop/controller/shop_controller.dart';
import 'package:prettyrini/feature/shop/ui/shop_product_details_screen.dart';
import 'package:prettyrini/feature/shop/widgets/shop_products_card.dart';


class ProductListScreen extends StatelessWidget {
  final String? title;
  final ProductController controller = Get.find<ProductController>();

  ProductListScreen({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            controller.clearCategoryFilter();
            Get.back();
          },
        ),
        title: headingText(
          text: title ?? controller.selectedCategory.value?.name ?? "Products",
          color: Colors.black,
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: EdgeInsets.all(16.w),
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: TextField(
              onChanged: (value) => controller.searchProducts(value),
              decoration: InputDecoration(
                hintText: "Search products...",
                hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              ),
            ),
          ),
          
          // Products Grid
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      normalText(
                        text: "No products found",
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.filteredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Get.to(() => ProductDetailScreen(productId: product.id));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}