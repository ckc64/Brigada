import 'dart:io';

import 'package:brigada/fadeanimation.dart';
import 'package:brigada/loginscreen.dart';
import 'package:brigada/signupasscreen.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';



class VolunteerFinalScreen extends StatefulWidget {
   File image;

   VolunteerFinalScreen({Key key, this.image}) : super(key: key);
  @override
  _VolunteerFinalScreenState createState() => _VolunteerFinalScreenState();
}


 TextEditingController passwordController  = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController  = TextEditingController();

    //firestore
    final accountsRef = Firestore.instance.collection('accounts');

    //firebasestorage
     final StorageReference storageRef = FirebaseStorage.instance.ref();

String profilePicID = Uuid().v4();

  //spinner
  bool showSpinner = false;
 
class _VolunteerFinalScreenState extends State<VolunteerFinalScreen> {



    compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(widget.image.readAsBytesSync());
    final compressImageFile = File('$path/img_$profilePicID.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile,quality:85));

    setState(() {
     widget.image = compressImageFile;

    });

  }

  Future<String>uploadImage(imageFile) async{
      StorageUploadTask uploadTask = storageRef.child("profilePic/${emailController.text}//profilePic_$profilePicID.jpg").putFile(imageFile);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      return downloadUrl;
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(txtTitle: 'Finish Registration'),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.deepOrange,
    
              child: SingleChildScrollView(
        	child: Container(
	        child: Column(
	          children: <Widget>[
           
	            Container(
	              height:   180,
	    
                     
	                  child: FadeAnimation(1.6, Container(
	                  
	                      child: Padding(
	                        padding: const EdgeInsets.only(top:100),
	                        child: Center(
	                          child:  HeaderTitle(textColor: Colors.deepOrange, textSize: 50.0)
	                        ),
	                      ),
	                    )),
	                  
	            
	            ),
                             Container(
	 
	    
                     
	                  child: FadeAnimation(1.6,
                       Container(
	                  
	                      child: Padding(
	                        padding: const EdgeInsets.only(top:50),
	                        child: Center(
	                          child:  Text('FINISH REGISTRATION',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 18.0,
                ),
             ),
	                        ),
	                      ),
	                    )),
	                  
	            
	            ),

	            Padding(
	              padding: EdgeInsets.all(30.0),
	              child: Column(
	                children: <Widget>[
	                  FadeAnimation(1.8, Container(
	                    padding: EdgeInsets.all(5),
	                    decoration: BoxDecoration(
	                      color: Colors.white,
	                      borderRadius: BorderRadius.circular(10),
	                      boxShadow: [
	                        BoxShadow(
	                          color: Color.fromRGBO(143, 148, 251, .2),
	                          blurRadius: 20.0,
	                          offset: Offset(0, 10)
	                        )
	                      ]
	                    ),
	                    child: Column(
	                      children: <Widget>[
	                        Container(
	                          padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
	                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
	                          ),
	                          child: TextField(
                                controller: emailController,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "emailaddress@gmail.com",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
                                Container(
                                       decoration: BoxDecoration(
	                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
	                          ),
	                          padding: EdgeInsets.all(8.0),
	                          child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Password",
	                              hintStyle: TextStyle(color: Colors.grey[400]),
                                  
	                            ),
	                          ),
	                        ),
                                  Container(
                                    
	                          padding: EdgeInsets.all(8.0),
	                          child: TextFormField(
                                controller: confirmPasswordController,
                                obscureText: true,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Confirm Password",
	                              hintStyle: TextStyle(color: Colors.grey[400]),
                                  
	                            ),
	                          ),
	                        )
	                    
	                      ],
	                    ),
	                  )),
	                  SizedBox(height: 30,),
	                  FadeAnimation(2, 
                      Container(
                        child: wideButton(
                          buttonText: "REGISTER",
                          onPressed: () async{
                            if(passwordController.text != confirmPasswordController.text){
                             showDialogWarning(context, "Password doesn't match");
                            }else{
                          
                            setState(() {
                              showSpinner = true;
                            });

                            print(getFname());
        print(getLname());
        print(getAddress());
        print(getMobileNum());
         
        print(emailController.text);
       
          print(getLatitude());
          print(getLongitude());
        
        print(getCity());
        print(getUserType());
                         

                                if(getLname() == null || getFname() == null
                                || getLatitude() == null || getLongitude() == null
                               || getCity() == null 
                                || getAddress() == null){
                                    showDialogWarning(context, "Some of the data is empty. Please try again");
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpAsScreen()));
                                    setState(() {
                                      showSpinner = false;
                                    });
                                }else{
   try{
                                  
    await FirebaseAuth.instance
    .createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
         String mediaURL = await uploadImage(widget.image);
    Image defaultPic = Image.asset("assets/images/img_card.jpg");

   await accountsRef.document(firebaseUser.uid).setData({
        'firstname':getFname(),
        'lastname':getLname(),
        'address':getAddress(),
        'mobilenum':getMobileNum(),
          'profilepic':(mediaURL==null) ? defaultPic : mediaURL,
        'emailaddress':emailController.text,
        'location':{
          'latitude':getLatitude(),
          'longitude':getLongitude(),
        },
        'city':getCity(),
        'userType':getUserType(),
        'username':getFname()+" "+getLname()
    });
     clearPreferences();

        setState(() {
          showSpinner = false;
        });
        

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    
    }on PlatformException{
      showDialogWarning(context,"Email is already in use or invalid email address");
      setState(() {
        showSpinner = false;
      });
    }

                                }

                            }
                            
                          }
                        ),
                        
	                  )
                      ),
	            
	                ],
	              ),
	            )
	          ],
	        ),
	      ),
        ),
      )
    );
    
  }
  
}




