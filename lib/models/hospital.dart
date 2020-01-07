class Hospitals {
  //--- Name Of City
  final String name;
  //-- image
  final String image;
  //--- population
  final String address;
  //--- country
  final String hours;
  Hospitals({this.name,this.hours,this.address,this.image});

  static List<Hospitals> allHospitals()
  {
    var lstOfHospitals = new List<Hospitals>();
    lstOfHospitals.add(new Hospitals(name:"Dar El Fouad Hospital",hours: "Open 24 hours",address: "26th of July Corrido. First 6th of October, Giza Governorate.",image: "images/darelfouad.jpg"));
    lstOfHospitals.add(new Hospitals(name:"Saudi German Hospital Cairo",hours: "Open 24 hours",address: "Joseph Tito St, Huckstep, El Nozha, Cairo Governorate.",image: "images/saudigerman.jpg"));
    lstOfHospitals.add(new Hospitals(name:"El Kasr El Ainy Hospital",hours: "Open 24 hours",address: "27 Nafezet Sheem El Shafaey St Kasr Al Ainy, Cairo Governorate.",image: "images/kasrelainy.jpg"));

    return lstOfHospitals;
  }
}
