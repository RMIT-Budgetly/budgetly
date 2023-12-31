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

  @override
  void dispose() {
    _incomeMoneyNotifier.dispose();
    _outcomeMoneyNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = 0;
    setState(() {
      totalAmount = _incomeMoneyNotifier.value - _outcomeMoneyNotifier.value;
    });
    print(totalAmount);
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
              myWallet(amount: totalAmount),
              // financeStatus(),
              FinancialStatusCard(
                incomeMoneyNotifier: _incomeMoneyNotifier,
                outcomeMoneyNotifier: _outcomeMoneyNotifier,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // SizedBox(height: 10.0),
                    Text(
                      'We can support you in managing your budget daily',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF818181),
                        fontSize: 10,
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
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'We can support you in managing your budget daily',
                      style: TextStyle(
                        color: Color(0xFF818181),
                        fontSize: 10,
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

  Card myWallet({required double amount}) {
    return Card(
      color: const Color(0x943066BE),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
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
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'view ',
                          style: TextStyle(
                            color: Color(0xFF030303),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  )
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
                      shape: const OvalBorder(),
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
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '$amount\$',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    ],
                  ))
                ],
              )
            ],
          )),
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
  });
  ValueNotifier<double> incomeMoneyNotifier;
  ValueNotifier<double> outcomeMoneyNotifier;

  @override
  State<FinancialStatusCard> createState() => _FinancialStatusCardState();
}

class _FinancialStatusCardState extends State<FinancialStatusCard> {
  Future<List<Expense>> fetchExpenses() async {
    List<Expense> expenses = await getAllIncomes().first;
    return expenses;
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
                child: StreamBuilder<List<Expense>>(
                  stream: getAllIncomes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
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
                      List<Expense> expenses = snapshot.data!;
                      double totalIncome = 0.0;

                      for (Expense expense in expenses) {
                        if (expense.amount! > 0) {
                          totalIncome += expense.amount!;
                        }
                      }

                      widget.incomeMoneyNotifier.value = totalIncome;

                      return financeStatusComponent(
                        const Icon(
                          Icons.arrow_downward,
                          size: 30,
                          color: Color.fromARGB(255, 18, 206, 24),
                        ),
                        "Income",
                        widget.incomeMoneyNotifier.value,
                      );
                    }
                  },
                ),
              ),
              const VerticalDivider(
                color: Colors.white,
                thickness: 1,
              ),
              Expanded(
                child: StreamBuilder<List<Expense>>(
                  stream: Rx.combineLatest2(
                    getAllExpenses(),
                    getAllDebts(),
                    (List<Expense> expenses, List<Expense> debts) {
                      double totalAmount = expenses.fold(
                        0,
                        (previousValue, element) =>
                            previousValue + element.amount!,
                      );
                      totalAmount += debts.fold(
                        0,
                        (previousValue, element) =>
                            previousValue + element.amount!,
                      );
                      return [Expense(amount: totalAmount)];
                    },
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('No data available');
                    } else {
                      List<Expense> totalAmountExpense = snapshot.data!;
                      double? totalAmount = totalAmountExpense.isNotEmpty
                          ? totalAmountExpense.first.amount
                          : 0;
                      widget.outcomeMoneyNotifier.value = totalAmount!;
                      return financeStatusComponent(
                        const Icon(
                          Icons.arrow_upward,
                          size: 30,
                          color: Colors.red,
                        ),
                        "Outcome",
                        widget.outcomeMoneyNotifier.value,
                      );
                    }
                  },
                ),
              ),

              // financeStatusComponent(
              //   const Icon(
              //     Icons.arrow_upward,
              //     size: 30,
              //     color: Colors.red,
              //   ),
              //   'Outcome',
              //   _outcomeMoneyNotifier.value,
              // ),
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
