import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/feature/forum/ui/forum_screen_ui.dart';
import 'package:prettyrini/feature/sales_board/ui/sales_board_ui.dart';

class ForumsSalesTab extends StatefulWidget {
  @override
  _CustomTabBarScreenState createState() => _CustomTabBarScreenState();
}

class _CustomTabBarScreenState extends State<ForumsSalesTab>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          SizedBox(height: 60),
          // Modern Tab Bar Section
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 40,
                  offset: Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Animated sliding indicator
                AnimatedPositioned(
                  duration: Duration(milliseconds: 350),
                  curve: Curves.easeInOutCubic,
                  left: selectedIndex == 0 ? 4 : null,
                  right: selectedIndex == 1 ? 4 : null,
                  top: 4,
                  bottom: 4,
                  width: (MediaQuery.of(context).size.width - 48) / 2,
                  child: AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_slideAnimation.value * 0.02),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF0F766E),
                                Color(0xFF14B8A6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF0F766E).withOpacity(0.25),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Color(0xFF14B8A6).withOpacity(0.15),
                                blurRadius: 24,
                                offset: Offset(0, 8),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Tab buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildModernTabButton(
                          'Forum', 0, Icons.forum_outlined),
                    ),
                    Expanded(
                      child: _buildModernTabButton(
                          'Sales Board', 1, Icons.storefront_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Page content with slide animation
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              physics: BouncingScrollPhysics(),
              children: [
                _buildPageWrapper(ForumScreen(), 0),
                _buildPageWrapper(SalesBoardScreen(), 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTabButton(String title, int index, IconData icon) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              child: Icon(
                icon,
                size: isSelected ? 20 : 18,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
            SizedBox(width: 8),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: isSelected ? 15 : 14,
                letterSpacing: isSelected ? 0.2 : 0,
              ),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageWrapper(Widget child, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, _) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.1)).clamp(0.0, 1.0);
        }

        return Transform.scale(
          scale: Curves.easeInOut.transform(value),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
