// import 'package:brigada/firstscreens/registrationscreens/addressregistrationscreen.dart';
// import 'package:brigada/widgets/preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:brigada/widgets/reusablewidgets.dart';

// class NameRegistration extends StatefulWidget {
  
//   @override
//   _NameRegistrationState createState() => _NameRegistrationState();
// }


// class _NameRegistrationState extends State<NameRegistration> {

//   TextEditingController fnameController = new TextEditingController();
//   TextEditingController lnameController = new TextEditingController();
//    bool isTeacher = false;
  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(txtTitle: 'Name'),
//         body: Stack(
//           children: <Widget>[
            
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[

//               Center(
//                child: HeaderTitle(
//                  textColor: Colors.deepOrange, 
//                  textSize:50.0)
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15,bottom: 15),
//                   child: subHeaderTitle(
//                     txtTitle: 'Enter your name'
//                   ),
//                 ),
               
//                   Container(
//                     child: Padding(
//                       padding: EdgeInsets.only(left:25, right: 25),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                         Flexible(
//                             child: TextFormField(
//                             controller: fnameController,
//                             decoration: InputDecoration(
//                             hintText: 'First Name'
//                           ),
//                       ),
//                         ),
//                         SizedBox(width:30.0),
//                         Flexible(
//                             child: TextFormField(
//                             controller: lnameController,
//                             decoration: InputDecoration(
//                             hintText: 'Lastname'
//                           ),
//                       ),
//                         ),
//                         ],
//                       ),
//                     ),
//                   ),
                    
//                       SizedBox(height: 25),
//                       Padding(
//                         padding: EdgeInsets.only(left:25,right:25,bottom:25),
//                         child: wideButton(
//                           buttonText: 'NEXT',
//                           onPressed: (){
                           

//                             if(fnameController.text.isEmpty || lnameController.text.isEmpty){
//                                 showDialogWarning(context,"Please fill all the fields.");
//                             }else{
//                                     setFirstName(fnameController.text);
//                                     setLastName(lnameController.text);
                                 
//                                       Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressScreenRegistration()));
                      
//                             }                  
//                           }
//                       )
//                   )
//               ],
//             ),
//           ],
//         ),
//     );
//   }
// }