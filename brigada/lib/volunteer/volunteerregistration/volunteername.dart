
import 'package:brigada/fadeanimation.dart';
import 'package:brigada/volunteer/volunteerregistration/volunteeraddress.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:flutter/material.dart';
import 'package:brigada/widgets/reusablewidgets.dart';

class VolunteerName extends StatefulWidget {
  
  @override
  _VolunteerNameState createState() => _VolunteerNameState();
}


class _VolunteerNameState extends State<VolunteerName> {

  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
   bool isTeacher = false;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(txtTitle: 'Name'),
        body: Stack(
          children: <Widget>[
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

              FadeAnimation(1.8
                              ,Center(
                 child: HeaderTitle(
                   textColor: Colors.deepOrange, 
                   textSize:50.0)
                  ),
              ),
                FadeAnimation(1.8,
                                  Padding(
                    padding: const EdgeInsets.only(top: 15,bottom: 15),
                    child: subHeaderTitle(
                      txtTitle: 'Enter your name'
                    ),
                  ),
                ),
               
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left:25, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        Flexible(
                            child:       FadeAnimation(1.8, 
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
                              controller:fnameController,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Firstname",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
                  
	                    
	                      ],
	                    ),
	                  )
                  ),
                        ),
                        SizedBox(width:10.0),
                        Flexible(
                            child:  FadeAnimation(1.8, 
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
                              controller:lnameController,
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Lastname",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
                  
	                    
	                      ],
	                    ),
	                  )
                  ),
                        ),
                        ],
                      ),
                    ),
                  ),
                    
                      SizedBox(height: 25),
                      FadeAnimation(1.8,
                                             Padding(
                          padding: EdgeInsets.only(left:25,right:25,bottom:25),
                          child: wideButton(
                            buttonText: 'NEXT',
                            onPressed: (){
                             

                              if(fnameController.text.isEmpty || lnameController.text.isEmpty){
                                  showDialogWarning(context,"Please fill all the fields.");
                              }else{
                                      setFirstName(fnameController.text);
                                      setLastName(lnameController.text);
                                   
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>VolunteerAddress()));
                                  
                              }                  
                            }
                        )
                  ),
                      )
              ],
            ),
          ],
        ),
    );
  }
}