import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});

  Map<String, dynamic> toJson() => {'text': text, 'isUser': isUser};

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(text: json['text'], isUser: json['isUser']);
  }
}

class CoachController extends GetxController {
  // UserProfileController userProfileController = Get.put(
  //   UserProfileController(),
  // );

  late String userId;

  var messageController = TextEditingController();
  var messages = <Message>[].obs;

  WebSocket? socket;
  var isWaiting = false.obs;

  @override
  void onInit() {
    super.onInit();
    //userId = userProfileController.userProfile.value?.data.id ?? '6880c0cbacf1e619eeae26ce';
    userId = "6880c0cbacf1e619eeae26ce";
    print("User ID: $userId");
    connectWebSocket();
    loadMessages();
    print("Messages: $messages");
  }

  void connectWebSocket() async {
    try {
      socket = await WebSocket.connect(
        //'wss://jm9ffg7n-5005.inc1.devtunnels.ms',
        "ws://10.0.10.97:1122",
      );
      log("connectWebSocket ");
      socket!.add(jsonEncode({"event": "fetchChats", "userId": userId}));
      log("connectWebSocket ${jsonEncode({
            "event": "fetchChats",
            "userId": userId
          })} ");

      socket!.listen(
        (data) {
          final decoded = jsonDecode(data);

          if (decoded['event'] == 'fetchChats') {
            final chatList = decoded['data'] as List;

            final fetchedMessages = chatList.map((chat) {
              final messageText = chat['message'] as String? ?? '[No message]';
              final role = chat['role'] as String? ?? 'ai';
              return Message(text: messageText, isUser: role == 'user');
            }).toList();

            messages.assignAll(fetchedMessages);
            log("connectWebSocket ${fetchedMessages} = fetchedMessages");

            saveMessages();
          } else if (decoded['event'] == 'message') {
            // Here message text is inside decoded['data'] (a String)
            final messageText = decoded['data'] as String? ?? '[No message]';
            messages.add(Message(text: messageText, isUser: false));
            saveMessages();
          }
        },
        onDone: () {
          print('WebSocket closed');
          // Optionally reconnect here
        },
        onError: (error) {
          print('WebSocket error: $error');
          // Optionally reconnect here
        },
      );
    } catch (e) {
      print('WebSocket connection failed: $e');
    }
  }

  void sendMessage() async {
    log("message");
    if (messageController.text.trim().isEmpty || isWaiting.value) return;

    final text = messageController.text.trim();

    final userMsg = Message(text: text, isUser: true);
    messages.add(userMsg);
    messageController.clear();
    saveMessages();

    // Send the message event to server
    socket?.add(
      jsonEncode({"event": "message", "userId": userId, "message": text}),
    );

    isWaiting.value = true;
    await Future.delayed(Duration(seconds: 2));
    isWaiting.value = false;
  }

  Future<void> saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData =
        messages.map((msg) => json.encode(msg.toJson())).toList();
    await prefs.setStringList('chat_messages', encodedData);
  }

  Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = prefs.getStringList('chat_messages') ?? [];
    messages.assignAll(
      encodedData.map((msg) => Message.fromJson(json.decode(msg))).toList(),
    );
  }

  @override
  void onClose() {
    socket?.close();
    messageController.dispose();
    super.onClose();
  }
}
