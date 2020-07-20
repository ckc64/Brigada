import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:brigada/widgets/reusablewidgets.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'fadeanimation.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

    TextEditingController passwordControllerLogin = TextEditingController();
 TextEditingController passwordConfirmControllerLogin = TextEditingController();
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(txtTitle: "Change Password"),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
              child: SingleChildScrollView(
        	child: Container(
	        child: Column(
	          children: <Widget>[
	          Container(
	              height:   150,
	    
                     
	                  child: FadeAnimation(1.6, Container(
	                  
	                      child: Padding(
	                        padding: const EdgeInsets.only(top:80),
	                        child: Center(
	                          child:  Text('Change Password',
              style: TextStyle(
                color: Colors.deepOrange,
                fontFamily: 'FredokaOne',
                fontSize: 35,
              ),

              ),
	                        ),
	                      ),
	                    )),
	                  
	            
	            ),
                    Container(
	                  child: FadeAnimation(1.6, Container(
	                  
	
	                        child: Padding(
	                          padding: const EdgeInsets.only(left:30,right:30),
	                          child: Center(
	                            child:  Text('*Note : This is a sensitve operation you must be recently login.',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Montserrat-Regular',
                fontSize: 15,
              ),

              ),
	                          ),
	                        ),
	                      
	                    )),
	                  
	            
	            ),
	            Padding(
	              padding: EdgeInsets.all(30.0),
	              child: Column(
	                children: <Widget>[
	                  FadeAnimation(1.8, Container(
	                    padding: EdgeInsets.all(5),
	                    decoration: BoxDecoration(
	                      color: Colors.white,
	                      borderRadius: BorderRadius.circular(10),
	                      boxShadow: [
	                        BoxShadow(
	                          color: Color.fromRGBO(143, 148, 251, .2),
	                          blurRadius: 20.0,
	                          offset: Offset(0, 10)
	                        )
	                      ]
	                    ),
	                    child: Column(
	                      children: <Widget>[
	                        Container(
	                          padding: EdgeInsets.all(8.0),
	                          decoration: BoxDecoration(
	                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
	                          ),
	                          child: TextField(
                                controller: passwordControllerLogin,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Enter your new password",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
	                        Container(
	                          padding: EdgeInsets.all(8.0),
	                          child: TextField(
                                controller: passwordConfirmControllerLogin,
	                            obscureText: true,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Enter confirm password",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        )
	                      ],
	                    ),
	                  )),
	                  SizedBox(height: 30,),
	                  FadeAnimation(2, 
                      Container(
                        child: wideButton(
                          buttonText: "CHANGE PASSWORD",
                          onPressed: () async{
                            setState(() {
                              showSpinner = true;
                            });
                              if(passwordConfirmControllerLogin.text == "" || passwordControllerLogin.text == ""){
                                setState(() {
                              showSpinner = false;
                            });
                                showDialogWarning(context, "Fill all the fields");
                              }else if(passwordConfirmControllerLogin.text  != passwordControllerLogin.text){
                                 setState(() {
                              showSpinner = false;
                            });
                                 showDialogWarning(context, "Password doesn't match");
                              }else{
                                        try{

                           FirebaseUser user = await FirebaseAuth.instance.currentUser();
                         //Pass in the password to updatePassword.
                          user.updatePassword(passwordConfirmControllerLogin.text).then((_){
                            setState(() {
                             showSpinner = false;
                            });
                            confirmAlertDialog("Password changed successfully", 
                              "Try to login your account again"
                              );
                           
                          }).catchError((error){
                              setState(() {
                             showSpinner = false;
                            });
                          showDialogWarning(context,"Password can't be change. Try logging in again" 
                           
                            );
                          });

                      }catch(PlatformException){
                          setState(() {
                             showSpinner = false;
                            });
                           showDialogWarning(context,"Password can't be change. Try logging in again" 
                           
                            );
                      }
                              }
                          }
                        ),
                        
	                  )
                      ),
	              
            
	                ],
	              ),
	            )
	          ],
	        ),
	      ),
        ),
      )
    );
  }

   confirmAlertDialog(text,content){
    return showDialog(
       context: context,
        barrierDismissible: false,
        
        builder: (BuildContext context) {
          return new  AlertDialog( 
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.all(40.0),
          title: Text(text),
          content:  Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed:(){
                Navigator.pop(context);
                setState(() {
                  passwordConfirmControllerLogin.text ="";
                  passwordControllerLogin.text = "";
                });
                
              } ,
            )
          ],
          );
        }
     ); 
  }
}