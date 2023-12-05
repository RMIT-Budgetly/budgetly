import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        shadowColor: Theme.of(context).colorScheme.shadow,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        // color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[myWallet(), financeStatus()],
        ),
      ),
      bottomNavigationBar: navigationBar(),
    );
  }

  Card financeStatus() {
    return Card(
      color: const Color(0xFF242424),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                financeStatusComponent(
                    const Icon(
                      Icons.arrow_downward,
                      size: 30,
                      color: Color.fromARGB(255, 18, 206, 24),
                    ),
                    'Income',
                    20000),
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 1,
                ),
                financeStatusComponent(
                    const Icon(
                      Icons.arrow_upward,
                      size: 30,
                      color: Colors.red,
                    ),
                    'Outcome',
                    17000),
              ],
            ),
          )),
    );
  }

  Row financeStatusComponent(Icon icon, String title, int value) {
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
                height: 0.12,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              '\$ $value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 0.08,
              ),
            )
          ],
        )
      ],
    );
  }

  Card myWallet() {
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
                  const Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '0đ',
                          style: TextStyle(
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

  NavigationBar navigationBar() {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_today_outlined),
          label: 'Calendar',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle),
          label: 'Add',
        ),
        NavigationDestination(
          icon: Icon(Icons.wallet),
          label: 'Wallet',
        ),
        NavigationDestination(
          icon: Icon(Icons.perm_identity),
          label: 'Profile',
        ),
      ],
    );
  }
}
