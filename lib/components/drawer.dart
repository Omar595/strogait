import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        children: <Widget>[
          DrawerHeader(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 100,
              height: 50,
              child: Image.asset(
                'assets/images/profile.png',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text(
              'Medical Profile',
              style: TextStyle(color: Colors.blueGrey, fontSize: 20),
            ),
            // onTap: () => Navigator.of(context)
            //     .pushReplacementNamed(PurchaseRoute.routeName),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.thumbs_up_down),
            title: const Text(
              'Feedback',
              style: TextStyle(color: Colors.blueGrey, fontSize: 20),
            ),
            // onTap: () async {
            //   final prefs = await SharedPreferences.getInstance();
            //   prefs.clear();
            //   Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            // },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.live_help),
            title: const Text(
              'About us',
              style: TextStyle(color: Colors.blueGrey, fontSize: 20),
            ),
            // onTap: () => Navigator.of(context)
            //     .pushReplacementNamed(TodayPrices.routeName),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              'Log Out',
              style: TextStyle(color: Colors.blueGrey, fontSize: 20),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('id');
              exit(0);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
