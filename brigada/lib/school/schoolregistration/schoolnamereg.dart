import 'package:brigada/school/schoolregistration/mapsearch.dart';
import 'package:brigada/fadeanimation.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';

class SchoolNameRegistration extends StatefulWidget {
  @override
  _SchoolNameRegistrationState createState() => _SchoolNameRegistrationState();
}

class _SchoolNameRegistrationState extends State<SchoolNameRegistration> {
TextEditingController schoolNameController = TextEditingController();

   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(txtTitle: 'School Name'),
        body: SingleChildScrollView(
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
	                          child:  Text('School Name',
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
	                  FadeAnimation(1.8, 
                    Container(
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
                         
	                          child: TextField(
                              controller: schoolNameController,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Enter complete school name",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
                  
	                    
	                      ],
	                    ),
	                  )
                  ),
	                  SizedBox(height: 30,),
	                  FadeAnimation(2, 
                    Container(
                      child: wideButton(
                        buttonText: "NEXT",
                        onPressed: (){
                              if(schoolNameController.text.isEmpty){
                                showDialogWarning(context,"Please fill all the fields.");
                            }else{
                                    setSchoolName(schoolNameController.text);
                                    
                                 
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MapSearch()));
                      
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
      )
  
    );
  }
}