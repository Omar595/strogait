import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xFF07489C);

class Model extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ESP32"),
          backgroundColor: PrimaryColor,
        ),
        body: Center(
            child: Container(
                child: Image.asset(
          'assets/images/model.png',
          fit: BoxFit.fill,
        ))));
  }
}
