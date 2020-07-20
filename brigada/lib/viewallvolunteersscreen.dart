import 'package:brigada/sendsmsscreen.dart';
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAllVolunteersScreen extends StatefulWidget {
  final requestID,requestTitle,requestOwner,requesOwnerID;

  const ViewAllVolunteersScreen({Key key, this.requestID, this.requestTitle, this.requestOwner, this.requesOwnerID}) : super(key: key);
  @override
  _ViewAllVolunteersScreenState createState() => _ViewAllVolunteersScreenState();
}

class _ViewAllVolunteersScreenState extends State<ViewAllVolunteersScreen> {

   Future getUserRequestListCardsFromFirebase() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('requestVolunteers')
        .document(widget.requestID)
        .collection('requestVolunteersList')
        .getDocuments();

    return querySnapshot.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        "Volunteers", style: TextStyle(fontFamily: "Montserrat-Regular"),
      ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: IconButton(
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SendSmsScreen(requestTitle: widget.requestTitle,requestOwner: widget.requestOwner,requestOwnerID: widget.requesOwnerID,requestID: widget.requestID,))),
              icon: Icon(Icons.message,color: Colors.white,),),
          )
        ],
      ),
      body: Container(
        child: FutureBuilder(
                  future: getUserRequestListCardsFromFirebase(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          return VolunteersList(
                            volFname: snapshot.data[index].data['volunteerFirstName'],
                            volLname: snapshot.data[index].data['volunteerLastName'],
                            volEmail: snapshot.data[index].data['volunteerEmail'],
                            volNumber: snapshot.data[index].data['volunteerMobileNum'],
                            imgPath: snapshot.data[index].data['volunteerPic'],
                          );
                        });
                  }),
    ),
    );
  }
}


class VolunteersList extends StatelessWidget {
  final String volFname, volLname,volNumber,volEmail,imgPath;

  const VolunteersList({Key key, this.volFname, this.volLname, 
  this.volNumber, this.volEmail, this.imgPath}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return
         Padding(
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
                     "$volFname $volLname",
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
                              "$volNumber",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
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
                              "$volEmail",
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
      );
    
  }
}