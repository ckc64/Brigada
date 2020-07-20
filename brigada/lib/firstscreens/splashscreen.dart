
import 'package:brigada/loginscreen.dart';
import 'package:brigada/school/schoolhomescreen.dart';
import 'package:flutter/material.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home.dart';
  
  final subTitleHeader = Text('help every schools by volunteering',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontSize: 10.0,
              ),
           );


class SplashScreenFull extends StatefulWidget {
  
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenFull> {

  String email="",uid="",password="";
  bool isLoggedIn=false;
  bool isVolunteer=false;
  String currentLocCity;
  double currentLat,currentLong;

    Future<Null> _function() async {

   

      SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
      if (prefs.getString("email") != null && prefs.getString("password") !=null 
      && prefs.getString("uid") !=null) {

        email = prefs.getString("email");
        uid = prefs.getString("uid");
        password = prefs.getString("password");

       Firestore.instance
       .collection("accounts")
       .document(uid).get().then((doc){
          if(doc['userType'] == "VOLUNTEER"){
            if(!mounted)return;
           setState(() {
             isVolunteer = true;
           });
          }else{
            setState(() {
              isVolunteer = false;
            });
            
          }
       });
        
        print("$email,$uid,$password");
        
        setState(() {
              isLoggedIn = true;
        });
      }else{
        setState(() {
          isLoggedIn = false; 
        });
      } 
    });
  }

  
  getCurrentCityLocation() async{
Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     List<Placemark> placemarks = 
     await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
     Placemark placemark = placemarks[0];
    String currentCity = "${placemark.locality}";
    if(mounted){
    setState(() {
      currentLocCity = currentCity;
      currentLat = position.longitude;
      currentLong = position.longitude;
    });
    }
  }

  @override
  void initState() {
  getCurrentCityLocation();
 _function();
    super.initState();
    Future.delayed(Duration(
      seconds: 4
      ),(){


      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  isLoggedIn ? isVolunteer ? Home(currentLat: currentLat,
    currentLong: currentLong,
    currentLoc: currentLocCity,
    currentUserID: uid,
    ) : SchoolHomeScreen(currentUserID: uid) : LoginScreen(currentLat: currentLat,currentLoc: currentLocCity,currentLong: currentLong,)));
        
     }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          
            
              Center(
                child: HeaderTitle(textColor: Colors.white, textSize:35.0)
              ),
        
            SizedBox(height: 10.0,),
            Center(
              child: subTitleHeader
            ),
          ],
        ),
    );
  }
}