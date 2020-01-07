import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/hospital.dart';

class Hospital112 extends StatelessWidget {
  final List<Hospitals> _allHospitals = Hospitals.allHospitals();

  Hospital112();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Hospitals",
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        body: new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: getHomePageBody(context)));
  }

  getHomePageBody(BuildContext context) {
    return ListView.builder(
      itemCount: _allHospitals.length,
      itemBuilder: _getItemUI,
      padding: EdgeInsets.all(0.0),
    );
  }

  // First Task
/* Widget _getItemUI(BuildContext context, int index) {
   return new Text(_allCities[index].name);
 }*/

  Widget _getItemUI(BuildContext context, int index) {
    return new
    Card(
        child: new Column(


          children: [ new ListTile(
            leading: new Image.asset(
              "assets/" + _allHospitals[index].image,
              fit: BoxFit.cover,
              width: 100,
        ),

            title: new Text(
              _allHospitals[index].name,
              style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            subtitle: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_allHospitals[index].address,
                      style: new TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.normal)),
                  new Text('Hours: ${_allHospitals[index].hours}',
                      style: new TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.normal)),

                ]
            ),



          ),
            Container(
                width: double.infinity,
                color: Color.fromRGBO(255, 0, 127, 1),

    child:
                FlatButton(
                    onPressed: () =>  _launchCaller()  ,
    child: Text("Contact now", style: new TextStyle(
                      fontSize: 20.0, color: Colors.white
                    ))
                )
            ) ]
          ,


        )
    );
  }
}
_launchCaller() async {
  const url = "tel:2038512577";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

