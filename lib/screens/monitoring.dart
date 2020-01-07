import 'package:flutter/material.dart';


class Monitoring extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () => {},
                icon: Icon(Icons.add_to_photos),), title: Text('Pressure')),
          BottomNavigationBarItem(
              icon: IconButton(
                onPressed: () => {},
                icon: Icon(Icons.add_to_photos),), title: Text('Pressure')

          ),
        ],

      ),
      appBar: AppBar(
        title: Text('Monitoring'),
      ),


    );
  }
}