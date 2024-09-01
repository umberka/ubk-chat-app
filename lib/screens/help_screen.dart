import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Lottie.asset(
              'assets/lottie_animations/help_animation.json',
              height: 200,
              width: 200,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Terms and Privacy Policy'),
              leading: const Icon(Icons.privacy_tip),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Contact Support'),
              leading: const Icon(Icons.contact_support),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
