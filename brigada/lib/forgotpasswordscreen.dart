import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

    TextEditingController txtEmailController = TextEditingController();


  bool showSpinner = false;



  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Scaffold(
        appBar: appBar(txtTitle: "Forgot Password"),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
           
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "The link for resetting your password will be send to your provided gmail account.",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat-Regular'
                      ),
                  ),
                  
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10,left:25,right: 25),
                  child: TextFormField(
                    controller: txtEmailController,
                    style: TextStyle(
                      fontSize: 16
                    ),
                    
                    decoration: InputDecoration(hintText: "Enter Email Address",
                     border: OutlineInputBorder()),
                  ),
                ),

                     Padding(
                          padding: EdgeInsets.only(left:25,right:25,top:30),
                          child: wideButton(
                            buttonText: 'SEND',
                            onPressed: () async {
                           setState(() { 
                                      showSpinner = true;
                                    });
                                if(txtEmailController.text == ""){
                                  showDialogWarning(context, "Email must be provided");
                                  setState(() {
                                    showSpinner = false;
                                  });
                                }else{
                                  try{

                                     await FirebaseAuth.instance
                                   .sendPasswordResetEmail(email: txtEmailController.text.trim());
                                
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  Navigator.pop(context);
                                   showDialogWarning(context, "Password reset link has been sent to your email");
                                   

                                  }on PlatformException{
                                     setState(() {
                                    showSpinner = false;
                                    showDialogWarning(context, "Email Doesn't exist");
                                  });
                                  }
                                  
                                }
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