import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/core/global_widegts/loading_screen.dart';
import 'package:prettyrini/feature/dashboard/ui/dashboard.dart';
import 'package:prettyrini/feature/news/controller/tips_controller.dart';
import 'package:prettyrini/feature/news/widget/tips_card_widget.dart';
import 'package:prettyrini/feature/news/data/health_card.dart';

class NewsUi extends StatefulWidget {
  const NewsUi({Key? key}) : super(key: key);

  @override
  State<NewsUi> createState() => _TipsUiScreenState();
}

class _TipsUiScreenState extends State<NewsUi> {
  final NewsController controller = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTipsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          headingText(text: "News"),
        ],
      ),
    );
  }

  Widget _buildTipsList() {
    return Obx(() {
      if (controller.isLoading) {
        return Center(child: loading());
      }

      if (controller.filteredCards.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(50.0),
          child: Text(
            'No news found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: controller.filteredCards
              .map((card) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TipsCardWidget(
                      card: card,
                      controller: controller,
                    ),
                  ))
              .toList(),
        ),
      );
    });
  }
}
