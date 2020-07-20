import 'package:brigada/changepasswordscreen.dart';
import 'package:brigada/chatpages/chatfeed.dart';
import 'package:brigada/loginscreen.dart';
import 'package:brigada/volunteer/profilepagevolunteer.dart';
import 'package:brigada/volunteer/volunteeracceptedrequest.dart';

import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerProfile extends StatefulWidget {
  final currentUserID;

  const VolunteerProfile({Key key, this.currentUserID}) : super(key: key);
  @override
  _VolunteerProfileState createState() => _VolunteerProfileState();
}

class _VolunteerProfileState extends State<VolunteerProfile> {
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){},
          child: Scaffold(
        
        body: SafeArea(
                child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
              
               FutureBuilder(
                 future: Firestore.instance.collection("accounts").document(widget.currentUserID).get(),
                 builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return circularProgress();
                    }
                    return  Padding(
                      padding: const EdgeInsets.only(left:15,right: 15),
                      child: Column(
                        children: <Widget>[
                          Container(
                              height: 200,
                              child: Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.deepOrange,
                                  backgroundImage: CachedNetworkImageProvider(snapshot.data['profilepic']),
                                  maxRadius: 70,
                                ),
                              ),
                            ),

                            Text(snapshot.data['firstname']+" "+snapshot.data['lastname'],
                            style: TextStyle(
                              fontFamily: 'Montserrat-Bold',
                              fontSize: 20
                            ),
                            ),
                            Text(snapshot.data['emailaddress'],
                            style: TextStyle(
                              fontFamily: 'Montserrat-Regular',
                              fontSize: 14
                            ),
                            ),
                              Text(snapshot.data['mobilenum'],
                            style: TextStyle(
                              fontFamily: 'Montserrat-Regular',
                              fontSize: 14
                            ),
                            ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:25,right: 25,top:5),
                                    child: Text( " *Note: Only the school you volunteered will see your mobile number and profile for text or email updates.",
                            style: TextStyle(
                              fontFamily: 'Montserrat-Regular',
                              fontSize: 12,
                              color: Colors.red
                            ),
                            ),
                                  ),
                           
                            SizedBox(height: 20,),
                        Divider(color: Colors.black,),
                             ListTile(
                               leading: Icon(Icons.person_outline),
                              title: Text("View Profile"),
                              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePageVolunteer(currentUserID: widget.currentUserID,))),
                            ),
                               Divider(color: Colors.black,),
                             ListTile(
                               leading: Icon(Icons.mail_outline),
                              title: Text("View Messages"),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatFeed(currentUserID: widget.currentUserID,)));
                              },
                            ),
                          
                            Divider(color: Colors.black,),
                             ListTile(
                               leading: Icon(Icons.content_paste),
                              title: Text("View Accepted Request"),
                                onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>VolunteerAcceptedRequest(currentUserID: widget.currentUserID,)));
                              },
                            ),
                               Divider(color: Colors.black,),
                                ListTile(
                              leading: Icon(Icons.lock_outline),
                              title: Text("Change Password"),
                              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordScreen()))

                            ),
                             Divider(color: Colors.black,),
                             ListTile(
                               leading: Icon(Icons.close,color: Colors.red,),
                              title: Text("Logout",
                              style: TextStyle(color:Colors.red),),
                              onTap: () {
                                  logoutAccount();
                              },
                            ),
                        ],
                      ),
                    );
                 },
               ),
                    
                    ],
            ),
          ),
        ),
      ),
    );
  }

  logoutAccount() async{
     SharedPreferences prefs,pref2;
      prefs = await SharedPreferences.getInstance();
      pref2 = await SharedPreferences.getInstance();
      pref2.clear();
        prefs.clear();
      await FirebaseAuth.instance.signOut();
                              
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }



}