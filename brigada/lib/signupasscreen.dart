import 'package:brigada/loginscreen.dart';
import 'package:brigada/school/schoolregistration/schoolnamereg.dart';
import 'package:brigada/volunteer//volunteerregistration/volunteername.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';

import 'fadeanimation.dart';

class SignUpAsScreen extends StatefulWidget {
  @override
  _SignUpAsScreenState createState() => _SignUpAsScreenState();
}

class _SignUpAsScreenState extends State<SignUpAsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: SingleChildScrollView(
      	child: SafeArea(
                  child: Container(
	        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
	          children: <Widget>[
              FadeAnimation(1.6, IconButton(
                onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen())),
                icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
              ),
            ),
              
	            Container(
	              height:   270,
	    
                   
	                  child: FadeAnimation(1.6, Container(
	                  
	                      child: Padding(
	                        padding: const EdgeInsets.only(top:100),
	                        child: Center(
	                          child:  HeaderTitle(textColor: Colors.white, textSize: 50.0)
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
	                          child:  Text('SIGN UP AS',
              style: TextStyle(
                color: Colors.white,
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
	            
	                 
	                  FadeAnimation(2, 
                    Container(
                      child: ButtonTheme(
                            minWidth: double.infinity,
                            height: 55,
                            
                            child: FlatButton(
                            
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                            borderRadius: new BorderRadius.circular(5.0),
                            
                           
                          ),
                            color: Colors.deepOrange,
                            textColor: Colors.white,
                            splashColor: Colors.deepOrange[900],
                            
                            onPressed: (){
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>VolunteerName()));
                              setUserType("VOLUNTEER");
                            },
                            child: Text(
                              "VOLUNTEER",
                              style: TextStyle(
                                fontFamily: 'Montserrat-Regular',
                                fontSize: 15.0,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      
	                  )
                    
                    ),
                            SizedBox(height: 10,),
	                  FadeAnimation(2, 
                    Container(
                      child: ButtonTheme(
                            minWidth: double.infinity,
                            height: 55,
                            
                            child: FlatButton(
                            
                            shape: RoundedRectangleBorder(
                            
                            borderRadius: new BorderRadius.circular(5.0),
                            
                           
                          ),
                            color: Colors.white,
                            textColor: Colors.deepOrange,
                            splashColor: Colors.deepOrange[900],
                            
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolNameRegistration()));
                              setUserType("SCHOOL");
                            },
                            child: Text(
                              "SCHOOL",
                              style: TextStyle(
                                fontSize: 15.0,
                                 fontFamily: 'Montserrat-Regular',
                                color: Colors.deepOrange
                              ),
                            ),
                          ),
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