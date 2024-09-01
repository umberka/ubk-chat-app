import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_messages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();
  }

  @override
  void initState() {
    super.initState();

    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final chat =
        chatProvider.chats.firstWhere((chat) => chat.id == widget.chatId);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(chat.name),
      ),
      body: Column(
        children: [
          const Expanded(child: ChatMessages()),
          NewMessages(chatId: widget.chatId),
        ],
      ),
    );
  }
}
