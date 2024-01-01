import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                // backgroundImage: AssetImage('assets/images/bocchi.jpg'),
                child: ClipOval(
                  child: Image.network(
                    'https://cdn.vox-cdn.com/thumbor/PzidjXAPw5kMOXygTMEuhb634MM=/11x17:1898x1056/1200x800/filters:focal(807x387:1113x693)/cdn.vox-cdn.com/uploads/chorus_image/image/72921759/vlcsnap_2023_12_01_10h37m31s394.0.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     stops: [0, 0.6],
                //     colors: [Colors.transparent, Colors.black]),
                image: DecorationImage(
                    image: NetworkImage(
                        'https://img.freepik.com/premium-photo/green-plant-with-dark-background_889227-5623.jpg'),
                    fit: BoxFit.cover),
                color: Color(0x7F0000FF),
              ),
              accountName: const Text('Josh Hutcherson'),
              accountEmail: const Text('joshHutcherson@rmit.edu.vn')),
          ListTile(
            leading: const Icon(Icons.accessibility_outlined),
            title: const Text('About Us'),
            onTap: () {
              // Navigator.pop(context);
              print('About Us');
            },
          ),
          ListTile(
            leading: const Icon(Icons.tips_and_updates_rounded),
            title: const Text('Tips'),
            onTap: () {
              // Navigator.pop(context);
              print('Tips');
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline_rounded),
            title: const Text('Chart'),
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushNamed(context, '/data_visualization');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Setting'),
            onTap: () {
              // Navigator.pop(context);
              print('Setting');
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded),
            title: const Text('Exit'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              GoogleSignIn().signOut();
            },
          ),
        ],
      ),
    );
  }
}
