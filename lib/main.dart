// Default imports
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Pages
import 'package:personal_finance/pages/add_expense/add_expense.dart';
import 'package:personal_finance/pages/add_goal/add_goal.dart';
import 'package:personal_finance/pages/goals/goal.dart';
import 'package:personal_finance/pages/data_visualization/chart.dart';
import 'package:personal_finance/pages/history/history.dart';
import 'package:personal_finance/pages/user_authentication/auth_screen.dart';
import 'package:personal_finance/pages/user_authentication/splash.dart';
import 'package:personal_finance/pages/weekly_plan/view_plan.dart';
import 'package:personal_finance/pages/home_page/home.dart';
import 'package:personal_finance/pages/weekly_plan/weekly_plan_form.dart';

// Utilities
import 'package:personal_finance/utils/app_theme.dart';

void main() async {
  // Ensure widgets are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(const MyApp());
}

/// MyApp is the root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budgetly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // TODO: Implement dark mode
      home: _buildHome(),
      // Define the routes for navigation
      routes: {
        '/home': (context) => const HomePage(),
        '/add_expenses': (context) => const AddExpensesPage(),
        '/add_goal': (context) => AddSavingGoalScreen(),
        '/weekly_plan_form': (context) => const WeeklyPlanForm(),
        '/goals': (context) => const Goal(),
        '/plans': (context) => const ViewPlan(),
        '/data_visualization': (context) => const DataVisualizationPage(),
        '/history': (context) => const History(),
      },
    );
  }

  /// Builds the home widget based on authentication state.
  Widget _buildHome() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const AuthScreen();
      },
    );
  }
}
