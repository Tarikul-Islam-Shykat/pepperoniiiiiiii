import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/global_widegts/dev_top_space.dart';
import 'package:prettyrini/core/global_widegts/loading_screen.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';
import 'package:prettyrini/feature/chat_v2/view/chat_screen.dart';

class UsersChatList extends StatefulWidget {
  const UsersChatList({super.key});
  @override
  State<UsersChatList> createState() => _UserChatListScreenState();
}

class _UserChatListScreenState extends State<UsersChatList> {
  final ChatController _chatController = Get.put(ChatController());

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
    });
  }

  Future<void> loadData() async {
    await setData();
  }

  setData() async {}

  String formatTo12Hour(String isoString) {
    DateTime dateTime = DateTime.parse(isoString).toLocal();
    return DateFormat('hh:mm a').format(dateTime);
  }

  String formatDateOnly(String isoString) {
    DateTime dateTime = DateTime.parse(isoString).toLocal();
    return DateFormat('MMM dd').format(dateTime);
  }

  Widget _buildMessageBubble({
    required String message,
    required bool isUser,
    required String time,
    String? profileImage,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar (left side)
          if (!isUser) ...[
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
                border: Border.all(color: Colors.blue.shade300, width: 1),
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                size: 18.sp,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(width: 8.w),
          ],

          // Message Bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue.shade600 : Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 18.r : 4.r),
                  topRight: Radius.circular(isUser ? 4.r : 18.r),
                  bottomLeft: Radius.circular(18.r),
                  bottomRight: Radius.circular(18.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.grey.shade800,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          color: isUser
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey.shade500,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (isUser) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.done_all,
                          size: 14.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          // User Avatar (right side)
          if (isUser) ...[
            SizedBox(width: 8.w),
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: profileImage != null && profileImage.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(profileImage),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: profileImage == null || profileImage.isEmpty
                    ? Colors.blue.shade600
                    : null,
                border: Border.all(color: Colors.blue.shade300, width: 1),
              ),
              child: profileImage == null || profileImage.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 18.sp,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChatPreviewCard({
    required String userName,
    required String lastMessage,
    required String lastMessageTime,
    required String profileImage,
    required bool isLastMessageFromUser,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Profile Image
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: profileImage.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(profileImage),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: profileImage.isEmpty ? Colors.grey.shade300 : null,
                  ),
                  child: profileImage.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 28.sp,
                          color: Colors.grey.shade600,
                        )
                      : null,
                ),

                SizedBox(width: 16.w),

                // Chat Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Last Message with indicator
                      Row(
                        children: [
                          if (isLastMessageFromUser) ...[
                            Icon(
                              Icons.reply,
                              size: 14.sp,
                              color: Colors.blue.shade600,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "You: ",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ] else ...[
                            Icon(
                              Icons.smart_toy_outlined,
                              size: 14.sp,
                              color: Colors.green.shade600,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "AI: ",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.green.shade600,
                              ),
                            ),
                          ],
                          Expanded(
                            child: Text(
                              lastMessage,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Time and Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatDateOnly(lastMessageTime),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      formatTo12Hour(lastMessageTime),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Messages',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _chatController.refreshUserList(),
            icon: Icon(
              Icons.refresh,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _chatController.refreshUserList(),
        child: Obx(() {
          if (_chatController.isLoadingUserList.value) {
            return Center(child: loading());
          }

          if (_chatController.usersWithLastMessages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64.sp,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "No conversations yet",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Start a conversation to see it here",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          final sortedList = _chatController.usersWithLastMessages.toList()
            ..sort((a, b) {
              final aTime = DateTime.parse(a['lastMessage']['createdAt']);
              final bTime = DateTime.parse(b['lastMessage']['createdAt']);
              return bTime.compareTo(aTime); // latest first
            });

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: sortedList.length,
            itemBuilder: (context, index) {
              final user = sortedList[index];
              final userName = user['user']['fullName'] ?? "Unknown User";
              final lastMessage = user['lastMessage'] ?? {};
              final lastMessageText = lastMessage['message'] ?? "No message";
              final lastMessageTime = lastMessage['createdAt'] ?? "";
              final profileImage = user['user']['profileImage'] ?? "";
              final userId = user['user']['id'] ?? user['user']['_id'] ?? "";
              final isLastMessageFromUser = lastMessage['role'] == 'USER';

              return _buildChatPreviewCard(
                userName: userName,
                lastMessage: lastMessageText,
                lastMessageTime: lastMessageTime,
                profileImage: profileImage,
                isLastMessageFromUser: isLastMessageFromUser,
                onTap: () {
                  Get.to(
                    () => ChatScreen(
                      name: userName,
                      receiverId: userId,
                      imageUrl: profileImage,
                    ),
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}

/*
class UsersChatList extends StatefulWidget {
  const UsersChatList({super.key});
  @override
  State<UsersChatList> createState() => _UserChatListScreenState();
}

class _UserChatListScreenState extends State<UsersChatList> {
  final ChatController _chatController = Get.put(ChatController());

  var name = "";
  var role = "";
  var imaegPath = "";
  var rating = "";

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
    });
  }

  Future<void> loadData() async {
    await setData();
  }

  setData() async {}

  String formatTo12Hour(String isoString) {
    DateTime dateTime =
        DateTime.parse(isoString).toLocal(); // Convert to local time
    return DateFormat('hh:mm a').format(dateTime); // Format as 12-hour time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: RefreshIndicator(
        onRefresh: () => _chatController.refreshUserList(),
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              devTopSpace(),
              _buildHeader(context),
              Expanded(
                child: Obx(() {
                  if (_chatController.isLoadingUserList.value) {
                    return Center(child: loading());
                  }

                  if (_chatController.usersWithLastMessages.isEmpty) {
                    return Center(
                      child: Text(
                        "No messages found.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  final sortedList =
                      _chatController.usersWithLastMessages.toList()
                        ..sort((a, b) {
                          final aTime = DateTime.parse(
                            a['lastMessage']['createdAt'],
                          );
                          final bTime = DateTime.parse(
                            b['lastMessage']['createdAt'],
                          );
                          return bTime.compareTo(aTime); // latest first
                        });

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: sortedList.length,
                    itemBuilder: (context, index) {
                      final user = sortedList[index];
                      // return ListView.builder(
                      //   padding: EdgeInsets.zero,
                      //   physics: const AlwaysScrollableScrollPhysics(),
                      //   itemCount: _chatController.usersWithLastMessages.length,
                      //   itemBuilder: (context, index) {
                      //     final user = _chatController.usersWithLastMessages[index];
                      final userName =
                          user['user']['fullName'] ?? "Unknown User";
                      final lastMessage =
                          user['lastMessage']['message'] ?? "No message";
                      final lastMessageTime =
                          user['lastMessage']['createdAt'] ?? "";
                      final profilImage = user['user']['profileImage'] ?? "";

                      return ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: profilImage.isNotEmpty
                                  ? NetworkImage(profilImage)
                                  : const AssetImage(
                                      "assets/images/no_image.png",
                                    ) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        subtitle: Text(
                          lastMessage,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                        //    trailing: Text(lastMessageTime.split("T").first),
                        trailing: Text(
                          textAlign: TextAlign.end,
                          "${lastMessageTime.split("T")[0]}\n${formatTo12Hour(lastMessageTime)}",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Get.to(
                            () => ChatScreen(
                              name: userName,
                              receiverId: "dsf",
                              imageUrl: user['user']['profileImage'] ?? "",
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chatting',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(thickness: 2, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}

*/
