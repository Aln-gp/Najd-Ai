import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const NajdAIApp());
}

class NajdAIApp extends StatelessWidget {
  const NajdAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نجد AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      ),
      home: const LoginScreen(),
    );
  }
}
