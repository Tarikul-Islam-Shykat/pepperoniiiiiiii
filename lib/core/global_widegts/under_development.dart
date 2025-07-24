import 'package:flutter/material.dart';
import 'dart:math' as math;

/*
to show as pop up 
 FeatureDevelopmentNotice.showAsPopup(
                        context,
                        title: "Please Wait",
                        message: "This feature is still under development.",
                      );

to show as text
// Use as a normal widget in your layout
Container(
  alignment: Alignment.center, // Centers the widget in its container
  child: FeatureDevelopmentNotice(
    title: "Coming Soon",
    message: "We're working on this feature",
    isPopup: false, // Display inline rather than as popup
    onClose: () {
      // Optional: handle close if you want the X button to appear
    },
  ),
)
*/

class FeatureDevelopmentNotice extends StatefulWidget {
  final VoidCallback? onClose;
  final String title;
  final String message;
  final bool isPopup;

  const FeatureDevelopmentNotice({
    super.key,
    this.onClose,
    this.title = "Please Wait",
    this.message = "This feature is still under development.",
    this.isPopup = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FeatureDevelopmentNoticeState createState() =>
      _FeatureDevelopmentNoticeState();

  // Static method to show as popup
  static void showAsPopup(
    BuildContext context, {
    String title = "Please Wait",
    String message = "This feature is still under development.",
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => FeatureDevelopmentNotice(
            title: title,
            message: message,
            onClose: () => Navigator.of(context).pop(),
            isPopup: true,
          ),
    );
  }
}

class _FeatureDevelopmentNoticeState extends State<FeatureDevelopmentNotice>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget contentWidget = Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 350),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        boxShadow:
            widget.isPopup
                ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
                : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
          if (widget.onClose != null)
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: widget.onClose,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .1),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          if (widget.onClose != null) const SizedBox(height: 16),

          // Development animation
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.only(bottom: 24),
            child: _DevelopmentAnimation(),
          ),

          // Title
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Message
          Text(
            widget.message,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .9),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),

          // Cancel button - only show if there's an onClose callback
          if (widget.onClose != null) ...[
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: widget.onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: .2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );

    // If it's a popup, wrap it in dialog and animations
    if (widget.isPopup) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: contentWidget,
              ),
            ),
          );
        },
      );
    }

    // Otherwise just return the content widget directly
    return contentWidget;
  }
}

// A custom animation showing "development in progress"
class _DevelopmentAnimation extends StatefulWidget {
  @override
  _DevelopmentAnimationState createState() => _DevelopmentAnimationState();
}

class _DevelopmentAnimationState extends State<_DevelopmentAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Rotating gear
            Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: Icon(
                Icons.settings,
                size: 70,
                color: Colors.white.withValues(alpha: .8),
              ),
            ),

            // Secondary rotating gear
            Transform.rotate(
              angle: -_controller.value * 2 * math.pi,
              child: Icon(
                Icons.settings,
                size: 40,
                color: Colors.white.withValues(alpha: .6),
              ),
            ),

            // Pulsing code icon in the center
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Icon(Icons.code, size: 24, color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}

// Example usage as POPUP:
// FeatureDevelopmentNotice.showAsPopup(context);
// 
// Example usage as INLINE widget:
// FeatureDevelopmentNotice(
//   title: "Coming Soon",
//   message: "We're working on this feature",
//   isPopup: false,
// )
/*

import 'package:flutter/material.dart';
import 'dart:math' as math;

class FeatureUnderDevelopmentPopup extends StatefulWidget {
  final VoidCallback onClose;
  final String title;
  final String message;

  const FeatureUnderDevelopmentPopup({
    Key? key,
    required this.onClose,
    this.title = "Please Wait",
    this.message = "This feature is still under development.",
  }) : super(key: key);

  @override
  _FeatureUnderDevelopmentPopupState createState() =>
      _FeatureUnderDevelopmentPopupState();

  // Static method to show the popup easily from anywhere
  static void show(
    BuildContext context, {
    String title = "Please Wait",
    String message = "This feature is still under development.",
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => FeatureUnderDevelopmentPopup(
            title: title,
            message: message,
            onClose: () => Navigator.of(context).pop(),
          ),
    );
  }
}

class _FeatureUnderDevelopmentPopupState
    extends State<FeatureUnderDevelopmentPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _opacityAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 350),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: widget.onClose,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Development animation
                    Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.only(bottom: 24),
                      child: _DevelopmentAnimation(),
                    ),

                    // Title
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Message
                    Text(
                      widget.message,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Cancel button
                    ElevatedButton(
                      onPressed: widget.onClose,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// A custom animation showing "development in progress"
class _DevelopmentAnimation extends StatefulWidget {
  @override
  _DevelopmentAnimationState createState() => _DevelopmentAnimationState();
}

class _DevelopmentAnimationState extends State<_DevelopmentAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Rotating gear
            Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: Icon(
                Icons.settings,
                size: 70,
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            // Secondary rotating gear
            Transform.rotate(
              angle: -_controller.value * 2 * math.pi,
              child: Icon(
                Icons.settings,
                size: 40,
                color: Colors.white.withOpacity(0.6),
              ),
            ),

            // Pulsing code icon in the center
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Icon(Icons.code, size: 24, color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}

*/