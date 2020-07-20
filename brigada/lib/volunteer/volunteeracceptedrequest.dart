import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:brigada/widgets/reusablewidgets.dart' as prefix0;
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../notfoundscreen.dart';
import '../requestdetailpage.dart';

class VolunteerAcceptedRequest extends StatefulWidget {
  final currentUserID;

  const VolunteerAcceptedRequest({Key key, this.currentUserID}) : super(key: key);
  @override
  _VolunteerAcceptedRequestState createState() => _VolunteerAcceptedRequestState();
}

class _VolunteerAcceptedRequestState extends State<VolunteerAcceptedRequest> {

    Future getUserRequestListCardsFromFirebase() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('acceptedRequest')
        .document(widget.currentUserID)
        .collection('listOfAcceptedRequest')
        .getDocuments();

    return querySnapshot.documents;
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: appBar(txtTitle: "Accepted Request"),
      body: FutureBuilder(
                  future: getUserRequestListCardsFromFirebase(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          return RequestList(
                            requestOwnerID: snapshot.data[index].data['requestOwnerID'],
                           currentUserID: widget.currentUserID,
                            requestID: snapshot.data[index].data['requestID'],
                            requestTitle:
                                snapshot.data[index].data['requestTitle'],
                            imgPath: snapshot.data[index].data['requestPhoto'],
                           
                            schoolName: snapshot.data[index].data['requestSchoolName'],
                          );
                        });
                  }),
      
    );
  }
}
class RequestList extends StatelessWidget {
  final String requestTitle, imgPath, schoolName,requestID,requestOwnerID,currentUserID;

  const RequestList(
      {Key key,
      this.requestTitle,
      this.imgPath,
      this.schoolName,
      this.requestID, this.requestOwnerID,this.currentUserID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
  
              onTap: () async{
               
                    await Firestore.instance.collection('requestList')
                    .document(requestID)
                    .get().then((doc)  async{
                      if(doc.exists){
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
                    )
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

