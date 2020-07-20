import 'package:brigada/fadeanimation.dart';
import 'package:brigada/firstscreens/registrationscreens/nameregistrationscreen.dart';
import 'package:brigada/home.dart';
import 'package:brigada/volunteer/volunteerregistration/volunteeraddprofile.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerPhoneNum extends StatefulWidget {
  @override
  _VolunteerPhoneNumState createState() => _VolunteerPhoneNumState();
}

class _VolunteerPhoneNumState extends State<VolunteerPhoneNum> {
  String phoneNo;
  String smsCode;
  String verificationId;
  bool loadingSpinner = false;
  String uid;

  //Fire Store
  final userRef = Firestore.instance.collection('userProfile');

  Future<void> verifyPhone() async {
    if (this.phoneNo.isEmpty) {
      showDialogWarning(context, "Please fill the fields");
    } else if (this.phoneNo.substring(0, 1) == "0") {
      showDialogWarning(context, "Please check the number you entered");
    } else if (this.phoneNo.length > 13 || this.phoneNo.length < 13) {
      showDialogWarning(context, "Entered Mobile Number is invalid");
    } else {
      setState(() {
        loadingSpinner = true;
      });
      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        this.verificationId = verId;
      };

      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        this.verificationId = verId;
        smsCodeDialog(context).then((value) {
      
        });
      };

      final PhoneVerificationCompleted verifiedSuccess =
          (AuthCredential credential) {
          
      
          Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VolunteerAddProfile()));

      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException exception) {
        showDialogWarning(context, "${exception.message}");
        setState(() {
          loadingSpinner = false;
        });
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verificationFailed,
      );
    }
  }



  Future<bool> smsCodeDialog(BuildContext context) {
    setState(() {
      loadingSpinner = false;
    });
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter Verification Code'),
            content: TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.all(40.0),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'DONE',
                  style: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  setState(() {
                    loadingSpinner = false;
                  });
                  FirebaseAuth.instance.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  Future<bool> smsCodeDialogErrorCode(BuildContext context) {
    setState(() {
      loadingSpinner = false;
    });
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('INVALID CODE'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.all(40.0),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'TRY AGAIN',
                  style: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => VolunteerPhoneNum()));
                },
              )
            ],
          );
        });
  }

  verifiedUserDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text(
              'Verified',
              textAlign: TextAlign.center,
            ),
            content: Icon(
              Icons.check_circle_outline,
              color: Colors.deepOrange,
              size: 50,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'PROCEED',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                splashColor: Colors.deepOrange,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VolunteerAddProfile()));
                },
              )
            ],
          );
        });
  }

  signIn() async {
    setState(() {
      loadingSpinner = true;
    });
    //  try{

    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);

    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      print('Sign in success');
      verifiedUserDialog(context);
    }).catchError((FirebaseAuthInvalidCredentialsException) {
      smsCodeDialogErrorCode(context);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: loadingSpinner,
        color: Colors.deepOrange,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(1.8,
                           Center(
                  child:
                      HeaderTitle(textColor: Colors.deepOrange, textSize: 50.0)),
            ),
            FadeAnimation(1.8,
                          Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: subHeaderTitle(txtTitle: 'Enter your mobile number'),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 15),
                  child: Text(
                    "+63",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(right: 25),
                      child: FadeAnimation(1.8, 
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
                                 onChanged: (value) {
                         this.phoneNo = "+63" + value;
                        },
	                            decoration: InputDecoration(
	                              border: InputBorder.none,
	                              hintText: "Ex. 9123456789",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
                  
	                    
	                      ],
	                    ),
	                  )
                  ),
                
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 25),
            FadeAnimation(1.8,
                         Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  child: wideButton(

                      //verifyPhone
                      buttonText: 'Verify',
                      onPressed: () {
                        setMobileNum(this.phoneNo);
                        verifyPhone();
                      })),
            ),

 
          ],
        ),
      ),
    );
  }
}
