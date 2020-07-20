import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ReportScreen extends StatefulWidget {
  final requestID,requestTitle,requestOwnerID,currentUserID;

  const ReportScreen({Key key, this.requestID, this.requestTitle, this.requestOwnerID, this.currentUserID}) : super(key: key);
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  TextEditingController txtSubjectController = TextEditingController();
  TextEditingController txtReasonController = TextEditingController();

  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Scaffold(
        appBar: appBar(txtTitle: "Report"),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
          
                
        
           
                //

                      Padding(
                   padding: const EdgeInsets.only(top:25,left:25),
                   child: Text("Reason",
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
                    
                    controller: txtReasonController,
                    maxLength: 255,
                    style: TextStyle(
           
                      fontSize: 20
                    ),
                    
                    decoration: InputDecoration(hintText: "Report Reason"),
                  ),
                ),
        //
         
        

              

                     Padding(
                          padding: EdgeInsets.only(left:25,right:25,top:30),
                          child: wideButton(
                            buttonText: 'SEND REPORT',
                            onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });

                                final Email email = Email(
                                  body: "Request ID : ${widget.requestID}\n Request Owner ID : ${widget.requestOwnerID}\n Sender ID : ${widget.currentUserID} \n\n Reason : ${txtReasonController.text}",
                                  subject: "Report for ${widget.requestTitle}",
                                  recipients: ['bayanihanapp@gmail.com'],
                                  isHTML: false
                                );

                                await FlutterEmailSender.send(email);
                                setState(() {
                                  showSpinner = false;
                                });
                                Navigator.pop(context);
                                   showDialogWarning(context, "Report has been sent");
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