

import 'package:brigada/fadeanimation.dart';
import 'package:brigada/school/addrequestscreens/requesttimeanddatescreen.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';

class RequestDetailsScreen extends StatefulWidget {
  @override
  _RequestDetailsScreenState createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
   TextEditingController txtRequestDetailsController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
              child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 FadeAnimation(1.8,
                                     Padding(
                     padding: const EdgeInsets.only(top:100,left:25),
                     child: Text("Request Details",
                      style: TextStyle(
                        fontFamily: 'Montserrat-Bold',
                          fontSize: 70,
                      color:Colors.deepOrange
                      ),
                ),
                   ),
                 ),
                
               FadeAnimation(1.8,
                                  Padding(
                    padding: const EdgeInsets.only(top:50,left:25,right: 25),
                    child: TextFormField(
                      maxLength: 255,
                      controller: txtRequestDetailsController,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 20
                      ),
                   decoration: InputDecoration(hintText: "Enter your request details",border: InputBorder.none),
                   
                    ),
                  ),
                ),
                FadeAnimation(1.8
                                  ,Padding(
                            padding: EdgeInsets.only(left:25,right:25,top:30),
                            child: wideButton(
                              buttonText: 'NEXT',
                              onPressed: (){
                                if(txtRequestDetailsController.text.isEmpty){
                                  showDialogWarning(context, "Request Details cannot be empty.");
                                }else{
                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RequestTimeAndDateScreen()));
                                   setRequestDetails(txtRequestDetailsController.text);
                                }
                                 
                              }
                            )
                          ),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}