
// import 'package:brigada/firstscreens/registrationscreens/uploadprofregistrationscreen.dart';
// import 'package:brigada/widgets/preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:brigada/widgets/reusablewidgets.dart';

// class AddressScreenRegistration extends StatefulWidget {
//   @override
//   _AddressScreenRegistrationState createState() => _AddressScreenRegistrationState();
// }

// class _AddressScreenRegistrationState extends State<AddressScreenRegistration> {
//   TextEditingController addrController = new TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(txtTitle: 'Address'),
//         body: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[

//               Center(
//                child: HeaderTitle(
//                  textColor: Colors.deepOrange, 
//                  textSize:50.0)
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15,bottom: 15),
//                   child: subHeaderTitle(
//                     txtTitle: 'Enter your address'
//                   ),
//                 ),

//                     Padding(
//                         padding: EdgeInsets.only(left:25,right: 25),
//                         child:TextFormField(
//                         controller: addrController,
//                         decoration: InputDecoration(
//                           hintText: 'Unit No., Street, Barangay',
//                           border: OutlineInputBorder()
//                         ),
//                       ),
//                      ),
                     
//                       SizedBox(height: 25),
//                       Padding(
//                         padding: EdgeInsets.only(left:25,right:25,bottom:25),
//                         child: wideButton(
//                           buttonText: 'NEXT',
//                           onPressed: (){
//                             if(addrController.text.isEmpty){
//                                  showDialogWarning(context,"Please fill all the fields.");
//                             }else{
//                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadScreenRegistration()));
//                             setAddress(addrController.text);
//                             }
                        
//                           }
//                         )
//                       ),
                     
//               ],
//             ),
  
//     );
//   }
// }