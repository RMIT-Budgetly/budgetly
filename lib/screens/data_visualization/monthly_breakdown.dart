import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/utils/color_utils.dart';
import 'package:personal_finance/utils/date_formatter.dart';

class DataVisualizationPage extends StatefulWidget {
  const DataVisualizationPage({super.key});

  @override
  State<DataVisualizationPage> createState() => _DataVisualizationPageState();
}

class _DataVisualizationPageState extends State<DataVisualizationPage>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;

  late Map<String, Color> categoryColors;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this); // 'this' refers to TickerProviderStateMixin
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Stream<Map<String, double>> streamExpenses(bool isCurrentMonth) {
    var now = DateTime.now();
    var firstDay;
    var lastDay;

    if (isCurrentMonth) {
      firstDay = DateTime(now.year, now.month, 1);
      lastDay = DateTime(now.year, now.month + 1, 0);
    } else {
      firstDay = DateTime(now.year, now.month - 1, 1);
      lastDay = DateTime(now.year, now.month, 0);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('expenses')
        .where('selectedDate', isGreaterThanOrEqualTo: firstDay)
        .where('selectedDate', isLessThanOrEqualTo: lastDay)
        .snapshots()
        .map((snapshot) => snapshot.docs.take(snapshot.docs.length))
        .asyncMap((docs) async {
      Map<String, double> expenseDatas = {};

      for (var doc in docs) {
        DocumentSnapshot document = await doc.reference.get();

        if (document.exists) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          if (expenseDatas.containsKey(data['category'])) {
            expenseDatas[data['category']] =
                expenseDatas[data['category']]! + data['amount'];
          } else {
            expenseDatas[data['category']] = data['amount'];
          }
        }
      }

      return expenseDatas;
    });
  }

  // Get all values from the map and sum them up
  double getTotal(Map<dynamic, double> expenseData) {
    double total = 0;
    expenseData.forEach((key, value) {
      total += value;
    });
    return total;
  }

  // Create a list of colors for the chart
  final List<Color> chartColors = [
    const Color(0xFF6263fb),
    const Color(0xFFbb4fe4),
    const Color(0xFFf037c4),
    const Color(0xFFff2e9e),
    const Color(0xFFff4377),
    const Color(0xFFff6552),
    const Color(0xFFff872f),
    const Color (0xffffa600),
  ];

  int colorIndex = 0;
  Color getNextColor() {
    colorIndex++;
    if (colorIndex > chartColors.length) {
      colorIndex = 1;
    }
    return chartColors[colorIndex - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Visualization'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Last Month'),
            Tab(text: 'This Month'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildExpenseView(false), // Last month
          buildExpenseView(true), // Current month
        ],
      ),
    );
  }

  Widget buildExpenseView(bool isCurrentMonth) {
    // Formatting date for display
    var now = DateTime.now();
    var displayedMonth =
        isCurrentMonth ? now : DateTime(now.year, now.month - 1);
    var monthFormatter = DateFormat('MMMM yyyy');

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              isCurrentMonth ? 'Expenses This Month' : 'Expenses Last Month',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              monthFormatter.format(displayedMonth),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            StreamBuilder<Map<String, double>>(
              stream: streamExpenses(isCurrentMonth),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                } else {
                  final expenseData = snapshot.data!;
                  final total = getTotal(expenseData);

                  return Column(
                    children: [
                      SizedBox(
                        height: 200, // Adjust size as needed
                        child: displayPieChart(total, expenseData),
                      ),
                      ...expenseData.entries
                          .map((e) => expenseItem(e.key, e.value))
                          .toList(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget displayPieChart(double total, Map<String, double> expenseData) {
    // Constructing the categoryColors map
    categoryColors = Map.fromIterable(
      expenseData.keys,
      key: (item) => item,
      value: (item) => getNextColor(),
    );

    return PieChart(
      PieChartData(
        sections: expenseData.entries.map((entry) {
          final category = entry.key;
          final amount = entry.value;
          final color = categoryColors[category]!;
          final percentage = (amount / total) * 100;

          return PieChartSectionData(
            color: color,
            value: amount,
            title: '${percentage.toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }

  Widget expenseItem(String category, double amount) {
    final textColor = Colors.white;
    final categoryColor = categoryColors[category] ?? Colors.grey;

    return Container(
      height: 60,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: categoryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
