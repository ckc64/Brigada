import 'dart:io';

import 'package:brigada/fadeanimation.dart';
import 'package:brigada/volunteer/volunteerregistration/volunteerfinalscreen.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class VolunteerAddProfile extends StatefulWidget {
  @override
  _VolunteerAddProfileState createState() => _VolunteerAddProfileState();
}

class _VolunteerAddProfileState extends State<VolunteerAddProfile> {
  FirebaseAuth fAuth = FirebaseAuth.instance;

    final StorageReference storageRef = FirebaseStorage.instance.ref();
 
  String profilePicID = Uuid().v4();
  File _image;
  bool loadingSpinner = false;

  String requestID = Uuid().v4();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
          inAsyncCall: loadingSpinner,
          child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 70, left: 25),
                    child: Text(
                      "Select Profile Picture",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat-Regular',
                        fontSize: 30,
                          color: Colors.deepOrange),
                    ),
                  ),
                  FadeAnimation(1.8,
                                     Padding(
                      padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 5 / 5,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _image != null ? FileImage(_image) : AssetImage('assets/images/no-image-featured.png'),
                                  ),
                                ),
                              ),
                      Center(
                        
                          child: Padding(
                            padding: const EdgeInsets.only(top:250),
                            child: FlatButton(
                              onPressed: (){
                                getImage();
                              },
                              child:Text('+',style:TextStyle(fontSize: 40.0,color:Colors.white)),
                              shape: CircleBorder(),
                              color:Colors.deepOrange,
                              padding: EdgeInsets.all(5.0),

                      ),
                          ),
                        ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
               
                  FadeAnimation(1.8,
                                       Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 30),
                        child: wideButton(
                            buttonText: 'NEXT',
                            onPressed: () {
                              if(_image == null){
                                showDialogWarning(context, "Select a picture");
                              }else{
                           
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>VolunteerFinalScreen(image: _image,)));
                           
                            }
                            })),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

Future getImage() async{

    var image = await ImagePicker.pickImage(source:ImageSource.gallery);

    setState(() {
      _image = image;
      setImageLocation(_image.toString());
      print('Image path : $_image');
    });

    

}


}
