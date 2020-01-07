import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class Excerscises extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text("Exercise 1:  Heel Raises")),
        body: GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 2 / 3,
            children: [
              Column(
                children: <Widget>[
                  Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Image(
                        image: AssetImage(
                          'assets/images/ex1.png',
                        ),
                        height: 270.0,
                        width: double.infinity),
                  ),
                  new ListTile(
                    title: new Text(
                        '- Find a sturdy chair or countertop you can hold onto for support.',
                        style: TextStyle(fontSize: 17)),
                  ),
                  new ListTile(
                    title: new Text(
                        '- Hold onto the chair or counter, and raise yourself up onto your tiptoes, keeping your knees straight and holding your upper body tall.',
                        style: TextStyle(fontSize: 17)),
                  ),
                  new ListTile(
                      title: new Text(
                          '- Lower yourself back to the floor slowly, and repeat.',
                          style: TextStyle(fontSize: 17))),
                  Clock(),
                ],
              ),
            ]));
  }
}

int _start = 360;
int _current = 360;

class Clock extends StatefulWidget {
  const Clock({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ClockState createState() => new _ClockState();
}

class _ClockState extends State<Clock> {
  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  Widget build(BuildContext context) {
    return new Container(
      width: 150,
      height: 40,
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          startTimer();
        },
        color: Colors.blue,
        child: Text("$_current"),
      ),
    );
  }
}
