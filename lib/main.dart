import 'package:flutter/material.dart';
import 'package:personal_finance/pages/add_expenses_page/add_expenses.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_finance/pages/add_goal/add_goal.dart';
import 'package:personal_finance/pages/user_authentication/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_finance/pages/user_authentication/splash.dart';
import 'firebase_options.dart';
import 'package:personal_finance/pages/home_page/home.dart';
import 'package:personal_finance/pages/weekly_plan/weekly_plan_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance App',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 48, 102, 190),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasData) {
            return HomePage();
          }

          return const AuthScreen();
        },
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/add_expenses': (context) => const AddExpensesPage(),
        '/add_goal': (context) => AddSavingGoalScreen(),
        '/weekly_plan_form': (context) => const WeeklyPlanForm(),
      },
    );
  }
}
