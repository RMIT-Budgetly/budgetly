import 'package:flutter/material.dart';
import 'package:personal_finance/pages/user_authentication/signin_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance App',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 48, 102, 190),),
      ),
      home: const SignInScreen(),
    );
  }
}