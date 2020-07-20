import 'dart:io';

import 'package:brigada/chatpages/chatfeed.dart';
import 'package:brigada/loginscreen.dart';
import 'package:brigada/requestdetailpage.dart';
import 'package:brigada/school/notificationschoolscreen.dart';
import 'package:brigada/school/pastrequestdetails.dart';
import 'package:brigada/school/profilepageschool.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:brigada/widgets/reusablewidgets.dart' as prefix0;
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../changepasswordscreen.dart';
import 'addrequestscreens/requesttitlescreen.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SchoolHomeScreen extends StatefulWidget {
  final currentUserID;

  const SchoolHomeScreen({Key key, this.currentUserID}) : super(key: key);

  @override
  _SchoolHomeScreenState createState() => _SchoolHomeScreenState();
}

class _SchoolHomeScreenState extends State<SchoolHomeScreen> {

  Future getUserRequestListCardsFromFirebase() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('userRequestList')
        .document(widget.currentUserID)
        .collection('listOfUserRequest')
        .orderBy('dateposted',descending: true)
        .getDocuments();

    return querySnapshot.documents;
  }

   Future getPastUserRequestListCardsFromFirebase() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('pastRequest')
        .document(widget.currentUserID)
        .collection('listOfPastRequest')
        .getDocuments();

    return querySnapshot.documents;
  }


transferPastRequest() async{
  
                await Firestore.instance
                    .collection('userRequestList')
                    .document(widget.currentUserID)
                    .collection('listOfUserRequest')
                    .getDocuments()
                    .then((data) async {
                     
                        for(int i = 0; i<data.documents.length;i++){
                 
                  
 print(data.documents[i].data['requestID']);
                            await Firestore.instance.collection('pastRequest')
                            .document(widget.currentUserID)
                            .collection('listOfPastRequest')
                            .document(data.documents[i].data['requestID']).setData({
                               'requestTimeStart': data.documents[i].data['requestTimeStart'],
                                  'requestDateStart': data.documents[i].data['requestDateStart'],
                                  'requestDetails': data.documents[i].data['requestDetails'],
                                  'requestPhoto': data.documents[i].data['requestPhoto'],
                                  'requestPhoto1': data.documents[i].data['requestPhoto1'],
                                  'requestPhoto2': data.documents[i].data['requestPhoto2'],
                                  'requestPhoto3': data.documents[i].data['requestPhoto3'],
                                  'requestTitle': data.documents[i].data['requestTitle'],
                                  'requestAddress': data.documents[i].data['requestAddress'],
                                  'requestSchoolName': data.documents[i].data['requestSchoolName'],
                                  'requestSchoolEmailAddress':data.documents[i].data['requestSchoolEmailAddress'],
                                  'requestCity':data.documents[i].data['requestCity'],
                       
                                  'dateposted':data.documents[i].data['dateposted'],
                                  'requestID': data.documents[i].data['requestID'],
                                  'requestOwnerID':data.documents[i].data['requestOwnerID'],

                            });

                            await Firestore.instance.collection('requestList')
                            .document(data.documents[i].data['requestID'])
                            .get().then((doc){
                              if(doc.exists){
                                doc.reference.delete();
                              }
                            });

                              data.documents[i].reference.delete();
                          
                        }
                    });
}

@override
void initState() { 

  super.initState();
  
}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                   child: Column(
                     mainAxisSize: MainAxisSize.max,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       Center(child: HeaderTitle(textColor: Colors.white,textSize: 30.0)),
                       Center(child: Text(
                          "post request for help",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat-Regular',
                            fontSize: 13.0,
                          ),
                       ),
                      )
                     ],
                   ),
                   
              decoration: BoxDecoration(
                color: Colors.deepOrange,
              ),
              ),
              FutureBuilder(
                future: Firestore.instance.collection("accounts").document(widget.currentUserID).get(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return circularProgress();
                  }
                  return 
                  
                   Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top:5, left:20),
                          child: Text(snapshot.data['schoolName'],
                          style: TextStyle(fontSize: 20.0,fontFamily: 'Montserrat-Regular')),
                        ),
                         Padding(
                            padding: const EdgeInsets.only(top:3, left:20),
                          child: Text(snapshot.data['schoolAddress']+", "+snapshot.data['city'],
                          style: TextStyle(fontSize: 13.0,fontFamily: 'Montserrat-Regular')),
                        ),
                         Padding(
                            padding: const EdgeInsets.only(top:3, left:20),
                          child: Text(snapshot.data['schoolEmailAddress'],
                          style: TextStyle(fontSize: 13.0,fontFamily: 'Montserrat-Regular',color: Colors.deepOrange)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Divider(height: 10,color: Colors.grey,),
                        ),
                          
                         ListTile(
                            title: Text("Profile",
                          style: TextStyle(fontSize: 16.0,fontFamily: 'Montserrat-Regular')),
                          onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfilePageSchool(currentUserID: widget.currentUserID,schoolID: widget.currentUserID,))),
                          leading: Icon(Icons.person_outline),
                          
                          ),
                           
                        ListTile(
                            title: Text("Messages",
                          style: TextStyle(fontSize: 16.0,fontFamily: 'Montserrat-Regular')),
                         onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatFeed(currentUserID: widget.currentUserID,))),
                          leading: Icon(Icons.message,)
                          
                          ),
                       
                            ListTile(
                            title: Text("Change Password",
                          style: TextStyle(fontSize: 16.0,fontFamily: 'Montserrat-Regular')),
                          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordScreen())),
                          leading: Icon(Icons.lock_outline),
                          ),
                           Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Divider(height: 10,color: Colors.grey,),
                        ),
                           ListTile(
                            title: Text("Logout",
                          style: TextStyle(fontSize: 16.0,fontFamily: 'Montserrat-Regular',color: Colors.red)),
                          onTap: ()=>logoutAccount(),
                          leading: Icon(Icons.close),
                          
                          ),
                      
                      ],
                    );
                  
                }
              ),
             
            ],
          ),
        ),
        floatingActionButton: floatingActionButton(context,
         onPressed: () async{

               
                    FirebaseUser user = await FirebaseAuth.instance.currentUser();

                    Firestore.instance.collection("accounts")
                    .document(user.uid).get().then((doc){
                        if(doc.exists){
                                 setSchoolAddress(doc['schoolAddress']);
                                              setCity(doc['city']);
                                              setSchoolName(doc['schoolName']);
                                              setLatitude(doc['locationpoint']['latitude']);
                                              setLongitude(doc['locationpoint']['longitude']);

                                                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RequestTitleScreen()));
                        }else{
                          showDialogWarning(context, "DATA NOT FOUND");
                        }
                    });
                
                },
        ),
          appBar: AppBar(
          
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 4,
              labelStyle: TextStyle(fontFamily: 'Montserrat-Regular',fontWeight: FontWeight.bold),
              tabs: [
              
                Tab(
                  text: "ACTIVE REQUEST",
                  
                ),
                Tab(
                  text: "PAST REQUEST",
                ),
              ],
            ),
            backgroundColor: Colors.deepOrange,
            title: Text("Manage Requests",style: TextStyle(fontFamily: 'Montserrat-Regular'),),
            actions: <Widget>[
              IconButton(
                onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationSchoolScreen(currentUserID: widget.currentUserID,)));
                  
                },
                icon: Icon(Icons.notifications_none),
                iconSize: 30.0,
              )
            ],
          ),
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              FutureBuilder(
                  future: getUserRequestListCardsFromFirebase(),
                  builder: (context, snapshot) {
                
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                  
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          return UserRequestList(
                            onPressed: (){
                              transferPastRequest();
                              prefix0.showDialogWarning(context, "REQUEST DELETED");
                            },
                          
                            requestOwnerID: snapshot.data[index].data['requestOwnerID'],
                            currentUserID: widget.currentUserID,
                            requestID: snapshot.data[index].data['requestID'],
                            requestTitle:
                                snapshot.data[index].data['requestTitle'],
                            imgPath: snapshot.data[index].data['requestPhoto'],
                            schoolAddress:
                                snapshot.data[index].data['requestAdress'],
                            schoolName: snapshot.data[index].data['requestSchoolName'],
                          );
                        });
                  }),
               
                FutureBuilder(
                  future: getPastUserRequestListCardsFromFirebase(),
                  builder: (context, snapshot) {
                   
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          return PastUserRequestList(
                            requestOwnerID: snapshot.data[index].data['requestOwnerID'],
                            currentUserID: widget.currentUserID,
                            requestID: snapshot.data[index].data['requestID'],
                            requestTitle:
                                snapshot.data[index].data['requestTitle'],
                            imgPath: snapshot.data[index].data['requestPhoto'],
                            schoolAddress:
                                snapshot.data[index].data['requestAdress'],
                            schoolName: snapshot.data[index].data['requestSchoolName'],
                          );
                        });
                  }),
            ],
          )),
    );
    
  }

 logoutAccount() async{
     SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();
        prefs.clear();
      await FirebaseAuth.instance.signOut();
                              
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }

}

class UserRequestList extends StatelessWidget {
  final String requestTitle, imgPath, schoolName, schoolAddress,requestID,currentUserID,requestOwnerID;
  final onPressed;

  const UserRequestList(
      {Key key,
      this.requestTitle,
      this.imgPath,
      this.schoolAddress,
      this.schoolName,
      this.requestID, this.currentUserID, this.requestOwnerID, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
               GestureDetector(
                onTap: () {
                                Navigator.push(context, MaterialPageRoute
                                (builder: (context)=> RequestDetailPage(requestID: requestID,
                                currentUserID: currentUserID,
                                requestOwnerID: requestOwnerID,
                                )
                                ));
                                
                              },
            child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
          child: Container(
            child: Material(
              color: Colors.grey[100],
              elevation: 0,
              borderRadius: BorderRadius.circular(5),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: new CachedNetworkImage(
                          imageUrl: imgPath,
                          height: 96.0,
                          width: 96.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => circularProgress(),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 200,
                          child: Text(
                        requestTitle.toUpperCase(),
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                      Container(
                          child: Row(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                            
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "$schoolName",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.only(bottom:40),
        child: IconButton(
          icon: Icon(Icons.cancel,size: 50,color: Colors.deepOrange[400],),
          onPressed: onPressed,
        ),
      )
      ],
    );
  }
}


class PastUserRequestList extends StatelessWidget {
  final String requestTitle, imgPath, schoolName, schoolAddress,requestID,currentUserID,requestOwnerID;

  const PastUserRequestList(
      {Key key,
      this.requestTitle,
      this.imgPath,
      this.schoolAddress,
      this.schoolName,
      this.requestID, this.currentUserID, this.requestOwnerID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
              onTap: () {
                              Navigator.push(context, MaterialPageRoute
                              (builder: (context)=> PastRequestDetails(requestID: requestID,
                              currentUserID: currentUserID,
                              
                              )
                              ));
                              
                            },
          child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
        child: Container(
          child: Material(
            color: Colors.grey[100],
            elevation: 0,
            borderRadius: BorderRadius.circular(5),
            child: Row(
              children: <Widget>[
            
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                       width: 200,
                        child: Text(
                      requestTitle.toUpperCase(),
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                          
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "$schoolName",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
