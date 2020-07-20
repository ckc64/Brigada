
import 'package:brigada/school/schoolregistration/schoolregfinalscreen.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:brigada/widgets/reusablewidgets.dart' as prefix0;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSearch extends StatefulWidget {
  @override
  _MapSearchState createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  GoogleMapController mapController;
  TextEditingController searchAddr = TextEditingController();
   TextEditingController searchAddrCity = TextEditingController();
  int iconTapCount = 0;

  @override
  void initState() {
    super.initState();

    getCurrentPosition();
  }

  getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (iconTapCount == 0) {
            showDialogWarning(context,
                "Map Address null .\nPlease tap the search icon first before to proceed");
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolRegistrationFinalScreen()));
            setSchoolAddress(searchAddr.text);
            setCity(searchAddrCity.text);
          }
        },
        child: Center(
          child: Icon(Icons.send),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
                target: LatLng(14.5995124, 120.98421949999998), zoom: 8.0),
          ),
          Positioned(
            top: 50.0,
            left: 20,
            right: 20,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
              
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: TextFormField(

                  decoration: InputDecoration(
                      hintText: "Street, Barangay",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, top: 15),
                    
                      ),
                 controller: searchAddr,
              )
            ),
          ),
             Positioned(
            top:110.0,
            left: 20,
            right: 20,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
              
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: TextFormField(

                  decoration: InputDecoration(
                      hintText: "Enter City",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, top: 15),
                   
                      ),
                 controller: searchAddrCity,
              )
            ),
          ),
                
               Padding(
                 padding: const EdgeInsets.only(top:170,left:18,right:18),
                 child: Container(
                        child: ButtonTheme(
                              minWidth: double.infinity,
                              height: 55,
                              
                              child: FlatButton(
                              
                              shape: RoundedRectangleBorder(
                             
                              borderRadius: new BorderRadius.circular(10.0),
                              
                             
                            ),
                              color: Colors.deepOrange,
                              textColor: Colors.white,
                              splashColor: Colors.deepOrange[900],
                              
                              onPressed: ()=> searchAndNavigate(),
                              child: Text(
                                "SEARCH",
                                style: TextStyle(
                                  fontFamily: 'Montserrat-Regular',
                                  fontSize: 15.0,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        
	                  ),
               )
        ],
      ),
    );
  }

  searchAndNavigate() {
    
    if (searchAddr.text.isEmpty || searchAddrCity.text.isEmpty) {
      showDialogWarning(context, "Please enter your school address");
    } else {
         setState(() {
      iconTapCount += 1;
    });

    String place = searchAddr.text +"," +searchAddrCity.text;
    print(place);
            Geolocator().placemarkFromAddress(place).then((result) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(
                    result[0].position.latitude, result[0].position.longitude),
                zoom: 16.0,tilt: 30.0)));

        // print(result[0].position.latitude);
        // print(result[0].position.longitude);
        setLatitude(result[0].position.latitude);
        setLongitude(result[0].position.longitude);
        setSchoolAddress(searchAddr.text +"," +searchAddrCity.text);
    
      });
    }
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
