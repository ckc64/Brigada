import 'dart:core';
import 'package:brigada/fadeanimation.dart';
import 'package:brigada/school/addrequestscreens/requestfinalscreen.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:intl/intl.dart';

class RequestTimeAndDateScreen extends StatefulWidget {
  @override
  _RequestTimeAndDateScreenState createState() =>
      _RequestTimeAndDateScreenState();
}

class _RequestTimeAndDateScreenState extends State<RequestTimeAndDateScreen> {

 DateTime _date = DateTime.now();
 TimeOfDay _time = TimeOfDay.now();

Future<Null> _selectDate(BuildContext context) async{
  final DateTime picked = await showDatePicker(
    context: context, 
    initialDate: _date, 
    firstDate: new DateTime(2020), 
    lastDate: new DateTime(2100)
  );

  if(picked != null && picked != _date){

    setState(() {
      _date = picked;
    });
    print('Date Selected : ${DateFormat.yMMMEd().format(_date)}');
  }
}
 Future<Null> _selectTime(BuildContext context) async{
   final TimeOfDay picked = await showTimePicker(
       initialTime:_time,
     context: context,

   );

   if(picked != null && picked != _time){

     setState(() {
       _time = picked;

     });
     print('Time Selected : ${_time.toString()}');
   }
 }

 String convertToDateTime(int y, int m, int d, int h, int min){
     DateTime dateSelected = DateTime(y,m,d,h,min);
     return DateFormat.jm().format(dateSelected);
 }


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
                    padding: const EdgeInsets.only(top: 80, left: 25),
                    child: Text(
                      "Date and Time",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat-Bold',
                          fontSize: 40,
                          color: Colors.deepOrange),
                    ),
                  ),
                ),
          
                FadeAnimation(1.8
                                  ,Padding(
                    padding: const EdgeInsets.only(left:25.0,right:25.0,top:40),
                    child: ButtonTheme(
                                minWidth: double.infinity,
                                height: 55,
                                
                                child: FlatButton(
                                shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                               
                              ),
                                color: Colors.grey[300],
                                textColor: Colors.white,
                                splashColor: Colors.deepOrange[900],
                                
                                onPressed: (){_selectDate(context);},
                                child: Text(
                                  DateFormat.yMMMEd().format(_date),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontFamily: 'Montserrat-Regular'
                                  ),
                                ),
                              ),
                            ),
                  ),
                ),

                 FadeAnimation(1.8,
                                     Padding(
                    padding: const EdgeInsets.only(left:25.0,right:25.0,top:10),
                    child: ButtonTheme(
                                minWidth: double.infinity,
                                height: 55,
                                
                                child: FlatButton(
                                shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                               
                              ),
                              
                                color: Colors.grey[300],
                                textColor: Colors.white,
                                splashColor: Colors.deepOrange[900],
                                
                                onPressed: (){_selectTime(context);},
                                child: Text(
                                  convertToDateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute),
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontFamily: 'Montserrat-Regular'
                                  ),
                                ),
                              ),
                            ),
                ),
                 ),
               FadeAnimation(1.8,
                                  Padding(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 30),
                      child: wideButton(
                          buttonText: 'NEXT',
                          onPressed: () {
                              final difference = _date.difference(DateTime.now()).inDays;
                             
                             if(_date == null || _time == null){
                               showDialogWarning(context, "Date or Time cannot be empty.");
                             }else if(DateFormat.yMMMEd().format(_date) == DateFormat.yMMMEd().format(DateTime.now())){
                               showDialogWarning(context, "Date cannot be the same as todays date");
                             }else if(difference < 0){
                                showDialogWarning(context, "Invalid date or date has already passed");
                             }
                             else{
                               Navigator.pushReplacement(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) => RequestFinalScreen()));
                            
                               setDate(DateFormat.yMMMEd().format(_date));
                               setTime(convertToDateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute));
                             }

                           
                          })),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
