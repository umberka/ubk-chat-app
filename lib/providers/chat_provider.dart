// lib/chat_provider.dart
import 'package:chat_app/models/chat.dart';
//import 'package:chat_app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatProvider with ChangeNotifier {
  //final ChatService _chatService = ChatService();
  final List<Chat> _chats = [
    Chat(
        id: '1',
        name: 'Group Chat',
        lastMessage: 'sup',
        timestamp: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()))
  ];

  List<Chat> get chats => _chats;
  /*
  ChatProvider() {
    _initializeChats();
  }

  Future<void> _initializeChats() async {
    try {
      String chatId = '1';

      Map<String, dynamic>? lastMessageData = (await _chatService.getLastMessage(chatId)) as Map<String, dynamic>?;

      _chats = [
        Chat(
          id: chatId,
          name: 'Group Chat',
          lastMessage: lastMessageData != null ? lastMessageData['text'] ?? 'No messages yet' : 'No messages yet',
          timestamp: lastMessageData != null ? lastMessageData['createdAt'].toDate().toString() : '${DateTime.now()}',
        ),
      ];

      notifyListeners();  
    } catch (e) {
      debugPrint("Error initializing chat: $e");
      _chats = [
        Chat(
          id: '1',
          name: 'Group Chat',
          lastMessage: 'No messages yet',
          timestamp: '${DateTime.now()}',
        ),
      ];
      notifyListeners();
    }
  } */

  void addChat(Chat chat) {
    _chats.add(chat);
    notifyListeners();
  }

  void updateChat(String id, String newMessage, String newTime) {
    final chatIndex = _chats.indexWhere((chat) => chat.id == id);
    if (chatIndex >= 0) {
      _chats[chatIndex] = Chat(
        id: _chats[chatIndex].id,
        name: _chats[chatIndex].name,
        lastMessage: newMessage,
        timestamp: newTime,
      );
      notifyListeners();
    }
  }
}
