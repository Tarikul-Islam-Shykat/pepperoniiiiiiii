import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/feature/news/data/health_card.dart';

class NewsDetailsPage extends StatefulWidget {
  final HealthCard card;

  const NewsDetailsPage({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late ScrollController _scrollController;

  bool _showFloatingButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && !_showFloatingButton) {
        setState(() => _showFloatingButton = true);
      } else if (_scrollController.offset <= 100 && _showFloatingButton) {
        setState(() => _showFloatingButton = false);
      }
    });

    // Start animations
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Recently published';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                onPressed: () => Get.back(),
              ),
            ),
            actions: [
              // Container(
              //   margin: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.9),
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.1),
              //         blurRadius: 8,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: IconButton(
              //     icon: const Icon(Icons.share_outlined, color: Colors.black87),
              //     onPressed: () {
              //       // Add share functionality
              //       Get.snackbar(
              //         'Share',
              //         'Sharing functionality will be implemented here',
              //         snackPosition: SnackPosition.BOTTOM,
              //         backgroundColor: AppColors.primaryColor,
              //         colorText: Colors.white,
              //       );
              //     },
              //   ),
              // ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.8 + (_slideAnimation.value * 0.2),
                    child: CachedNetworkImage(
                      imageUrl: widget.card.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 80,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Content Section
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - _fadeAnimation.value)),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Publication time with modern styling
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryColor.withOpacity(0.1),
                                    AppColors.primaryColor.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 16,
                                    color: AppColors.primaryColor,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _getTimeAgo(widget.card.createdAt),
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Title with modern typography
                            Text(
                              widget.card.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                                height: 1.3,
                                letterSpacing: -0.5,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Modern divider
                            Container(
                              height: 4,
                              width: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.primaryColor.withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Description with enhanced readability
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.card.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.8,
                                  color: Colors.black87,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // // Action buttons
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Container(
                            //         height: 56,
                            //         decoration: BoxDecoration(
                            //           gradient: LinearGradient(
                            //             colors: [
                            //               AppColors.primaryColor,
                            //               AppColors.primaryColor
                            //                   .withOpacity(0.8),
                            //             ],
                            //           ),
                            //           borderRadius: BorderRadius.circular(16),
                            //           boxShadow: [
                            //             BoxShadow(
                            //               color: AppColors.primaryColor
                            //                   .withOpacity(0.3),
                            //               blurRadius: 12,
                            //               offset: const Offset(0, 4),
                            //             ),
                            //           ],
                            //         ),
                            //         child: ElevatedButton.icon(
                            //           onPressed: () {
                            //             // Add bookmark functionality
                            //             Get.snackbar(
                            //               'Bookmarked',
                            //               'Article saved to your bookmarks',
                            //               snackPosition: SnackPosition.BOTTOM,
                            //               backgroundColor: Colors.green,
                            //               colorText: Colors.white,
                            //             );
                            //           },
                            //           style: ElevatedButton.styleFrom(
                            //             backgroundColor: Colors.transparent,
                            //             shadowColor: Colors.transparent,
                            //             shape: RoundedRectangleBorder(
                            //               borderRadius:
                            //                   BorderRadius.circular(16),
                            //             ),
                            //           ),
                            //           icon: const Icon(
                            //             Icons.bookmark_add_outlined,
                            //             color: Colors.white,
                            //           ),
                            //           label: const Text(
                            //             'Bookmark Article',
                            //             style: TextStyle(
                            //               color: Colors.white,
                            //               fontWeight: FontWeight.w600,
                            //               fontSize: 16,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedScale(
        scale: _showFloatingButton ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          backgroundColor: AppColors.primaryColor,
          child: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
        ),
      ),
    );
  }
}
