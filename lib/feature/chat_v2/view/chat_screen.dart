import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String receiverId;
  final String imageUrl;

  const ChatScreen({
    super.key,
    required this.name,
    required this.receiverId,
    required this.imageUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _chatController = Get.put(ChatController());
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatController.fetchChats(widget.receiverId);

    // Auto-scroll to bottom when new messages arrive
    ever(_chatController.chats, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _chatController.sendMessage(widget.receiverId, message);
      _messageController.clear();
    }
  }

  String formatMessageTime(String isoString) {
    DateTime dateTime = DateTime.parse(isoString).toLocal();
    return DateFormat('hh:mm a').format(dateTime);
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['role'] == 'USER';
    final messageText = message['message'] ?? '';
    final time = formatMessageTime(message['createdAt'] ?? '');

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
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                size: 18.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12.w),
          ],

          // Message Bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue.shade600 : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 20.r : 4.r),
                  topRight: Radius.circular(isUser ? 4.r : 20.r),
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: !isUser
                    ? Border.all(color: Colors.grey.shade200, width: 1)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    messageText,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.grey.shade800,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          color: isUser
                              ? Colors.white.withOpacity(0.8)
                              : Colors.grey.shade500,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isUser) ...[
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.done_all,
                          size: 14.sp,
                          color: Colors.white.withOpacity(0.8),
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
            SizedBox(width: 12.w),
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: widget.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                gradient: widget.imageUrl.isEmpty
                    ? LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: widget.imageUrl.isEmpty
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

  Widget _buildDateSeparator(String date) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              date,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300)),
        ],
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
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade700),
        ),
        title: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: widget.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: widget.imageUrl.isEmpty ? Colors.grey.shade300 : null,
              ),
              child: widget.imageUrl.isEmpty
                  ? Icon(Icons.person, size: 20.sp, color: Colors.grey.shade600)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: Obx(() {
              if (_chatController.isLoadingChats.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_chatController.chats.isEmpty) {
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
                        "No messages yet",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Start the conversation!",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                itemCount: _chatController.chats.length,
                itemBuilder: (context, index) {
                  final message = _chatController.chats[index];

                  // Add date separator if needed
                  bool showDateSeparator = false;
                  if (index == 0) {
                    showDateSeparator = true;
                  } else {
                    final currentDate =
                        DateTime.parse(message['createdAt']).toLocal();
                    final previousDate = DateTime.parse(
                            _chatController.chats[index - 1]['createdAt'])
                        .toLocal();
                    showDateSeparator = currentDate.day != previousDate.day;
                  }

                  return Column(
                    children: [
                      if (showDateSeparator)
                        _buildDateSeparator(
                          DateFormat('MMMM dd, yyyy').format(
                            DateTime.parse(message['createdAt']).toLocal(),
                          ),
                        ),
                      _buildMessageBubble(message),
                    ],
                  );
                },
              );
            }),
          ),

          // Message Input
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Obx(
                    () => _chatController.isSendingMessage.value
                        ? Container(
                            width: 48.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: _sendMessage,
                            child: Container(
                              width: 48.w,
                              height: 48.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade500,
                                    Colors.blue.shade700
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
