import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getLastMessage(String chatId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('chat')
          .doc(chatId)
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var lastMessage = querySnapshot.docs.first['content'];
        return lastMessage;
      } else {
        return null; // No messages found
      }
    } catch (e) {
      debugPrint("Error fetching last message: $e");
      return null;
    }
  }
}
