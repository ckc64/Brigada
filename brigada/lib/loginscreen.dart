
import 'package:brigada/forgotpasswordscreen.dart';
import 'package:brigada/school/schoolhomescreen.dart';
import 'package:brigada/signupasscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fadeanimation.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
   final currentLoc;
  double currentLat,currentLong;

  LoginScreen({Key key, this.currentLoc,this.currentLat,this.currentLong}) : super(key: key);

 
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailControllerLogin = TextEditingController();
  TextEditingController passwordControllerLogin = TextEditingController();

  bool showSpinner = false;
  SharedPreferences prefs;





  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){},
          child: Scaffold(
        
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
                child: SingleChildScrollView(
          	child: Container(
	        child: Column(
	          children: <Widget>[
	            Container(
	              height:   270,
	    
                       
	                  child: FadeAnimation(1.6, Container(
	                  
	                      child: Padding(
	                        padding: const EdgeInsets.only(top:100),
	                        child: Center(
	                          child:  HeaderTitle(textColor: Colors.deepOrange, textSize: 50.0)
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
                                  controller: emailControllerLogin,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "emailaddress@gmail.com",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
	                        Container(
	                          padding: EdgeInsets.all(8.0),
	                          child: TextField(
                                  controller: passwordControllerLogin,
	                            obscureText: true,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Password",
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
                            buttonText: "LOGIN",
                            onPressed: () async{
                              
                                if(emailControllerLogin.text == "" || passwordControllerLogin.text == ""){
                                  showDialogWarning(context, "Email or password is empty");
                                }else{
                                  try{

                                    setState(() {
                                      showSpinner = true;
                                    });

                                   await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(email: emailControllerLogin.text.trim(), 
                                    password: passwordControllerLogin.text.trim());

                                    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
                                  prefs = await SharedPreferences.getInstance();
                                    
                                    if(currentUser  != null){
                                    
                                     prefs.setString("email", emailControllerLogin.text.trim());
                                       prefs.setString("password", passwordControllerLogin.text.trim());
                                       prefs.setString("uid", currentUser.uid);
                           
                                     

                                      await Firestore.instance.collection("accounts")
                                      .document(currentUser.uid).get().then((doc){
                                     
                                        
                                          if(doc.exists){
                                            if(doc["userType"] == "SCHOOL"){
                                                setState(() {
                                                  showSpinner = false;
                                                });
                                                
                                           
                                      
                                              Navigator.pushReplacement(context, 
                                              MaterialPageRoute(builder: (context)=>
                                              SchoolHomeScreen(currentUserID: currentUser.uid,)
                                              )
                                            );
                                            }else if(doc['userType'] == "VOLUNTEER"){
                                       
                                                
                                                 Navigator.pushReplacement(context, 
                                              MaterialPageRoute(builder: (context)=>
                                              Home(currentUserID: currentUser.uid,
                                              currentLat: widget.currentLat,
                                              currentLong: widget.currentLong,
                                              currentLoc: widget.currentLoc,
                                              
                                              )
                                              )
                                            );
                                            }
                                            
                                          }
                                      });
                                    }

                                    
                                  }on PlatformException{
                                showDialogWarning(context,'Email or Password is incorrect or Some other device is signed in');
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                                }
                            }
                          ),
                          
	                  )
                        ),
	                  SizedBox(height: 10,),
	                  FadeAnimation(1.5, 
                    InkWell(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordScreen())),
                      child: Text("Forgot Password?", 
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontFamily: 'Montserrat-Regular',
                        fontSize: 16
                      ),
                    ),
                    )),
                         SizedBox(height: 40,),
                        FadeAnimation(1.5, InkWell(
                          child: Text("Sign up here", 
                          style:TextStyle(
                        color: Colors.deepOrange,
                        fontFamily: 'Montserrat-Regular',
                        fontSize: 16
                      ),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpAsScreen()));
                          },
                      )
                    ,),
	                ],
	              ),
	            )
	          ],
	        ),
	      ),
          ),
        )
      ),
    );
  }
}