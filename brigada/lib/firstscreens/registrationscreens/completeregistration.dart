// import 'package:brigada/home.dart';
// import 'package:brigada/widgets/preferences.dart';
// import 'package:brigada/widgets/reusablewidgets.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class CompleteRegistration extends StatefulWidget {
//   @override
//   _CompleteRegistrationState createState() => _CompleteRegistrationState();
// }

// class _CompleteRegistrationState extends State<CompleteRegistration> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(txtTitle: 'Complete'),
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[ 
//             HeaderTitle(textColor: Colors.deepOrange,textSize: 50.0),
//             subHeaderTitle(txtTitle: 'Registration Complete'),
//             SizedBox(height: 20.0),

//                 SizedBox(height: 25),
//                       Padding(
//                         padding: EdgeInsets.only(left:25,right:25,bottom:25),
//                         child: wideButton(
//                           buttonText: 'GET STARTED',
//                           onPressed: (){
//                                FirebaseAuth.instance.currentUser().then((user){
//                                     if(user != null){
//                                        Navigator.pushReplacement(context, 
//                                 MaterialPageRoute(builder: (context)=>Home(currentUserID: user.uid))
//                                 );
//                                 clearPreferences();
//                                     }
//                                });
                               

//                           },
//                         )
//                       ),
//           ],
//         ),
//     );
//   }
// }