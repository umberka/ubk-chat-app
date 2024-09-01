import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FirebaseAuth auth = FirebaseAuth.instance;

  void sessionControl() async {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint("User account is closed.");

        if (!mounted) return;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        debugPrint("User account is openand email is ${user.email}");
        if (!mounted) return;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      sessionControl();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_screens/splash_screen.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
      /*ListView(
        children: [
          Lottie.asset(
            'assets/lottie_animations/Splash_Animation.json',
            fit: BoxFit.fill,
            width: 200,
            height: 200,
          ),
        ],
      ),*/
    );
  }
}
