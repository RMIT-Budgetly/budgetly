import 'package:flutter/material.dart';
import 'package:personal_finance/pages/history/expense-history.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var currentView;
  onChangeView(String view) {
    setState(() {
      currentView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (currentView == "Expenses" || currentView == null) {
      content = const ExpenseHistory();
    } else if (currentView == "Incomes") {
      content = const Text("Incomes");
    } else if (currentView == "Debts") {
      content = const Text("Debts");
    } else {
      content = const Text("Expenses");
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('History'),
        backgroundColor: const Color.fromRGBO(244, 246, 246, 100),
      ),
      backgroundColor: const Color.fromARGB(249, 244, 246, 246),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    backgroundColor:
                        (currentView == null || currentView == "Expenses")
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                    foregroundColor:
                        (currentView == null || currentView == "Expenses")
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    onChangeView("Expenses");
                  },
                  child: const Text("Expenses"),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    backgroundColor: (currentView == "Incomes")
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    foregroundColor: (currentView == "Incomes")
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    onChangeView("Incomes");
                  },
                  child: const Text("Incomes"),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    backgroundColor: (currentView == "Debts")
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    foregroundColor: (currentView == "Debts")
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    onChangeView("Debts");
                  },
                  child: const Text("Debts"),
                ),
              ],
            ),
            content,
          ],
        ),
      ),
    );
  }
}
