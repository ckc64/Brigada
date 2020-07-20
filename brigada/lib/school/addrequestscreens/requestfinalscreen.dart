import 'dart:io';

import 'package:brigada/fadeanimation.dart';
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

import '../schoolhomescreen.dart';

class RequestFinalScreen extends StatefulWidget {
  @override
  _RequestFinalScreenState createState() => _RequestFinalScreenState();
}

class _RequestFinalScreenState extends State<RequestFinalScreen> {
  FirebaseAuth fAuth = FirebaseAuth.instance;
  final accountRef = Firestore.instance.collection('accounts');
  final requestRef = Firestore.instance.collection('requestList');
  final userRequestRef = Firestore.instance.collection('userRequestList');
    final StorageReference storageRef = FirebaseStorage.instance.ref();
  String userID;
  String requestPicID = Uuid().v4();
  String requestPicID1 = Uuid().v4();
  String requestPicID2= Uuid().v4();
  String requestPicID3 = Uuid().v4();
  File _image,_image1,_image2,_image3;
  bool loadingSpinner = false;

  String requestID = Uuid().v4();

  @override
  void initState() {
    super.initState();
    fAuth.currentUser().then((user) {
      this.userID = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
       
          inAsyncCall: loadingSpinner,
          child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              FadeAnimation(1.8,
                               Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 70, left: 25),
                      child: Text(
                        "Finish Request",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat-Bold',
                          fontSize: 40,
                            color: Colors.deepOrange),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
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
                            padding: const EdgeInsets.only(top:120),
                            child: FlatButton(
                              onPressed: (){
                                getImage();
                              },
                              child:Text('+',style:TextStyle(fontSize: 40.0,color:Colors.white)),
                              shape: CircleBorder(),
                              color:Colors.deepOrange,
                              padding: EdgeInsets.all(1.0),

                      ),

                          ),
                        ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top:10,left:25,right:25),
                      child:   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                    
                                 Container(

                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _image1 != null ? FileImage(_image1) : AssetImage('assets/images/no-image-featured.png'),
                              ),

                            ),
                            child: Center(
                        
                          child: Padding(
                            padding: const EdgeInsets.only(top:45),
                            child: FlatButton(
                              onPressed: (){
                                getImage1();
                              },
                              child:Text('+',style:TextStyle(fontSize: 28.0,color:Colors.white)),
                              shape: CircleBorder(),
                              color:Colors.deepOrange,
                            

                      ),
                          ),
                        ),
                          ),
                               
                        
                         
                          Container(

                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _image2 != null ? FileImage(_image2) : AssetImage('assets/images/no-image-featured.png'),
                              ),
                            ),
                            child: Center(
                        
                          child: Padding(
                            padding: const EdgeInsets.only(top:45),
                            child: FlatButton(
                              onPressed: (){
                                getImage2();
                              },
                              child:Text('+',style:TextStyle(fontSize: 28.0,color:Colors.white)),
                              shape: CircleBorder(),
                              color:Colors.deepOrange,
                            

                      ),
                          ),
                        ),
                          ),
                          Container(

                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _image3 != null ? FileImage(_image3) : AssetImage('assets/images/no-image-featured.png'),
                              ),
                            ),
                            child: Center(
                        
                          child: Padding(
                            padding: const EdgeInsets.only(top:45),
                            child: FlatButton(
                              onPressed: (){
                                getImage3();
                              },
                              child:Text('+',style:TextStyle(fontSize: 28.0,color:Colors.white)),
                              shape: CircleBorder(),
                              color:Colors.deepOrange,
                            

                      ),
                          ),
                        ),
                          ),
                        ],
                      ),
                    ),
 Container(
                        padding: EdgeInsets.only(top:25,left: 25),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.business,color: Colors.deepOrange,),
                            SizedBox(width: 10),
                             Text(getSchoolName(),
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          
                          ],
                        )),
                          Container(
                            padding: EdgeInsets.only(left: 60,top:15),
                            child: Text(getSchoolAddress(),
                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                ),
                          ),
                   Container(
                        padding: EdgeInsets.only(left: 25),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_on,color: Colors.deepOrange,),
                            SizedBox(width: 10),
                             Text(getCity(),
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          
                          ],
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 25,top:10),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.date_range,color: Colors.deepOrange,),
                            SizedBox(width: 10),
                            Text(getDate(),

                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                            
                            Text(" at ",

                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                           
                            Text(getTime(),

                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                   Container(
                      padding: const EdgeInsets.only(top: 25, left: 25),
                      child: Text("Request Details",
                      style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.deepOrange),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10, left: 25,right:25),
                        child: Row(
                          children: <Widget>[
                            Text(getRequestTitle(),
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                    Container(
                      padding: const EdgeInsets.only(left: 25, top: 10,right:25),
                      child: Text(
                          getRequestDetails(),
                            style: TextStyle(fontSize: 16),
                          ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 30),
                        child: wideButton(
                            buttonText: 'FINISH REQUEST',
                            onPressed: () {
                              if(_image == null || _image1 == null || _image2 == null || _image3 == null){
                                showDialogWarning(context, "No image must be empty for verification");
                              }else{
                                setState(() {
                                  loadingSpinner = true;
                                });
                              addToUserRequest();
                            }
                            })),
                  ],
                ),
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
      print("image "+_image.toString());
    });

    

  }
  
Future getImage1() async{

    var image1 = await ImagePicker.pickImage(source:ImageSource.gallery);

    setState(() {
      _image1 = image1;
      print("image1 "+_image1.toString());
    });

    

  }
  Future getImage2() async{

    var image2 = await ImagePicker.pickImage(source:ImageSource.gallery);

    setState(() {
      _image2 = image2;
      print("image2 "+_image2.toString());
    });

    

  }
  Future getImage3() async{

    var image3 = await ImagePicker.pickImage(source:ImageSource.gallery);

    setState(() {
      _image3 = image3;
      print("image3 "+_image3.toString());
    });

    

  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(_image.readAsBytesSync());
    final compressImageFile = File('$path/img_$requestPicID.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile,quality:85));

    setState(() {
     _image = compressImageFile;
    
    });

  }
  
  compressImage1() async {
    final tempDir1 = await getTemporaryDirectory();
    final path = tempDir1.path;
    Im.Image imageFile1 = Im.decodeImage(_image1.readAsBytesSync());
    final compressImageFile1 = File('$path/img_$requestPicID1.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile1,quality:85));

    setState(() {
     _image1 = compressImageFile1;
    
    });

  }
  
  compressImage2() async {
    final tempDir2 = await getTemporaryDirectory();
    final path = tempDir2.path;
    Im.Image imageFile2 = Im.decodeImage(_image2.readAsBytesSync());
    final compressImageFile2 = File('$path/img_$requestPicID2.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile2,quality:85));

    setState(() {
     _image2 = compressImageFile2;
    
    });

  }
  
  compressImage3() async {
    final tempDir3 = await getTemporaryDirectory();
    final path = tempDir3.path;
    Im.Image imageFile3 = Im.decodeImage(_image3.readAsBytesSync());
    final compressImageFile3 = File('$path/img_$requestPicID3.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile3,quality:85));

    setState(() {
     _image3 = compressImageFile3;
    
    });

  }

  Future<String>uploadImage(imageFile) async{
      StorageUploadTask uploadTask = storageRef.child("requestpic/$userID/$requestID/requestPic_$requestPicID.jpg").putFile(imageFile);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      return downloadUrl;
  }

   Future<String>uploadImage1(imageFile) async{
      StorageUploadTask uploadTask = storageRef.child("requestpic/$userID/$requestID/requestPic_$requestPicID1.jpg").putFile(imageFile);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      return downloadUrl;
  }

   Future<String>uploadImage2(imageFile) async{
      StorageUploadTask uploadTask = storageRef.child("requestpic/$userID/$requestID/requestPic_$requestPicID2.jpg").putFile(imageFile);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      return downloadUrl;
  }

   Future<String>uploadImage3(imageFile) async{
      StorageUploadTask uploadTask = storageRef.child("requestpic/$userID/$requestID/requestPic_$requestPicID3.jpg").putFile(imageFile);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      return downloadUrl;
  }

addToRequestList()async{
  await compressImage();
  await compressImage1();
  await compressImage2();
  await compressImage3();

     String mediaURL = await uploadImage(_image);
     String mediaURL1 = await uploadImage1(_image1);
     String mediaURL2 = await uploadImage2(_image2);
     String mediaURL3 = await uploadImage3(_image3);
    Image defaultPic = Image.asset("assets/images/img_card.jpg");

    await accountRef.document(this.userID).get().then((doc) async{
      if(doc.exists){
                await requestRef
        .document(requestID)
        .setData({
       'requestTimeStart': getTime(),
      'requestDateStart': getDate(),
      'requestDetails': getRequestDetails(),
      'requestPhoto': (mediaURL==null) ? defaultPic : mediaURL,
      'requestPhoto1': (mediaURL==null) ? defaultPic : mediaURL1,
      'requestPhoto2': (mediaURL==null) ? defaultPic : mediaURL2,
      'requestPhoto3': (mediaURL==null) ? defaultPic : mediaURL3,
      'requestTitle': getRequestTitle(),
      'requestAddress': doc['schoolAddress'],
      'requestSchoolName': doc['schoolName'],
      'requestSchoolEmailAddress':doc['schoolEmailAddress'],
      'requestCity':doc['city'],
      'location':{
        'latitude': doc['locationpoint']['latitude'],
        'longitude':doc['locationpoint']['longitude']
      },
      'volunteers':{},
      'reports':{},
       'dateposted':DateTime.now(),
       'requestID': requestID,
       'requestOwnerID':this.userID,
       
    });
      }
    });

    
}

  addToUserRequest() async {
     await compressImage();
  await compressImage1();
  await compressImage2();
  await compressImage3();

     String mediaURL = await uploadImage(_image);
     String mediaURL1 = await uploadImage1(_image1);
     String mediaURL2 = await uploadImage2(_image2);
     String mediaURL3 = await uploadImage3(_image3);
    Image defaultPic = Image.asset("assets/images/img_card.jpg");

   await accountRef.document(this.userID).get().then((doc) async{
      if(doc.exists){
         await userRequestRef
        .document(this.userID)
        .collection('listOfUserRequest')
        .document(requestID)
        .setData({
     'requestTimeStart': getTime(),
      'requestDateStart': getDate(),
      'requestDetails': getRequestDetails(),
            'requestPhoto': (mediaURL==null) ? defaultPic : mediaURL,
      'requestPhoto1': (mediaURL==null) ? defaultPic : mediaURL1,
      'requestPhoto2': (mediaURL==null) ? defaultPic : mediaURL2,
      'requestPhoto3': (mediaURL==null) ? defaultPic : mediaURL3,
      'requestTitle': getRequestTitle(),
      'requestAddress': doc['schoolAddress'],
      'requestSchoolName': doc['schoolName'],
       'requestSchoolEmailAddress':doc['schoolEmailAddress'],
      'requestCity':doc['city'],
      'location':{
        'latitude': doc['locationpoint']['latitude'],
        'longitude':doc['locationpoint']['longitude']
      },
      'volunteers':{},
      'reports':{},
       'dateposted':DateTime.now(),
       'requestID': requestID,
       'requestOwnerID':this.userID,

       
       
    });

        await addToRequestList();
    setState(() {
      loadingSpinner = false;
    });
      }
    });


    Navigator.pushReplacement(context, 
    MaterialPageRoute(builder: (context)=>SchoolHomeScreen(currentUserID: this.userID,))
    );
    
  }
}
