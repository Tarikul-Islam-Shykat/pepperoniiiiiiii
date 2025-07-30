import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/services_class/local/user_info.dart';
import 'package:prettyrini/feature/chat_v2/service/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends GetxController {
  final WebSocketService _socketService = WebSocketService();

  var usersWithLastMessages = [].obs;
  var chats = [].obs;

  // Loading states
  var isLoadingChats = true.obs;
  var isLoadingUserList = false.obs;
  var isRefreshingUserList = false.obs;
  var isSendingMessage = false.obs;

  // Current user ID for message identification
  var currentUserId = "".obs;

  void connectSocket(String url, String token) {
    _socketService.connect(url, token);
    _socketService.messages.listen((message) {
      _handleMessage(message);
    });
    fetchUserList();
  }

  void _handleMessage(dynamic message) {
    if (kDebugMode) {
      print("Received WebSocket message: $message");
    }

    final data = jsonDecode(message);

    switch (data['event']) {
      case "messageList":
        usersWithLastMessages.value = data['data'];
        // Stop loading states for user list operations
        isLoadingUserList.value = false;
        isRefreshingUserList.value = false;
        break;
      case "fetchChats":
        chats.value = data['data'];
        isLoadingChats.value = false;
        break;
      case "message":
        // Add new message to chats
        final newMessage = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'role': 'AI',
          'message': data['data'],
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'userId': currentUserId.value,
        };
        chats.add(newMessage);
        chats.refresh();

        // Update the user list with the new message
        _updateUserListWithNewMessage(newMessage);

        // Stop sending message loading state
        isSendingMessage.value = false;
        break;
      default:
        if (kDebugMode) {
          print("Unknown event type: ${data['event']}");
        }
    }
  }

  void _updateUserListWithNewMessage(Map<String, dynamic> newMessage) {
    // Find and update the user in the list with the new last message
    final userIndex = usersWithLastMessages.indexWhere((user) =>
        user['user']['id'] == currentUserId.value ||
        user['user']['_id'] == currentUserId.value);

    if (userIndex != -1) {
      usersWithLastMessages[userIndex]['lastMessage'] = {
        'message': newMessage['message'],
        'createdAt': newMessage['createdAt'],
        'role': newMessage['role'],
      };
      usersWithLastMessages.refresh();
    }
  }

  void fetchUserList() {
    isLoadingUserList.value = true;
    _socketService.sendMessage("messageList", {});
  }

  Future<void> refreshUserList() async {
    isRefreshingUserList.value = true;
    usersWithLastMessages.clear();
    fetchUserList();
  }

  void fetchChats(String receiverId) {
    isLoadingChats.value = true;
    _socketService.sendMessage("fetchChats", {"receiverId": receiverId});
  }

  void sendMessage(String receiverId, String message, {List<String>? images}) {
    isSendingMessage.value = true;

    // Add user message to chats immediately
    final userMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'role': 'USER',
      'message': message,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'userId': currentUserId.value,
    };
    chats.add(userMessage);
    chats.refresh();

    // Update the user list with the user's message
    _updateUserListWithNewMessage(userMessage);

    final payload = {
      "receiverId": receiverId,
      "message": message,
      "images": images ?? [],
    };
    _socketService.sendMessage("message", payload);
  }

  @override
  void onClose() {
    _socketService.close();
    super.onClose();
  }

  @override
  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var localService = LocalService();
    var uuserId = await localService.getUserId();
    currentUserId.value = uuserId; // This should be extracted from your token

    if (kDebugMode) {
      print("Initializing WebSocket connection...");
    }

    if (token != null) {
      connectSocket(Urls.websocketUrl, token);
    } else {
      if (kDebugMode) {
        print("No token found.");
      }
    }

    super.onInit();
  }
}
/*
class ChatController extends GetxController {
  final WebSocketService _socketService = WebSocketService();

  var usersWithLastMessages = [].obs;
  var chats = [].obs;

  // Loading states
  var isLoadingChats = true.obs;
  var isLoadingUserList = false.obs;
  var isRefreshingUserList = false.obs;
  var isSendingMessage = false.obs;

  void connectSocket(String url, String token) {
    _socketService.connect(url, token);
    _socketService.messages.listen((message) {
      _handleMessage(message);
    });
    fetchUserList();
  }

  void _handleMessage(dynamic message) {
    if (kDebugMode) {
      print("Received WebSocket message: $message");
    }

    final data = jsonDecode(message);

    switch (data['event']) {
      case "messageList":
        usersWithLastMessages.value = data['data'];
        // Stop loading states for user list operations
        isLoadingUserList.value = false;
        isRefreshingUserList.value = false;
        break;
      case "fetchChats":
        chats.value = data['data'];
        isLoadingChats.value = false;
        break;
      case "message":
        chats.add(data['data']);
        chats.refresh();
        // Stop sending message loading state
        isSendingMessage.value = false;
        break;
      default:
        if (kDebugMode) {
          print("Unknown event type: ${data['event']}");
        }
    }
  }

  void fetchUserList() {
    isLoadingUserList.value = true;
    _socketService.sendMessage("messageList", {});
  }

  Future<void> refreshUserList() async {
    isRefreshingUserList.value = true;
    usersWithLastMessages.clear();
    fetchUserList();
  }

  void fetchChats(String receiverId) {
    isLoadingChats.value = true;
    _socketService.sendMessage("fetchChats", {"receiverId": receiverId});
  }

  void sendMessage(String receiverId, String message, {List<String>? images}) {
    isSendingMessage.value = true;
    final payload = {
      "receiverId": receiverId,
      "message": message,
      "images": images ?? [],
    };
    _socketService.sendMessage("message", payload);
  }

  @override
  void onClose() {
    _socketService.close();
    super.onClose();
  }

  @override
  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  String? token = prefs.getString('token');
    String? token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4ODBjMDlmZjgyMzEwMjFjMWQ4NGM5MSIsImVtYWlsIjoiYWRtaW5AZ21haWwuY29tIiwicm9sZSI6IkFETUlOIiwiaWF0IjoxNzUzODUxMjMzLCJleHAiOjE3NTY0NDMyMzN9.YtaqG3_MptP2n1krqe_JoXsAJFE9cWPL5G6kZ3KsKcU";
    if (kDebugMode) {
      print("Initializing WebSocket connection...");
    }

    if (token != null) {
      connectSocket(Urls.websocketUrl, token);
    } else {
      if (kDebugMode) {
        print("No token found.");
      }
    }

    super.onInit();
  }
}

class ChatController extends GetxController {
  final WebSocketService _socketService = WebSocketService();

  var usersWithLastMessages = [].obs;
  var chats = [].obs;
  var isLoadingChats = true.obs;

  void connectSocket(String url, String token) {
    _socketService.connect(url, token);
    _socketService.messages.listen((message) {
      _handleMessage(message);
    });
    fetchUserList();
  }

  void _handleMessage(dynamic message) {
    if (kDebugMode) {
      print("Received WebSocket message: $message");
    }

    final data = jsonDecode(message);

    switch (data['event']) {
      case "messageList":
        usersWithLastMessages.value = data['data'];
        break;
      case "fetchChats":
        chats.value = data['data'];
        isLoadingChats.value = false;
        break;
      case "message":
        chats.add(data['data']);
        chats.refresh();
        break;
      default:
        if (kDebugMode) {
          print("Unknown event type: ${data['event']}");
        }
    }
  }

  void fetchUserList() {
    _socketService.sendMessage("messageList", {});
  }

  Future<void> refreshUserList() async {
    usersWithLastMessages.clear();
    fetchUserList();
  }

  void fetchChats(String receiverId) {
    isLoadingChats.value = true;
    _socketService.sendMessage("fetchChats", {"receiverId": receiverId});
  }

  void sendMessage(String receiverId, String message, {List<String>? images}) {
    final payload = {
      "receiverId": receiverId,
      "message": message,
      "images": images ?? [],
    };
    _socketService.sendMessage("message", payload);
  }

  @override
  void onClose() {
    _socketService.close();
    super.onClose();
  }

  @override
  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (kDebugMode) {
      print("Initializing WebSocket connection...");
    }

    if (token != null) {
      connectSocket(Urls.websocketUrl, token);
    } else {
      if (kDebugMode) {
        print("No token found.");
      }
    }

    super.onInit();
  }
}

*/
