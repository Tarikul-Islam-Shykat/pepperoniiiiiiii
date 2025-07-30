import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/global_widegts/custom_text_field.dart';
import 'package:prettyrini/core/style/global_text_style.dart';
import 'package:prettyrini/feature/chat/contrller%20/coach_controller.dart';

class AiCoachChat extends StatelessWidget {
  AiCoachChat({super.key});

  final CoachController controller = Get.put(CoachController());
  // final UserProfileController userProfileController =
  //     Get.find<UserProfileController>();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        leading: Padding(
          padding: EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () => Get.back(),
            child: CircleAvatar(
              radius: 21,
              backgroundColor: Color(0xFFF1F2F6).withAlpha(25),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Ai Coach",
          style: globalTextStyle(
            color: Color(0xFFF1F2F6),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients) {
                    scrollController.animateTo(
                      scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(20),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];

                    return Row(
                      mainAxisAlignment: message.isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: message.isUser
                          ? [
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: globalTextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // CircleAvatar(
                              //   radius: 12,
                              //   backgroundImage:
                              //       (userProfileController
                              //                       .userProfile
                              //                       .value
                              //                       ?.data
                              //                       .profileImage ??
                              //                   '')
                              //               .isNotEmpty
                              //           ? NetworkImage(
                              //             userProfileController
                              //                 .userProfile
                              //                 .value!
                              //                 .data
                              //                 .profileImage,
                              //           )
                              //           : AssetImage(ImagePath.appImage),
                              // ),
                            ]
                          : [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: AssetImage(
                                  ImagePath.alert,
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                    );
                  },
                );
              }),
            ),
            Row(
              children: [
                CustomTextField(
                    textEditingController: controller.messageController),
                GestureDetector(
                    onTap: () {
                      controller.sendMessage();
                    },
                    child: Icon(Icons.send))
              ],
            ),

            // Padding(
            //   padding: EdgeInsets.only(left: 20, right: 20, bottom: 35),
            //   child: CustomTextField(
            //     controller: controller.messageController,
            //     suffix: Padding(
            //       padding: EdgeInsets.only(right: 20),
            //       child: InkWell(
            //         onTap: controller.sendMessage,
            //         child: Image.asset(IconsPath.sendButton, width: 20),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
