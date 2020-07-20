import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRequestScreen extends StatefulWidget {
  final requestID,requestOwnerID;

  const EditRequestScreen({Key key, this.requestID, this.requestOwnerID}) : super(key: key);
  @override
  _EditRequestScreenState createState() => _EditRequestScreenState();
}

class _EditRequestScreenState extends State<EditRequestScreen> {
  bool showPinner = false;
  TextEditingController txtRequestTitleController = new TextEditingController();
  TextEditingController txtRequestDetailController = new TextEditingController();
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

  getRequestData() async {
      await Firestore.instance.collection('requestList')
      .document(widget.requestID).get().then((data){
          setState(() {
            txtRequestTitleController.text = data['requestTitle'];
            txtRequestDetailController.text = data['requestDetails'];
           
           
          });
      });

  }

  @override
  void initState() { 
    getRequestData();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
          inAsyncCall: showPinner,
          child: Scaffold(
        appBar: appBar(txtTitle: "Edit Request"),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                   Padding(
                   padding: const EdgeInsets.only(top:50,left:25),
                   child: Text("Request Title",
                    style: TextStyle(
                   
                    fontFamily: 'Montserrat-Regular',
                        fontSize: 20,
                    color:Colors.deepOrange
                    ),
                ),
                 ),
                
                Padding(
                  padding: const EdgeInsets.only(left:25,right: 25),
                  child: TextFormField(
                    controller: txtRequestTitleController,
                    maxLength: 100,
                    style: TextStyle(
                      fontSize: 20
                    ),
                    
                    decoration: InputDecoration(hintText: "Enter your request title"),
                  ),
                ),

                //

                      Padding(
                   padding: const EdgeInsets.only(top:25,left:25),
                   child: Text("Request Details",
                    style: TextStyle(
                   
                    fontFamily: 'Montserrat-Regular',
                        fontSize: 20,
                    color:Colors.deepOrange
                    ),
                ),
                 ),
                
                Padding(
                  padding: const EdgeInsets.only(left:25,right: 25),
                  child: TextFormField(
                    controller: txtRequestDetailController,
                    maxLength: 255,
                    style: TextStyle(
                      fontSize: 20
                    ),
                    
                    decoration: InputDecoration(hintText: "Enter your request details"),
                  ),
                ),
        //
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 25),
                  child: Text(
                    "Date and Time",
                    style: TextStyle(
                      
                        fontFamily: 'Montserrat-Regular',
                        fontSize: 20,
                        color: Colors.deepOrange),
                  ),
                ),

                  Padding(
                  padding: const EdgeInsets.only(left:25.0,right:25.0,top:20),
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

                Padding(
                  padding: const EdgeInsets.only(left:25.0,right:25.0,top:10),
                  child: Row(
                    children: <Widget>[
                      
                    ],
                  ),
                ),

                     Padding(
                          padding: EdgeInsets.only(left:25,right:25,top:30),
                          child: wideButton(
                            buttonText: 'UPDATE REQUEST',
                            onPressed: () async{
                            setState(() {
                              showPinner = true;
                            });
                              final difference = _date.difference(DateTime.now()).inDays;
                           
                           if(_date == null || _time == null){
                               setState(() {
                                showPinner = false;
                              });
                             showDialogWarning(context, "Date or Time cannot be empty.");
                           }else if(DateFormat.yMMMEd().format(_date) == DateFormat.yMMMEd().format(DateTime.now())){
                               setState(() {
                                showPinner = false;
                              });
                             showDialogWarning(context, "Date cannot be the same as todays date");
                           }else if(difference < 0){
                              setState(() {
                                showPinner = false;
                              });
                              showDialogWarning(context, "Invalid date or date has already passed");
                           }else if(txtRequestTitleController.text == "" || txtRequestDetailController.text == ""){
                              setState(() {
                                showPinner = false;
                              });
                             showDialogWarning(context, "Request title or request details should not be empty");
                           }else{
                                      await Firestore.instance.collection('requestList')
                                      .document(widget.requestID)
                                      .updateData({
                                          'requestTitle':txtRequestTitleController.text,
                                          'requestDetails':txtRequestDetailController.text,
                                          'requestDateStart':DateFormat.yMMMEd().format(_date),
                                          'requestTimeStart':convertToDateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute)
                                      });

                                         await Firestore.instance.collection('userRequestList')
                                      .document(widget.requestOwnerID)
                                      .collection('listOfUserRequest')
                                      .document(widget.requestID)
                                      .updateData({
                                          'requestTitle':txtRequestTitleController.text,
                                          'requestDetails':txtRequestDetailController.text,
                                          'requestDateStart':DateFormat.yMMMEd().format(_date),
                                          'requestTimeStart':convertToDateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute)
                                      });
                                      setState(() {
                                        showPinner = false;
                                      });
                                      Navigator.pop(context);
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