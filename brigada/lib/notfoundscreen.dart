
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NotFoundScreen extends StatefulWidget {

final requestID,requestOwnerID,currentUser;

  const NotFoundScreen({Key key, this.requestID, this.requestOwnerID, this.currentUser}) : super(key: key);
  @override
  _NotFoundScreenState createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {

bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
          child: Scaffold(
          appBar: AppBar(
            title: Text("Error",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat-Regular',
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  await Firestore.instance.collection('acceptedRequest')
                          .document(widget.currentUser)
                          .collection('listOfAcceptedRequest')
                          .document(widget.requestID)
                          .get().then((doc){
                              if(doc.exists){
                                doc.reference.delete();
                                
                              
                                Navigator.pop(context);
                              }
                          });

                               await Firestore.instance.collection('requestVolunteers')
                            .document(widget.requestID)
                            .collection('requestVolunteersList')
                            .document(widget.currentUser)
                            .get().then((data){
                                if(data.exists){
                                  data.reference.delete();
                                }
                            });
                  
                       QuerySnapshot result = await Firestore.instance.collection('notifications')
                         .document(widget.requestOwnerID)
                         .collection('requestNotificationList')
                         .getDocuments();
                        
                          List<DocumentSnapshot> doc = result.documents;
                            doc.forEach((doc){
                               if(doc.data['requestID'] == widget.requestID){
                                 doc.reference.delete();
                                
                               }
                           });

                            if(!mounted)return;
                                     setState(() {
                                        showSpinner = false;
                                    });
                                    Navigator.pop(context);
                },
                icon: Icon(Icons.delete_outline),
              )
            ],
          ),
          body: SingleChildScrollView(
            
            child: SafeArea(
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: double.infinity,
                                  child: Center(
                                    
                                    child:Text(
                                      
                      "DATA NOT FOUND OR DELETED",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        
                        fontSize: 50.0,
                        color:  Colors.grey[300],
                        fontFamily: 'Montserrat-Bold',
                 
                      ),
                    ),
                  

              
            
                                  ),
                                ),
                ),
           
          ),
        ),
    );
  }
 
}