import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_sms/simple_sms.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_sms/flutter_sms.dart';


class SendSmsScreen extends StatefulWidget {
  final requestTitle,requestOwner,requestOwnerID,requestID;

  const SendSmsScreen({Key key, this.requestTitle, this.requestOwner, this.requestOwnerID, this.requestID}) : super(key: key);
@override
_SendSmsScreenState createState() => new _SendSmsScreenState();
}

class _SendSmsScreenState extends State<SendSmsScreen> {
TextEditingController txtMessageController = new TextEditingController();


bool showSpinner = false;

void _sendSMS(String message, List<String> recipents) async {
 String _result = await FlutterSms
        .sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
print(_result);
}

@override
Widget build(BuildContext context) {
    return ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Scaffold(
        appBar: appBar(txtTitle: "SEND SMS"),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
          
                      Container(
                        width: 500,
                   padding: const EdgeInsets.only(top:25,left:25,right: 25),
                   child: Text("Update volunteers for possible changes about your request.",
                    style: TextStyle(
                   
                    fontFamily: 'Montserrat-Regular',
                        fontSize: 16,
                    color:Colors.deepOrange
                    ),
                ),
                 ),

                     Container(
                        width: 500,
                   padding: const EdgeInsets.only(top:25,left:25,right: 25),
                   child: Text("Enter your message",
                    style: TextStyle(
                   
                    fontFamily: 'Montserrat-Bold',
                        fontSize: 20,
                    color:Colors.deepOrange
                    ),
                ),
                 ),
                
                Padding(
                  padding: const EdgeInsets.only(left:25,right: 25),
                  child: TextFormField(
                    
                    controller: txtMessageController,
                    maxLines: 5,
                    style: TextStyle(
           
                      fontSize: 20
                      
                    ),
                    
                  
                  ),
                ),
        

                     Padding(
                          padding: EdgeInsets.only(left:25,right:25,top:30),
                          child: wideButton(
                            buttonText: 'PROCEED',
                            onPressed: () async {
                               
                          QuerySnapshot result = await Firestore.instance.collection('requestVolunteers')
                                   .document(widget.requestID)
                                   .collection('requestVolunteersList')
                                    .getDocuments();

                                       List<DocumentSnapshot> doc = result.documents;
                                      var recipients = List<String>();
                           
                          
                             doc.forEach((doc){
                                 recipients.add(doc.data['volunteerMobileNum']);
                             });
                                  String message = "Message from Brigada App \n\nRequest Title : ${widget.requestTitle} \n\nMessage : ${txtMessageController.text} \n\nby ${widget.requestOwner}";
                                _sendSMS(message, recipients);
                          
                                txtMessageController.clear();
                                  
                            }
                          )
                        ),
              ],
            ),
          )
        ),
      ),
    );
  }
}