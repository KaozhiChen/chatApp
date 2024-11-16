import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      title: 'Message Board App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Message Board App'),
        ),
        body: const Center(
          child: Text('Message Board App!'),
        ),
      ),
    );
  }
}
