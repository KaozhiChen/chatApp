import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homework4/theme/colors.dart';
import 'pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message Board App',
      theme: ThemeData(primaryColor: primary),
      home: const SplashPage(),
    );
  }
}
