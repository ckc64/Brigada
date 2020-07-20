
import 'package:brigada/fadeanimation.dart';
import 'package:brigada/school/addrequestscreens/requestdetailsscreen.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';

class RequestTitleScreen extends StatefulWidget {
  @override
  _RequestTitleScreenState createState() => _RequestTitleScreenState();
}

class _RequestTitleScreenState extends State<RequestTitleScreen> {

  TextEditingController txtRequestTitleController = new TextEditingController();
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
                     child: Text("Request Title",
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
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
                      controller: txtRequestTitleController,
                      maxLength: 100,
                      style: TextStyle(
                        fontSize: 20
                      ),
                      decoration: InputDecoration(hintText: "Enter your request title",border: InputBorder.none),
                    ),
                  ),
                ),
                FadeAnimation(1.8,
                                   Padding(
                            padding: EdgeInsets.only(left:25,right:25,top:30),
                            child: wideButton(
                              buttonText: 'NEXT',
                              onPressed: (){
                                if(txtRequestTitleController.text.isEmpty){
                                    showDialogWarning(context, "Request title cannot be empty");
                                }else{
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RequestDetailsScreen()));
                                  setRequestTitle(txtRequestTitleController.text);
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