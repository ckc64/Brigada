import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../fadeanimation.dart';

class ProfilePageVolunteer extends StatefulWidget {
  final currentUserID;

  const ProfilePageVolunteer({Key key, this.currentUserID}) : super(key: key);
  @override
  _ProfilePageVolunteerState createState() => _ProfilePageVolunteerState();
}

class _ProfilePageVolunteerState extends State<ProfilePageVolunteer> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        appBar: appBar(txtTitle:"Profile"),
        body: SingleChildScrollView(
          
          child:FutureBuilder(
            future:Firestore.instance.collection('accounts').document(widget.currentUserID).get(),
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
                                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey,
                    backgroundImage:CachedNetworkImageProvider(snapshot.data['profilepic']),
                  ),
                ),
                FadeAnimation(1.8,
                                  Text(
                    snapshot.data['firstname']+" "+snapshot.data['lastname'],
                    style: TextStyle(
                      fontSize: 30.0,
                      color:  Colors.black,
                      fontFamily: 'Montserrat-Regular',
               
                    ),
                  ),
                ),
                FadeAnimation(1.8,
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width: 300,
                                    child: Text(
                                      
                    snapshot.data['address']+","+snapshot.data['city'],
                    textAlign: TextAlign.center,
                    style:TextStyle(
                      fontSize: 15.0,
                      color : Colors.black,
                       fontFamily: 'Montserrat-Regular',
                    ),
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
                        leading: Icon(Icons.perm_phone_msg,
                      color: Colors.deepOrange,
                       ),
                       title:  Text(snapshot.data['mobilenum'],
                         style:TextStyle(
                           fontSize: 16.0,
                           fontFamily: 'Montserrat-Regular',
                         ),
                      ),
                      ),
                  ),
                    ),
                ),
             SizedBox(height: 10.0),
                FadeAnimation(1.8,
                                   Card(
                   elevation: 0,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                     
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child:ListTile(
                        leading: Icon(Icons.email,
                      color: Colors.deepOrange,
                       ),
                       title:   Text(snapshot.data['emailaddress'],
                         style:TextStyle(
                           fontSize: 16.0,
                           fontFamily: 'Montserrat-Regular',
                         ),
                      ),
                      ),
                    ),
                  ),
                ),
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