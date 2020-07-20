import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firstscreens/splashscreen.dart';


void main() {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  runApp(MyApp());
} 



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
          debugShowCheckedModeBanner: false,
          title: 'Brigada',
      theme: ThemeData(
        primaryColor:   Color(0xFFFF4700),
        
      ),
        // initialRoute: 'splashscreen',
        // routes: {
        //   'splashscreen' :  (context) => SplashScreenFull(),
        //   'home_registration' :  (context) => HomeRegistration(),
        //   'name_registration' :  (context) => NameRegistration(),
        //   'addr_registration' :  (context) => AddressScreenRegistration(),
     
        //   'upload_registration' :  (context) => UploadScreenRegistration(),
        //   'registration_complete' : (context) => CompleteRegistration(),
        // },
        home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp> {
//   String email="",uid="",password="";
//   bool isLoggedIn=false;
//   bool isVolunteer=false;
//   String currentLocCity;
//   double currentLat,currentLong;
//   Future<Null> _function() async {

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//    setState(() {
//       if (prefs.getString("email") != null && prefs.getString("password") !=null 
//       && prefs.getString("uid") !=null) {

//         email = prefs.getString("email");
//         uid = prefs.getString("uid");
//         password = prefs.getString("password");

//        Firestore.instance
//        .collection("accounts")
//        .document(uid).get().then((doc){
//           if(doc['userType'] == "VOLUNTEER"){
//            setState(() {
//              isVolunteer = true;
//            });
//           }else{
//             isVolunteer = false;
//           }
//        });
        
//         print("$email,$uid,$password");
        
//         setState(() {
//               isLoggedIn = true;
//         });
//       }else{
//         setState(() {
//           isLoggedIn = false; 
//         });
//       } 
//     });
//   }

  
//   getCurrentCityLocation() async{
// Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//      List<Placemark> placemarks = 
//      await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
//      Placemark placemark = placemarks[0];
//     String currentCity = "${placemark.locality}";
 
//     setState(() {
//       currentLocCity = currentCity+" "+"City";
//       currentLat = position.longitude;
//       currentLong = position.longitude;
//     });
//   }


  @override
  void initState() { 
    //  getCurrentCityLocation();
    //  _function();
   
    super.initState();
   
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SplashScreenFull()
    
    // isLoggedIn ? isVolunteer ? Home(currentLat: currentLat,
    // currentLong: currentLong,
    // currentLoc: currentLocCity,
    // currentUserID: uid,
    // ) : AddRequestPage(currentUserID: uid,) : SplashScreenFull() 
    //isLoggedIn ? Home() : SplashScreenFull() 
    
    

    );
  }


}


