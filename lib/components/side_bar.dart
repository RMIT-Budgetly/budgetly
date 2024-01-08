import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:personal_finance/services/user_service.dart';
import 'package:personal_finance/models/user_model.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final TextStyle listItemStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserDetail>(
      stream: streamSectionItems(),
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
                    Theme.of(context).primaryColor, // Set your desired color
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
          UserDetail userDetail = snapshot.data!;
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                    currentAccountPicture: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            userDetail.image_url,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://img.freepik.com/premium-photo/green-plant-with-dark-background_889227-5623.jpg'),
                          fit: BoxFit.cover),
                      color: Color(0x7F0000FF),
                    ),
                    accountName: Text(
                      userDetail.username,
                      style:  const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    accountEmail: Text(
                      userDetail.email,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                      )
                    ),
                ListTile(
                  leading: const Icon(Icons.accessibility_outlined),
                  title: const Text('About Us'),
                  titleTextStyle: listItemStyle,
                  onTap: () {
                    // Navigator.pop(context);
                    print('About Us');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.tips_and_updates_rounded),
                  title: const Text('Tips'),
                  titleTextStyle: listItemStyle,
                  onTap: () {
                    // Navigator.pop(context);
                    print('Tips');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.pie_chart_outline_rounded),
                  title: const Text('Chart'),
                  titleTextStyle: listItemStyle,
                  onTap: () {
                    // Navigator.pop(context);
                    Navigator.pushNamed(context, '/data_visualization');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Setting'),
                  titleTextStyle: listItemStyle,
                  onTap: () {
                    // Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app_rounded),
                  title: const Text('Logout'),
                  titleTextStyle: listItemStyle,
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    GoogleSignIn().signOut();
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
