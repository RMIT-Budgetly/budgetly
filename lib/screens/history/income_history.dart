import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/services/income_api.dart';
import 'package:personal_finance/models/category.dart';
import 'package:personal_finance/models/expense.dart';

class IncomeHistory extends StatefulWidget {
  const IncomeHistory({Key? key}) : super(key: key);

  @override
  State<IncomeHistory> createState() => _IncomeHistoryState();
}

class _IncomeHistoryState extends State<IncomeHistory> {
  bool viewAll = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: getAllIncomes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(60),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }
        List<Expense> incomes = snapshot.data!;
        if (!viewAll) {
          incomes = snapshot.data!.where((expense) {
            DateTime currentDate = DateTime.now();
            DateTime expenseDate = expense.selectedDate!;
            return currentDate.year == expenseDate.year &&
                currentDate.month == expenseDate.month;
          }).toList();
        }
        incomes.sort((a, b) => b.selectedDate!.compareTo(a.selectedDate!));

        return Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFE0E0E0),
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    viewAll = !viewAll;
                  });
                },
                child: Text(
                  viewAll
                      ? 'View ${DateFormat.MMMM().format(DateTime.now())}'
                      : 'View All',
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              child: SizedBox(
                height: 600,
                child: ListView.builder(
                  itemCount: incomes.length,
                  itemBuilder: (context, index) {
                    Expense income = incomes[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        income.description!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    IconTheme(
                                      data: IconThemeData(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: categories
                                          .where((element) =>
                                              element.name == income.category)
                                          .first
                                          .getIcon(),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  "+\$${income.amount}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(income.selectedDate!),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
