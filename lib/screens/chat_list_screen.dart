import 'package:chat_app/models/chat.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/utilities/colors.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final chats = chatProvider.chats;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chats'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: grey,
              child: Icon(Icons.person),
            ),
            title: Text(chats[index].name),
            subtitle: Text(chats[index].lastMessage),
            trailing: Text(chats[index].timestamp),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chatId: chats[index].id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          chatProvider.addChat(Chat(
            id: DateTime.now().toString(),
            name: "New Chat",
            lastMessage: "Hello!",
            timestamp: "Now",
          ));
        },
      ),
    );
  }
}
