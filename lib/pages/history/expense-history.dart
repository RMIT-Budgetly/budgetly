import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/api/expense-api.dart';
import 'package:personal_finance/models/category.dart';
import 'package:personal_finance/models/expense.dart';

class ExpenseHistory extends StatefulWidget {
  const ExpenseHistory({Key? key}) : super(key: key);

  @override
  State<ExpenseHistory> createState() => _ExpenseHistoryState();
}

class _ExpenseHistoryState extends State<ExpenseHistory> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: getAllExpenses(),
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

        List<Expense> expenses = snapshot.data!;

        return SingleChildScrollView(
          child: SizedBox(
            height: 700,
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                Expense expense = expenses[index];
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
                                    expense.description!,
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
                                          element.name == expense.category)
                                      .first
                                      .getIcon(),
                                )
                              ],
                            ),
                            const Spacer(),
                            Text(
                              "-\$${expense.amount}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            DateFormat('dd/MM/yyyy')
                                .format(expense.selectedDate!),
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
        );
      },
    );
  }
}
