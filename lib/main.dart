import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeMessage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      /*StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          /*
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          */
          if (snapshot.hasData) {
            return const ChatScreen();
          }

          return const LoginPage();
        },
      )*/
    );
  }
}
