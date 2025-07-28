import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/core/global_widegts/loading_screen.dart';
import 'package:prettyrini/feature/shop/controller/shop_controller.dart';
import 'package:prettyrini/feature/shop/model/product_data_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId; // Changed to String to match API

  ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductController controller = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    // Load single product when screen initializes
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    await controller.getSingleProduct(widget.productId);
  }

  @override
  void dispose() {
    // Clear current product when leaving screen
    controller.clearCurrentProduct();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: normalText(text: "Product Details", color: Colors.black),
        centerTitle: true,
      ),
      body: Obx(() {
        // Show loading indicator while fetching product
        if (controller.isSingleProductsLoading.value) {
          return Center(
            child: loading(),
          );
        }

        if (controller.isCartLoading.value) {
          return Center(
            child: loading(),
          );
        }

        if (controller.currentProduct.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 16.h),
                normalText(text: "Product not found", color: Colors.grey),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: _loadProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff008080),
                  ),
                  child: normalText(
                    text: "Retry",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        final product = controller.currentProduct.value!;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Breadcrumb
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        children: [
                          smallText(text: "Product", color: Colors.grey),
                          smallText(text: " > ", color: Colors.grey),
                          smallText(
                              text: "Product Details", color: Colors.grey),
                        ],
                      ),
                    ),

                    // Product Images
                    if (product.hasImages)
                      Container(
                        width: double.infinity,
                        height: 300.h,
                        margin: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: PageView.builder(
                            itemCount: product.images.length,
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: product.images[index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    color: const Color(0xff008080),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name and Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: headingText(
                                  text: product.name,
                                  color: Colors.black,
                                  maxLines: 2,
                                ),
                              ),
                              if (product.avgRating > 0)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff008080),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 14.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      smallText(
                                        text: product.avgRating
                                            .toStringAsFixed(1),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(height: 8.h),

                          // Price and Weight
                          Row(
                            children: [
                              headingText(
                                text: "\$${product.price.toStringAsFixed(2)}",
                                color: const Color(0xff008080),
                              ),
                              if (product.weight != null) ...[
                                SizedBox(width: 8.w),
                                smallText(
                                  text: "• ${product.weight}",
                                  color: Colors.grey,
                                ),
                              ],
                            ],
                          ),

                          SizedBox(height: 16.h),

                          // Description
                          if (product.description != null &&
                              product.description!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headingText(
                                  text: "Description",
                                  color: Colors.black,
                                ),
                                SizedBox(height: 8.h),
                                normalText(
                                  text: product.description!,
                                  color: Colors.grey.shade700,
                                  maxLines: 10,
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),

                          // Product Details
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                headingText(
                                  text: "Product Details",
                                  color: Colors.black,
                                ),
                                if (product.weight != null)
                                  _buildDetailRow("Weight", product.weight!),
                                if (product.avgRating > 0)
                                  _buildDetailRow("Rating",
                                      "${product.avgRating.toStringAsFixed(1)}/5.0"),
                                if (product.categoryId != null)
                                  _buildDetailRow(
                                      "Category ID", product.categoryId!),
                                if (product.isTopSelling)
                                  _buildDetailRow("Badge", "Top Selling"),
                                if (product.isNewProduct)
                                  _buildDetailRow("Badge", "New Product"),
                              ],
                            ),
                          ),

                          SizedBox(height: 100.h), // Space for bottom buttons
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons

            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.addToCart(widget.productId);
                        // Add to cart functionality
                        // Get.snackbar(
                        //   "Added to Cart",
                        //   "${product.name} has been added to your cart",
                        //   backgroundColor: Colors.green,
                        //   colorText: Colors.white,
                        //   duration: const Duration(seconds: 2),
                        // );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: const Color(0xff008080)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: normalText(
                        text: "Add To Cart",
                        color: const Color(0xff008080),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Buy now functionality
                        Get.snackbar(
                          "Purchase Initiated",
                          "Proceeding to checkout for ${product.name}",
                          backgroundColor: const Color(0xff008080),
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff008080),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: normalText(
                        text: "Buy Now",
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          smallText(text: label, color: Colors.grey.shade600),
          Flexible(
            child: smallText(
              text: value,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
