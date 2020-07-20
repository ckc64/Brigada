
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:brigada/firstscreens/registrationscreens/completeregistration.dart';
// import 'package:brigada/widgets/preferences.dart';
// import 'package:brigada/widgets/reusablewidgets.dart';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as Im;
// import 'package:image_picker/image_picker.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:uuid/uuid.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';


// class UploadScreenRegistration extends StatefulWidget {
//   @override
//   _UploadScreenRegistrationState createState() => _UploadScreenRegistrationState();
// }

// class _UploadScreenRegistrationState extends State<UploadScreenRegistration> {
//   FirebaseAuth fAuth = FirebaseAuth.instance;
//   FirebaseUser loggedInUser;
//   final StorageReference storageRef = FirebaseStorage.instance.ref();

//   //Fire Store
//   final userRef = Firestore.instance.collection('userProfile');

//   File _image;
//   String profilePicID = Uuid().v4();
//   String defaultImage = 'assets/images/blank_profile.jpg';
//   String userID;

//   bool loadingSpinner = false;

//  @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     fAuth.currentUser().then((user){
//         this.userID = user.uid;
//     });
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(txtTitle: 'Profile Picture'),
//         body: 
//         ModalProgressHUD(
//             inAsyncCall: loadingSpinner,
//             child:SingleChildScrollView(
          
//         child: Padding(
//           padding: const EdgeInsets.only(top:100),
          
//                       child: Column(
//                 children: <Widget>[ 
//                   HeaderTitle(textColor: Colors.deepOrange,textSize: 50.0),
//                   subHeaderTitle(txtTitle: 'Upload your picture'),
//                   SizedBox(height: 20.0),
//                     Stack(
//                       children: <Widget>[
                       
//                              CircleAvatar(
//                             radius: 100,
//                             backgroundColor: Colors.deepOrange,
                            
//                             child: ClipOval(
//                               child: SizedBox(
//                                 height: 190.0,
//                                 width: 190.0,
//                                 child: (_image != null) ? Image.file(_image,fit:BoxFit.fill) :
//                                 Image.asset(defaultImage,fit: BoxFit.fill),
                                
//                               ),
//                             ),
//                         ),
                      
//                       Padding(
//                         padding: const EdgeInsets.only(left:120.0,top:150.0),
//                         child: FlatButton(
//                           onPressed: (){
//                             getImage();
//                           },
//                           child:Text('+',style:TextStyle(fontSize: 40.0,color:Colors.white)),
//                           shape: CircleBorder(),
//                           color:Colors.deepOrange,
//                           padding: EdgeInsets.all(1.0),

//                     ),
//                       ),

//                       ],
//                     ),
                        
                   
//                       SizedBox(height: 25),
//                             Padding(
//                               padding: EdgeInsets.only(left:25,right:25,bottom:25),
//                               child: wideButton(
//                                 buttonText: 'FINISH',
//                                 onPressed: (){
//                                setState(() {
//                                  loadingSpinner = true;
//                                });
//                                       if(_image == null){
//                                       showDialogWarning(context, "Please select a profile picture");
//                                       }else{
//                                         createUser();
//                                       }
                                    

//                                 }
                                
//                                 //Navigator.push(context, MaterialPageRoute(builder: (context)=>CompleteRegistration())),
//                               )
//                             ),
//                 ],
//               ),
//           ),
//         ),
//         ),
//     );
//   }

//   Future getImage() async{

//     var image = await ImagePicker.pickImage(source:ImageSource.gallery);

//     setState(() {
//       _image = image;
//       setImageLocation(_image.toString());
//       print('Image path : $_image');
//     });

    

//   }

//   compressImage() async {
//     final tempDir = await getTemporaryDirectory();
//     final path = tempDir.path;
//     Im.Image imageFile = Im.decodeImage(_image.readAsBytesSync());
//     final compressImageFile = File('$path/img_$profilePicID.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile,quality:85));

//     setState(() {
//      _image = compressImageFile;

//     });

//   }

//   Future<String>uploadImage(imageFile) async{
//       StorageUploadTask uploadTask = storageRef.child("profilepic/$userID/profile_$profilePicID.jpg").putFile(imageFile);
//       StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
//       String downloadUrl = await storageSnap.ref.getDownloadURL();
//       return downloadUrl;
//   }

//   void createUser()async {
//           String mediaURL = await uploadImage(_image);
        
   

//     try {
//       await userRef.document(userID).setData({
//           'address':getAddress(),
//           'fullname':getFname()+" "+getLname(),
//           'mobilenumber':getMobileNum(),
//           'profilepic':mediaURL
//       });

//     setState(() {
//       loadingSpinner = false;
//     });
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => CompleteRegistration()));
//     } catch (e) {
//       print(e);
//     }
//   }
// }

 