import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location_permissions/location_permissions.dart';

import './screens/excercises.dart';
import './screens/monitoring.dart';
import './screens/home.dart';
import './screens/model.dart';
import './screens/hospitalsfinal.dart';

import './providers/finalauth.dart';
import './chat/mainScreen.dart' as user;
import './chatdoctor/mainScreen.dart' as doctor;

void main() {
  runApp(MyApp());
  getPermission();
}

String id;
bool doc;

class MyApp extends StatelessWidget {
  Future<bool> isAuth() async {
    final prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
    doc = prefs.getBool('doctor');

    if (prefs.containsKey('id')) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        "/Excercises": (BuildContext context) => new Excerscises(),
        "/Monitoring": (BuildContext context) => new Monitoring(),
        "/model": (BuildContext context) => new Model(),
        "/hospitalfinal": (BuildContext context) => new Hospital112(),
        "/Chatting": (BuildContext context) =>
            new user.MainScreen(currentUserId: id),
      },
      home: FutureBuilder(
          future: isAuth(),
          builder: (ctx, auth) => auth.data == true
              ? doc
                  ? doctor.MainScreen(
                      currentUserId: id,
                    )
                  : Homepage()
              : AuthScreen()),
    );
  }
}

void getPermission() async {
  PermissionStatus permission =
      await LocationPermissions().requestPermissions();
  print(permission.toString());
}
