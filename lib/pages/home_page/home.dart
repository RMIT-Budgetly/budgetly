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
          children: <Widget>[
            Card(
              color: const Color(0x943066BE),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: navigationBar(),
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
