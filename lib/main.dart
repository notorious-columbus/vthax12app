import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart'; // Import Firebase App Check
import 'package:flutter/material.dart';
import 'task_page.dart';
import 'social_feed_page.dart'; // Ensure this file exists

Future<void> initializeFirebaseAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        AndroidProvider.playIntegrity, // Use Play Integrity for Android
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeFirebaseAppCheck();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PageView Example',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          //scaffoldBackgroundColor: const Color.fromARGB(255, 74, 12, 175)),
          scaffoldBackgroundColor: const Color.fromARGB(255, 252, 235, 159)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          TaskPage(),
          SocialFeedPage(),
        ],
      ),
    );
  }
}
