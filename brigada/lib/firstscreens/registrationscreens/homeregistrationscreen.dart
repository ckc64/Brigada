// import 'package:brigada/firstscreens/registrationscreens/nameregistrationscreen.dart';
// import 'package:brigada/widgets/preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:brigada/widgets/reusablewidgets.dart';

// class HomeRegistration extends StatefulWidget {
//   @override
//   _HomeRegistrationState createState() => _HomeRegistrationState();
// }

// class _HomeRegistrationState extends State<HomeRegistration> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(
//           children: <Widget>[
//             SizedBox(height: 200.0), 
         
//              Center(
//                child: HeaderTitle(
//                  textColor: Colors.deepOrange, 
//                  textSize:50.0)
//              ),
//              Column(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//                   Padding(
//                         padding: EdgeInsets.only(left:25,right: 25),
//                         child: ButtonTheme(
//                             minWidth: double.infinity,
//                             height: 55,
//                             hoverColor: Colors.deepOrange,
                          
//                             child: FlatButton(
//                             shape: RoundedRectangleBorder(
//                             borderRadius: new BorderRadius.circular(5.0),
//                             side: BorderSide(color: Colors.deepOrange),
//                           ),
//                             color: Colors.transparent,
//                             textColor: Colors.white,
//                             splashColor: Colors.deepOrange,
                            
//                             onPressed: (){
                              
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=>NameRegistration()));
                            
//                             },
//                             child: Text(
//                               'VOLUNTEER',
//                               style: TextStyle(
//                                 fontSize: 15.0,
//                                 color: Colors.deepOrange
//                               ),
//                             ),
//                           ),
//                         )
//                       ),
                      
//                       SizedBox(height: 10),
//                       Padding(
//                         padding: EdgeInsets.only(left:25,right:25,bottom:25),
//                         child: wideButton(
//                           buttonText: 'TEACHER',
//                           onPressed: () {
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=>NameRegistration()));      
//                           }
//                         )
//                       ),
//                ],
//              )
//           ],
//         ),
//     );
//   }
// }