import 'package:brigada/notfoundscreen.dart';
import 'package:brigada/widgets/reusablewidgets.dart' as prefix0;
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../requestdetailpage.dart';

class NotificationSchoolScreen extends StatefulWidget {
    final currentUserID;

  const NotificationSchoolScreen({Key key, this.currentUserID}) : super(key: key);
  @override
  _NotificationSchoolScreenState createState() => _NotificationSchoolScreenState();
}

class _NotificationSchoolScreenState extends State<NotificationSchoolScreen> {

  Future getRequestListCardsFromFirebase() async {
  QuerySnapshot querySnapshot =
      await Firestore.instance.collection('notifications').document(widget.currentUserID)
      .collection('requestNotificationList').getDocuments();

  return querySnapshot.documents;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: prefix0.appBar(txtTitle: "Notifications"),
        body:  FutureBuilder(
                  future: getRequestListCardsFromFirebase(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          return RequestList(
                            date: (timeago.format(snapshot.data[index].data['date'].toDate())),
                            requestOwnerID: snapshot.data[index].data['requestOwnerID'],
                            currentUserID: widget.currentUserID,
                            requestID: snapshot.data[index].data['requestID'],
                            requestTitle:
                                snapshot.data[index].data['requestTitle'],
                            imgPath: snapshot.data[index].data['requestPhoto'],
                            notifText: snapshot.data[index].data['textNotif'],
                            volunteerFname: snapshot.data[index].data['volunteerFirstName'],
                            volunteerLname: snapshot.data[index].data['volunteerLastName'],
                          );
                        });
                  }),
    );
  }


 
}

 class RequestList extends StatelessWidget {
  final String requestTitle, imgPath, requestID,currentUserID,
  requestOwnerID,volunteerFname,volunteerLname,notifText,date;

  const RequestList(
      {Key key,
      this.requestTitle,
      this.imgPath,

      this.requestID, this.currentUserID, this.requestOwnerID, this.volunteerFname,
       this.volunteerLname, this.notifText, this.date})
      : super(key: key);

    
  @override
  Widget build(BuildContext context) {
      
    return GestureDetector(
              onTap: () async{

                    await Firestore.instance.collection('requestList')
                    .document(requestID)
                    .get().then((doc)async{
                      if(doc.exists) {
                           Navigator.push(context, MaterialPageRoute
                              (builder: (context)=> RequestDetailPage(requestID: requestID,
                              currentUserID: currentUserID,
                              requestOwnerID: requestOwnerID,
                              )
                              ));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>NotFoundScreen(currentUser: currentUserID,requestID: requestID,requestOwnerID: requestOwnerID,)));

                      }
                    });
                           
                              
                            },
          child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
        child: Container(
          child: Material(
            color: Colors.grey[100],
            elevation: 0,
            borderRadius: BorderRadius.circular(5),
            child: Row(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: new CachedNetworkImage(
                        imageUrl: imgPath,
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => circularProgress(),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: Text(
                          '$volunteerFname $volunteerLname'
                      ,
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              notifText,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              requestTitle.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            ),
                           
                          ],
                        ),
                      ],
                    )
                    ),
                     Text(
                              date,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 13, color: Colors.black),
                            ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}