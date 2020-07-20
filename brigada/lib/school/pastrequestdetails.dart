import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:firebase_storage/firebase_storage.dart';
     
import '../photoviewerscreen.dart';

class PastRequestDetails extends StatefulWidget {
  final requestID,currentUserID;

  const PastRequestDetails({Key key, this.requestID, this.currentUserID}) : super(key: key);
  @override
  _PastRequestDetailsState createState() => _PastRequestDetailsState();
}

class _PastRequestDetailsState extends State<PastRequestDetails> {

  bool showSpinner = false;
  final pastRequestRef = Firestore.instance.collection('pastRequest');
   final requestListRef = Firestore.instance.collection('requestList');
  @override
 Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
          child: Scaffold(
        appBar:appBar(txtTitle: "Request Details"),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(15.0),
          child:  wideButton(buttonText: "DELETE REQUEST",
          onPressed: () async{
           setState(() {
             showSpinner = true;
           }); 
            await pastRequestRef.document(widget.currentUserID)
            .collection('listOfPastRequest')
            .document(widget.requestID)
            .delete();
          Navigator.pop(context);
               await requestListRef.document(widget.requestID)
                        .get().then((doc){
                          if(doc.exists){
                             FirebaseStorage.instance.ref().child(doc['requestPhoto1']);
                             FirebaseStorage.instance.ref().child(doc['requestPhoto2']);
                             FirebaseStorage.instance.ref().child(doc['requestPhoto3']);
                             FirebaseStorage.instance.ref().child(doc['requestPhoto']);
                            doc.reference.delete();
                             Navigator.pop(context);
                            if(!mounted)
                             setState(() {  
                               showSpinner = false;
                             });
                            
                          }
                        });
            Navigator.pop(context);
            setState(() {
              showSpinner = false;
            });
            
          }
         
          ),
        ),
        
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: pastRequestRef.document(widget.currentUserID)
            .collection('listOfPastRequest')
            .document(widget.requestID).get(),
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return circularProgress();
              }
              return                  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(children: <Widget>[
         
                  Column(
                    children: <Widget>[
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
                  SizedBox(height: 50),
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
                 child: Text("by ${snapshot.data['requestSchoolName']}",
                    style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        fontSize: 16,
                        color:Colors.deepOrange
                    ),
                 ),
                  
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
                    ],
                  )
            
             
            ]
                )
              ] 
                 
        ,);
            }

          ),
        ),
      ),
    );
    
  }
}