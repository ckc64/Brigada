import 'package:brigada/fadeanimation.dart';
import 'package:brigada/loginscreen.dart';
import 'package:brigada/signupasscreen.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:brigada/widgets/reusablewidgets.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';



class SchoolRegistrationFinalScreen extends StatefulWidget {
  @override
  _SchoolRegistrationFinalScreenState createState() => _SchoolRegistrationFinalScreenState();
}


 TextEditingController passwordController  = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController  = TextEditingController();

    //firestore
    final accountsRef = Firestore.instance.collection('accounts');

  //spinner
  bool showSpinner = false;

class _SchoolRegistrationFinalScreenState extends State<SchoolRegistrationFinalScreen> {

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(txtTitle: 'Finish Registration'),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.deepOrange,
    
              child: SingleChildScrollView(
        	child: Container(
	        child: Column(
	          children: <Widget>[
           
	            Container(
	              height:   180,
	    
                     
	                  child: FadeAnimation(1.6, Container(
	                  
	                      child: Padding(
	                        padding: const EdgeInsets.only(top:100),
	                        child: Center(
	                          child:  HeaderTitle(textColor: Colors.deepOrange, textSize: 50.0)
	                        ),
	                      ),
	                    )),
	                  
	            
	            ),
                             Container(
	 
	    
                     
	                  child: FadeAnimation(1.6,
                       Container(
	                  
	                      child: Padding(
	                        padding: const EdgeInsets.only(top:50),
	                        child: Center(
	                          child:  Text('FINAL REGISTRATION',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 18.0,
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
                                controller: emailController,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "schoolemailaddress@gmail.com",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
                                Container(
                                       decoration: BoxDecoration(
	                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
	                          ),
	                          padding: EdgeInsets.all(8.0),
	                          child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Password",
	                              hintStyle: TextStyle(color: Colors.grey[400]),
                                  
	                            ),
	                          ),
	                        ),
                                  Container(
                                    
	                          padding: EdgeInsets.all(8.0),
	                          child: TextFormField(
                                controller: confirmPasswordController,
                                obscureText: true,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Confirm Password",
	                              hintStyle: TextStyle(color: Colors.grey[400]),
                                  
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
                          buttonText: "REGISTER",
                          onPressed: () async{
                            if(passwordController.text != confirmPasswordController.text){
                             showDialogWarning(context, "Password doesn't match");
                            }else{
                          
                            setState(() {
                              showSpinner = true;
                            });
                         

                                if(getSchoolName() == null || getSchoolAddress() == null
                                || getLatitude() == null || getLongitude() == null
                                || getCity() == null ){
                                    showDialogWarning(context, "Some of the data is empty. Please try again");
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpAsScreen()));
                                    setState(() {
                                      showSpinner = false;
                                    });
                                }else{
   try{
                                  
    await FirebaseAuth.instance
    .createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

   await accountsRef.document(firebaseUser.uid).setData({
        'schoolName':getSchoolName(),
        'schoolAddress':getSchoolAddress(),
        'city':getCity(),
        'locationpoint':{
          'latitude':getLatitude(),
          'longitude':getLongitude(),
        },
        'schoolEmailAddress':emailController.text,
        'userType':getUserType(),
        'username':getSchoolName()
    });
     clearPreferences();

        setState(() {
          showSpinner = false;
        });
        

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    
    }on PlatformException{
      showDialogWarning(context,"Email is already in use or invalid email address");
    }

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
}

addToSchoolAccounts(BuildContext context) async{
  

    
    

}

