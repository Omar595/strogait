import 'package:flutter/material.dart';
import '../components/drawer.dart';

const PrimaryColor = const Color(0xFF07489C);

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: PrimaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: Stack(
            children: <Widget>[
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.6 / 3,
                children: <Widget>[
                  Container(
                      height: 150,
                      margin: EdgeInsets.all(2),
                      child: GestureDetector(
                        child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/images/chating.png',
                              fit: BoxFit.fill,
                            )),
                        onTap: () => Navigator.pushNamed(context, '/Chatting'),
                      )),
                  Container(
                    height: 150,
                    margin: EdgeInsets.all(2),
                    child: GestureDetector(
                      child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            'assets/images/monitoring.png',
                            fit: BoxFit.fill,
                          )),
                      onTap: () => Navigator.pushNamed(context, '/Monitoring'),
                    ),
                  ),
                  Container(
                      height: 150,
                      margin: EdgeInsets.all(2),
                      child: GestureDetector(
                        child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'assets/images/analysis.png',
                              fit: BoxFit.fill,
                            )),
                      )),
                  Container(
                    height: 150,
                    margin: EdgeInsets.all(2),
                    child: GestureDetector(
                      child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            'assets/images/exercises.png',
                            fit: BoxFit.fill,
                          )),
                      onTap: () => Navigator.pushNamed(context, '/Exercises'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new Align(
                    alignment: FractionalOffset.bottomRight,
                    child: SizedBox(
                      width: 75,
                      height: 75,
                      child: FloatingActionButton(
                          child: Image.asset(
                            'assets/images/ambulance.png',
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/hospitalfinal');
                          }),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}