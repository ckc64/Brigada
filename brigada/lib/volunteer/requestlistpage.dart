import 'package:brigada/widgets/reusablewidgets.dart' as prefix0;
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../requestdetailpage.dart';

class RequestListPage extends StatefulWidget {
    final currentUserID,currentLocCity;

  const RequestListPage({Key key, this.currentUserID, this.currentLocCity}) : super(key: key);
  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {

  Future getRequestListCardsFromFirebase() async {
  QuerySnapshot querySnapshot =
      await Firestore.instance.collection('requestList')
      .where("requestCity",isGreaterThanOrEqualTo:widget.currentLocCity).getDocuments();

  return querySnapshot.documents;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: prefix0.appBar(txtTitle: "Request Near Your City"),
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
                          return UserRequestList(
                            requestOwnerID: snapshot.data[index].data['requestOwnerID'],
                            currentUserID: widget.currentUserID,
                            requestID: snapshot.data[index].data['requestID'],
                            requestTitle:
                                snapshot.data[index].data['requestTitle'],
                            imgPath: snapshot.data[index].data['requestPhoto'],
                            schoolAddress:
                                snapshot.data[index].data['requestAdress'],
                            schoolName: snapshot.data[index].data['requestSchoolName'],
                          );
                        });
                  }),
    );
  }


 
}

 class UserRequestList extends StatelessWidget {
  final String requestTitle, imgPath, schoolName, schoolAddress,requestID,currentUserID,requestOwnerID;

  const UserRequestList(
      {Key key,
      this.requestTitle,
      this.imgPath,
      this.schoolAddress,
      this.schoolName,
      this.requestID, this.currentUserID, this.requestOwnerID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
              onTap: () {
                              Navigator.push(context, MaterialPageRoute
                              (builder: (context)=> RequestDetailPage(requestID: requestID,
                              currentUserID: currentUserID,
                              requestOwnerID: requestOwnerID,
                              )
                              ));
                              
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
                        height: 96.0,
                        width: 96.0,
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
                      width: 200,
                        child: Text(
                      requestTitle.toUpperCase(),
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
                          
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "$schoolName",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    )),
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