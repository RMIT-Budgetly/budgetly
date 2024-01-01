import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:personal_finance/api/debt-api.dart';
import 'package:personal_finance/api/expense-api.dart';
import 'package:personal_finance/api/income-api.dart';
import 'package:personal_finance/components/side_bar.dart';
import 'package:personal_finance/components/tracking_selection.dart';
import 'package:personal_finance/models/expense.dart';
import 'package:personal_finance/pages/home_page/display_tracking.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<double> _incomeMoneyNotifier = ValueNotifier<double>(0.0);
  final ValueNotifier<double> _outcomeMoneyNotifier =
      ValueNotifier<double>(0.0);
  static double totalMoney = 0;

  @override
  void dispose() {
    _incomeMoneyNotifier.dispose();
    _outcomeMoneyNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    void onTotalAmountChanged(double amount) {
      setState(() {
        totalAmount = amount;
      });
    }

    var iconMoney = Container(
        width: 40,
        height: 40,
        decoration: const ShapeDecoration(
          color: Color(0x7F0000FF),
          shape: OvalBorder(),
        ),
        padding: const EdgeInsets.all(6.0),
        child: SvgPicture.asset(
          'assets/icons/icon_money.svg',
        ));

    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shadowColor: Theme.of(context).colorScheme.shadow,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {},
        // ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          // color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              myWallet(
                  amount: totalAmount,
                  incomeMoneyNotifier: _incomeMoneyNotifier,
                  outcomeMoneyNotifier: _outcomeMoneyNotifier),
              // financeStatus(),
              FinancialStatusCard(
                incomeMoneyNotifier: _incomeMoneyNotifier,
                outcomeMoneyNotifier: _outcomeMoneyNotifier,
                onTotalAmountChanged: onTotalAmountChanged,
              ),
              introductionCard(iconMoney, context),
              callToAction(iconMoney, context),
              // display the goal of user
              const DisplayTracking(
                collectionName: "goals",
                title: "Saving Goal",
              ),
              const DisplayTracking(collectionName: "plans", title: "Plan")
            ],
          ),
        ),
      ),
      bottomNavigationBar: navigationBar(context),
    );
  }

  InkWell callToAction(Container iconMoney, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/weekly_plan_form');
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.only(right: 6.0),
                  child: iconMoney),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your monthly plan',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF030303),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // SizedBox(height: 10.0),
                    Text(
                      'We can support you in managing your budget daily',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF818181),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => {},
                child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.arrow_forward_ios_rounded)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell introductionCard(Container iconMoney, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/add_goal');
      },
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a Saving goal',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF030303),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'We can support you in achieve your goal',
                      style: TextStyle(
                        color: Color(0xFF818181),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.only(left: 6.0),
                  child: iconMoney),
            ],
          ),
        ),
      ),
    );
  }

  Card myWallet({
    required double amount,
    required ValueNotifier<double> incomeMoneyNotifier,
    required ValueNotifier<double> outcomeMoneyNotifier,
  }) {
    return Card(
      color: const Color(0x943066BE),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ValueListenableBuilder<double>(
          valueListenable: incomeMoneyNotifier,
          builder: (context, incomeValue, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Text(
                      'My Wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.white,
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(
                        Icons.wallet,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ValueListenableBuilder<double>(
                              valueListenable: outcomeMoneyNotifier,
                              builder: (context, outcomeValue, _) {
                                double totalAmount = incomeValue - outcomeValue;
                                totalMoney = totalAmount;
                                return Text(
                                  '$totalAmount\$',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  NavigationBar navigationBar(BuildContext context) {
    return NavigationBar(
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const NavigationDestination(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Calendar',
        ),
        NavigationDestination(
          icon: IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              // Navigator.pushNamed(context, '/add_expenses');
              showDialog(
                  context: context,
                  builder: (context) {
                    return const TrackingSelection();
                  });
            },
          ),
          label: 'Add',
        ),
        const NavigationDestination(
          icon: Icon(Icons.wallet),
          label: 'Wallet',
        ),
        const NavigationDestination(
          icon: Icon(Icons.perm_identity),
          label: 'Profile',
        ),
      ],
    );
  }
}

class FinancialStatusCard extends StatefulWidget {
  FinancialStatusCard({
    super.key,
    required this.incomeMoneyNotifier,
    required this.outcomeMoneyNotifier,
    required this.onTotalAmountChanged,
  });
  ValueNotifier<double> incomeMoneyNotifier;
  ValueNotifier<double> outcomeMoneyNotifier;
  Function(double) onTotalAmountChanged = (double amount) {};

  @override
  State<FinancialStatusCard> createState() => _FinancialStatusCardState();
}

class _FinancialStatusCardState extends State<FinancialStatusCard> {
  late Stream<List<Expense>> _expensesStream;

  @override
  void initState() {
    super.initState();
    _expensesStream = getAllIncomes();
    _updateValues();
  }

  void _updateValues() {
    _expensesStream.listen((expenses) {
      double totalIncome = 0.0;

      for (Expense expense in expenses) {
        if (expense.amount! > 0) {
          totalIncome += expense.amount!;
        }
      }

      widget.incomeMoneyNotifier.value = totalIncome;
      _updateOutcome();
    });
  }

  void _updateOutcome() {
    Rx.combineLatest2(
      getAllExpenses(),
      getAllDebts(),
      (List<Expense> expenses, List<Expense> debts) {
        double totalAmount = expenses.fold<double>(
          0,
          (previousValue, element) => previousValue + element.amount!,
        );
        totalAmount += debts.fold<double>(
          0,
          (previousValue, element) => previousValue + element.amount!,
        );
        return totalAmount;
      },
    ).listen((totalAmount) {
      widget.outcomeMoneyNotifier.value = totalAmount;
      widget
          .onTotalAmountChanged(widget.incomeMoneyNotifier.value - totalAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF242424),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: widget.incomeMoneyNotifier,
                  builder: (context, incomeValue, _) {
                    return financeStatusComponent(
                      const Icon(
                        Icons.arrow_downward,
                        size: 30,
                        color: Color.fromARGB(255, 18, 206, 24),
                      ),
                      "Income",
                      incomeValue,
                    );
                  },
                ),
              ),
              const VerticalDivider(
                color: Colors.white,
                thickness: 1,
              ),
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: widget.outcomeMoneyNotifier,
                  builder: (context, outcomeValue, _) {
                    return financeStatusComponent(
                      const Icon(
                        Icons.arrow_upward,
                        size: 30,
                        color: Colors.red,
                      ),
                      "Outcome",
                      outcomeValue,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row financeStatusComponent(Icon icon, String title, double value) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 8.0),
        Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Color(0xFFF2F2F2),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '\$ $value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        )
      ],
    );
  }
}
