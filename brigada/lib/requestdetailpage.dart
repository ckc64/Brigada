import 'package:brigada/photoviewerscreen.dart';
import 'package:brigada/reportscreen.dart';
import 'package:brigada/school/editrequestscreen.dart';
import 'package:brigada/school/profilepageschool.dart';
import 'package:brigada/viewallvolunteersscreen.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:brigada/widgets/reusablewidgets.dart' as prefix0;
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RequestDetailPage extends StatefulWidget {
  final requestID,currentUserID,requestOwnerID;

  const RequestDetailPage({Key key, this.requestID, this.currentUserID, this.requestOwnerID}) : super(key: key);
  @override
  _RequestDetailPageState createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {

    bool isAccepted = false;
    bool showSpinner = false;

    final requestVolunteersRef = Firestore.instance.collection('requestVolunteers');

      final requestListRef = Firestore.instance.collection('requestList');
      final userRequestListRef = Firestore.instance.collection('userRequestList');
      final acceptedRequestRef = Firestore.instance.collection('acceptedRequest');
      final notificationsRef = Firestore.instance.collection('notifications');
      final pastRequestRef = Firestore.instance.collection('pastRequest');


bool isOwner = false;
int volunteerCount=0;

@override
void initState() { 
  getNumberOfVolunteers();
  updateButton();
  super.initState();
  FirebaseAuth.instance.currentUser().then((user){
    if(user.uid == widget.requestOwnerID){
      setState(() {
        isOwner = true;
      });
    }
  });
}

getNumberOfVolunteers() async{
  QuerySnapshot snapshot = await requestVolunteersRef
        .document(widget.requestID)
        .collection('requestVolunteersList')
        .getDocuments();

        setState(() {
          volunteerCount = snapshot.documents.length;
        });
}
updateButton() async{
    await requestVolunteersRef
              .document(widget.requestID)
              .collection('requestVolunteersList')
              .document(widget.currentUserID)
              .get().then((doc){
                  if(doc.exists){
                   setState(() {
                     isAccepted = true;
                   });
                  }
              });
}

handleVolunteer() async{

  if(isAccepted==false){
        Firestore.instance.collection('accounts')
  .document(widget.currentUserID)
  .get().then((doc) async{

      if(doc.exists){
              await requestVolunteersRef
              .document(widget.requestID)
              .collection('requestVolunteersList')
              .document(widget.currentUserID)
              .setData({
                'volunteerID':widget.currentUserID,
                'volunteerPic':doc['profilepic'],
                'volunteerFirstName':doc['firstname'],
                'volunteerLastName':doc['lastname'],
                'volunteerMobileNum':doc['mobilenum'],
                'volunteerEmail':doc['emailaddress'],
                'date':DateTime.now()
              });

      await Firestore.instance.collection('requestList')
      .document(widget.requestID).get().then((data) async {
        if(doc.exists){

               await Firestore.instance.collection('notifications')
              .document(data['requestOwnerID'])
              .collection('requestNotificationList')
              .document(widget.currentUserID)
              .setData({
                  'volunteerFirstName':doc['firstname'],
                  'volunteerLastName':doc['lastname'],
                  'textNotif':'has volunteered to',
                  'requestTitle':data['requestTitle'],
                  'requestID':widget.requestID,
                  'requestPhoto':data['requestPhoto'],
                  'requestOwnerID':data['requestOwnerID'],
                  'date':DateTime.now()
              });


              await Firestore.instance.collection('acceptedRequest')
              .document(widget.currentUserID)
              .collection('listOfAcceptedRequest')
              .document(widget.requestID)
              .setData({
                    'requestOwnerID':data['requestOwnerID'],
                    'requestTitle':data['requestTitle'],
                    'requestID':widget.requestID,
                    'requestPhoto':data['requestPhoto'],
                    'requestSchoolName':data['requestSchoolName'],
                    'date':DateTime.now()
              });
        }
      });   setState(() {
              showSpinner = false;
              isAccepted = true;
            });
        
         
      }
  });
  }

  if(isAccepted == true){
    requestVolunteersRef
              .document(widget.requestID)
              .collection('requestVolunteersList')
              .document(widget.currentUserID)
              .get().then((doc){
                  if(doc.exists){
                    doc.reference.delete();
                  }
              });

              Firestore.instance.collection('notifications')
              .document(widget.requestOwnerID)
              .collection('requestNotificationList')
              .document(widget.currentUserID)
              .get().then((doc){
                  if(doc.exists){
                    doc.reference.delete();
            
        
                  }
                  
              });

              Firestore.instance.collection('acceptedRequest')
              .document(widget.currentUserID)
              .collection('listOfAcceptedRequest')
              .document(widget.requestID)
              .get().then((doc){
                if(doc.exists){
                  doc.reference.delete();

                           setState(() {
                          showSpinner = false;
                          isAccepted = false;
                        });
                }
              });

             
  }


}



  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
          child: Scaffold(
        appBar:appBar(txtTitle: "Request Details"),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(15.0),
          child: isOwner ? wideButton(buttonText: "EDIT REQUEST",
          onPressed: ()=>Navigator.push(context,
          MaterialPageRoute(builder: (context)=>
          EditRequestScreen(requestID: widget.requestID,requestOwnerID: widget.requestOwnerID,)))
          )
          : wideButton(buttonText: isAccepted ? "CANCEL" : "VOLUNTEER",
          onPressed: ()async{
            setState(() {
              showSpinner = true;
            });
            await handleVolunteer();
          },
          ),
        ),
        
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: requestListRef.document(widget.requestID).get(),
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return circularProgress();
              }
              return                  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(children: <Widget>[
                  Container(
                  height: 350,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(snapshot.data['requestPhoto']),
                      fit: BoxFit.cover
                    )
                  ),
                ),

            

                ],),
                
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(snapshot.data['requestTitle'],
                  style: TextStyle(
                      fontFamily: 'Montserrat-Bold',
                      fontSize: 24,
                  ),
                 ),
                ),
                 Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Posted on ${DateFormat.yMMMEd().format(snapshot.data['dateposted'].toDate())}",
                  style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      fontSize: 16,
                  ),
                 ),
                ),
                
                   Container(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>
                    ProfilePageSchool(currentUserID: widget.currentUserID,schoolID: snapshot.data['requestOwnerID'] ,))),
                                    child: Text("by ${snapshot.data['requestSchoolName']}",
                    style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        fontSize: 16,
                        color:Colors.deepOrange
                    ),
                 ),
                  ),
              ),
              Row(
                children: <Widget>[
                        Container(
                  padding: EdgeInsets.all(10),
                  child: isOwner ? InkWell(
                    onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllVolunteersScreen(requestID: snapshot.data['requestID'],requestOwner: snapshot.data['requestSchoolName'],requestTitle: snapshot.data['requestTitle'],requesOwnerID:snapshot.data['requestOwnerID'] ,))),
                                    child: Text("$volunteerCount Volunteer(s) (Tap to view all volunteers)",
                    style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        fontSize: 15,
                        color: Colors.deepOrange
                    ),
                 ),
                  ) :
                   Text("$volunteerCount Volunteer(s) ",
                    style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        fontSize: 15,
                        color: Colors.deepOrange
                    ),
                 ),
                ),

                 
                ],
              ),
               
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.calendar_today,size: 28,color:Colors.grey[300]),
                   
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                         
                          Text(snapshot.data['requestDateStart'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat-Bold'
                          ),
                          ),
                          SizedBox(height: 10,),
                            Text(snapshot.data['requestTimeStart'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Montserrat-Regular'
                          ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                              Icon(Icons.location_on,size: 28,color:Colors.grey[300]),
                    SizedBox(width: 10,),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                 
                    Text(snapshot.data['requestSchoolName'],
                    style:TextStyle(fontFamily: 'Montserrat-Regular',fontSize: 16,fontWeight: FontWeight.bold)
                    ,),
                       SizedBox(height: 10,),
                            Text(snapshot.data['requestAddress'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Montserrat-Regular'
                          ),
                          ),
                           SizedBox(height: 10,),
                            InkWell(
                              onTap: ()async{
                                double lat = snapshot.data['location']['latitude'];
                                 double long = snapshot.data['location']['longitude'];
                                  var googleUrl =  'https://www.google.com/maps/search/?api=1&query=$lat,$long';
                                            if (await canLaunch(googleUrl)) {
                                            await launch(googleUrl);
                                            } else {
                                            throw 'Could not open the map.';
                                            }
                              },
                              child: Text("View Directions",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepOrange,
                              fontFamily: 'Montserrat-Regular'
                          ),
                          ),
                            )
                        ],
                      ),
                    )
                   
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:10,right: 10,top: 10),
                child: Divider(height: 10,thickness: 1,),
              ),
                 Container(
                  padding: EdgeInsets.only(top:30,left: 10,right: 10),
                  child: Text("Details",
                  style: TextStyle(
                      fontFamily: 'Montserrat-Bold',
                      fontSize: 20,
                  ),
                 ),
                ),
                  Container(
                  padding: EdgeInsets.only(top:15,left: 10,right: 10,bottom: 15),
                  child: Text(snapshot.data['requestDetails'],
                  style: TextStyle(
                      fontFamily: 'Montserrat-Regular',
                      fontSize: 16,
                      color: Colors.grey
                  ),
                 ),
                ),
                  Padding(
                padding: EdgeInsets.only(left:10,right: 10,top: 10),
                child: Divider(height: 10,thickness: 1,),
              ),
                Container(
                  padding: EdgeInsets.only(top:30,left: 10,right: 10),
                  child: Text("Other Photos",
                  style: TextStyle(
                      fontFamily: 'Montserrat-Bold',
                      fontSize: 20,
                  ),
                 ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:30,left: 10,right: 10,bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute
                          (builder: (context)=>PhotoViewerScreen(
                            imgPath: snapshot.data['requestPhoto1'],
                            requestID: widget.requestID,
                          )));
                        },
                                            child: Container(
                          width: 100,
                          height: 100,
                     
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(snapshot.data['requestPhoto1']),
                              fit: BoxFit.cover
                            )
                          )
                        ),
                      ),
                          GestureDetector(
                                 onTap: (){
                          Navigator.push(context, MaterialPageRoute
                          (builder: (context)=>PhotoViewerScreen(
                            imgPath: snapshot.data['requestPhoto2'],
                            requestID: widget.requestID,
                          )));
                        },
                                                    child: Container(
                        width: 100,
                        height: 100,
                     
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(snapshot.data['requestPhoto2']),
                              fit: BoxFit.cover
                            )
                        )
                      ),
                          ),
                          GestureDetector(
                                 onTap: (){
                          Navigator.push(context, MaterialPageRoute
                          (builder: (context)=>PhotoViewerScreen(
                            imgPath: snapshot.data['requestPhoto3'],
                            requestID: widget.requestID,
                          )));
                        },
                                                    child: Container(
                        width: 100,
                        height: 100,
                     
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(snapshot.data['requestPhoto3']),
                              fit: BoxFit.cover
                            )
                        )
                      ),
                          ),
                    ],
                  ),
                ),
            
                
                    Padding(
                padding: EdgeInsets.only(left:10,right: 10,top: 10),
                child: Divider(height: 10,thickness: 1,),
              ),
              
                Padding(
                  padding: const EdgeInsets.only(top:5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.report, size:24, color:Colors.red),
                      isOwner ?   InkWell(
                        onTap: ()async{
                          setState(() {
                            showSpinner = true;
                          });

                              await pastRequestRef.document(widget.currentUserID)
                            .collection('listOfPastRequest')
                            .document(widget.requestID)
                            .get().then((doc){
                              if(doc.exists){
                                doc.reference.delete();
                              }
                            });
                         await userRequestListRef.document(widget.currentUserID)
                         .collection('listOfUserRequest')
                         .document(widget.requestID)
                         .get().then((doc){
                           if(doc.exists){
                             doc.reference.delete();
                             
                             
                           }
                         });
                            
                       
               

                        await requestListRef.document(widget.requestID)
                        .get().then((doc){
                          if(doc.exists){
                             FirebaseStorage.instance.ref().child(doc['requestPhoto1']);
                             FirebaseStorage.instance.ref().child(doc['requestPhoto2']);
                             FirebaseStorage.instance.ref().child(doc['requestPhoto3']);
                             FirebaseStorage.instance.ref().child(doc['requestPhoto']);
                            doc.reference.delete();
                            if(!mounted)
                             setState(() {  
                               showSpinner = false;
                             });
                             Navigator.pop(context);
                          }
                        });

                        },
                        child:   Text("Delete Request",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Montserrat-Regular'
                            ),
                            ),
                      ):
                      InkWell(
                        onTap: (){
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context)=>ReportScreen(
                            currentUserID: widget.currentUserID,
                            requestID: widget.requestID,
                            requestOwnerID: snapshot.data['requestOwnerID'],
                            requestTitle: snapshot.data['requestTitle'],
                            )));
                        },
                        child:   Text("Report",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Montserrat-Regular'
                            ),
                            ),
                      )
                    
                    ],
                  ),
                ),
              
              
            ]
        ,);
            }

          ),
        ),
      ),
    );
    
  }
}