import 'package:brigada/chatpages/chatfeed.dart';
import 'package:brigada/chatpages/chatscreen.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../fadeanimation.dart';

class ProfilePageSchool extends StatefulWidget {
  final currentUserID,schoolID;

  const ProfilePageSchool({Key key, this.currentUserID, this.schoolID}) : super(key: key);
  @override
  _ProfilePageSchoolState createState() => _ProfilePageSchoolState();
}

class _ProfilePageSchoolState extends State<ProfilePageSchool> {


SharedPreferences pref2;
bool isMe = false;

@override
void initState() { 

  FirebaseAuth.instance.currentUser().then((user){
   
    if(widget.currentUserID == widget.schoolID){
      setState(() {
         isMe = true;
      });
    }
  });
  super.initState();
  
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        appBar: appBar(txtTitle:"Profile"),
        body: SingleChildScrollView(
          
          child:FutureBuilder(
            future:Firestore.instance.collection('accounts').document(widget.schoolID).get(),
            builder:(context,snapshot){
              if(!snapshot.hasData){
                return circularProgress();
              }

              return  SafeArea(
                              child: Padding(
                                padding: EdgeInsets.only(top: 150),
                                child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
                FadeAnimation(1.8,
                                  Text(
                    snapshot.data['schoolName'],
                    style: TextStyle(
                      fontSize: 30.0,
                      color:  Colors.black,
                      fontFamily: 'Montserrat-Regular',
               
                    ),
                  ),
                ),
                FadeAnimation(1.8,
                                  Text(
                    snapshot.data['schoolAddress']+","+snapshot.data['city'],
                    style:TextStyle(
                      fontSize: 15.0,
                      color : Colors.black,
                       fontFamily: 'Montserrat-Regular',
                    ),
                  ),
                ),
                FadeAnimation(1.8,
                                  SizedBox( height:20.0,
                   width:150.0,
             child: Divider(
                   color:Colors.deepOrange,
                  ),
                  ),
                ),
                FadeAnimation(1.8,
                  Card(
                    elevation: 0,
                   margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Padding(
                     padding: EdgeInsets.all(0.0),
                      child: ListTile(
                        leading: Icon(Icons.email,
                      color: Colors.deepOrange,
                       ),
                       title:  Text(snapshot.data['schoolEmailAddress'],
                         style:TextStyle(
                           fontSize: 16.0,
                           fontFamily: 'Montserrat-Regular',
                         ),
                      ),
                      ),
                  ),
                    ),
                ),
                SizedBox(height: 10,),
                   isMe ? Text(""): FadeAnimation(1.8, 
                    InkWell(
                     onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(profileID: widget.schoolID))),
                      child: Text("Send a Message",
                      style: TextStyle(color: Colors.deepOrange,fontSize:18,fontFamily: 'Montserrat-Regular'),
                      )
                    )
                  )
                
            
            ],
          ),
                              ),
              );
            }
          )
        ),
      );
  }
 
}