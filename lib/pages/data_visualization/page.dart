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

class _DataVisualizationPageState extends State<DataVisualizationPage> {
  final user = FirebaseAuth.instance.currentUser;

  late Map<String, Color> categoryColors;

  Stream<Map<String, double>> streamExpenses() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('expenses')
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

  // Map model: Category: Expense
  final Map<String, double> testData = {
    'food': 215,
    'transport': 60,
    'entertainment': 147,
    'others': 65,
  };

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
    const Color(0xFF4F42FF),
    const Color(0xFFEE00C7),
    const Color(0xFFFF1F88),
    const Color(0xFFFF7D57),
    const Color(0xFFFFC146),
    const Color(0xFFF9F871),
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
      ),
      body: Container(
        // color: Colors.yellow[100],
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Total Expenses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Current date
                Text(
                  // Get current date but with month in form of text (April for example)
                  // Also add the postfix for days (st, nd, rd, th)
                  // Example: 1st January 2024
                  '${DateTime.now().day}${getDayOfMonthSuffix(DateTime.now().day)} ${DateFormat.MMMM().format(DateTime.now())} ${DateTime.now().year}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            // SizedBox.square(
            //   dimension: MediaQuery.of(context).size.width * 0.8,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: displayPieChart(total, testData),
            //   ),
            // ),
            // SingleChildScrollView(
            //   child: Column(
            //       children: testData.entries
            //           .map((e) => Container(
            //                 margin: const EdgeInsets.symmetric(vertical: 6.0),
            //                 child: expenseItem(e.key, e.value),
            //               ))
            //           .toList()),
            // ),
            StreamBuilder<Map<String, double>>(
              stream: streamExpenses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    // Loading data process
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, // Set the stroke width
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context)
                                .primaryColor, // Set your desired color
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No data available');
                } else {
                  // Display your UI using the fetched data
                  final Map<String, double> expenseData = snapshot.data!;
                  double total = getTotal(expenseData);
                  categoryColors = expenseData.entries
                      .map((e) => MapEntry(e.key, getNextColor()))
                      .fold<Map<String, Color>>({}, (prev, element) {
                    prev[element.key] = element.value;
                    return prev;
                  });

                  return Column(
                    children: [
                      SizedBox.square(
                        dimension: MediaQuery.of(context).size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: displayPieChart(total, expenseData),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                            children: expenseData.entries
                                .map((e) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6.0),
                                      child: expenseItem(e.key, e.value),
                                    ))
                                .toList()),
                      ),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget displayPieChart(double total, Map<String, double> expenseData) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Spent',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        PieChart(
          swapAnimationDuration: const Duration(milliseconds: 500),
          swapAnimationCurve: Curves.easeInOut,
          PieChartData(
            sections: expenseData.entries
                .map((e) => PieChartSectionData(
                      color: categoryColors[e.key],
                      value: e.value / total,
                      title: '${((e.value / total) * 100).toStringAsFixed(0)}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget expenseItem(String category, double amount) {
    const Color textColor = Colors.white;
    return Container(
      height: 60,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              darkenColorHSL(categoryColors[category]!),
              lightenColorHSL(categoryColors[category]!),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: categoryColors[category]!.withAlpha(150),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: const TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
