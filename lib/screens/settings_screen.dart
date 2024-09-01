import 'package:chat_app/screens/account_screen.dart';
import 'package:chat_app/screens/help_screen.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utilities/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<Map<String, dynamic>> settings = [
    {
      'icon': Icons.account_box,
      'title': 'Account',
    },
    {
      'icon': Icons.help,
      'title': 'Help',
    },
    {
      'icon': Icons.logout,
      'title': 'Logout',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('Settings'),
        ),
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/settings_image.png',
            width: 150,
            height: 150,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              physics: const BouncingScrollPhysics(),
              itemCount: settings.length,
              itemBuilder: (context, index) {
                final item = settings[index];
                return ListTile(
                  leading: Icon(
                    item['icon'],
                    color: black,
                  ),
                  title: Text(
                    item['title'],
                    style: const TextStyle(color: black),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: black,
                  ),
                  onTap: () {
                    switch (item['title']) {
                      case 'Account':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccountScreen()));
                      case 'Help':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HelpScreen()));
                      case 'Logout':
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
