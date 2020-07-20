import 'package:brigada/chatpages/chatscreen.dart';
import 'package:brigada/school/schoolhomescreen.dart';
import 'package:brigada/widgets/reusablewidgets.dart';
import 'package:brigada/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


String currentLoggedInID,currentLoggedInEmail;

class ChatFeed extends StatefulWidget {
  final currentUserID;

  const ChatFeed({Key key, this.currentUserID}) : super(key: key);
  @override
  _ChatFeedState createState() => _ChatFeedState();
}

class _ChatFeedState extends State<ChatFeed> {

    getChatFeed() async{
      final chatFeedRef = Firestore.instance.collection('chatfeed');
   QuerySnapshot snapshot = await chatFeedRef
      .document(widget.currentUserID)
      .collection('chatfeeditem')
      .orderBy('timestamp',descending: true)
      .getDocuments();
      List<ChatFeedItem>feedItems = [];
    snapshot.documents.forEach((doc){
      feedItems.add(ChatFeedItem.fromDocument(doc));
    });
    return feedItems;
  }
  
getCurrentIDandEmail() async{
  await FirebaseAuth.instance.currentUser().then((user){
      setState(() {
        currentLoggedInID = user.uid;
        currentLoggedInEmail = user.email;
      });
        
  });
}
@override
void initState() { 
       getCurrentIDandEmail();
  super.initState();
 
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(txtTitle: "Messages"),
      body: Container(
        child: FutureBuilder(
          future: getChatFeed(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return circularProgress();
            }
           return ListView(
             children: snapshot.data,
           );
          },
        ),
      ),
    );
  }
}

class ChatFeedItem extends StatelessWidget {

  final String username;
  final String receiverId;
   final String senderId;
  final String messageData;
  final String schoolName;
  final Timestamp timestamp;

  const ChatFeedItem({Key key, this.username, 
  this.receiverId,this.senderId,
  this.messageData, this.timestamp, this.schoolName}) : super(key: key);




  factory ChatFeedItem.fromDocument(DocumentSnapshot doc){
    return ChatFeedItem(
      username: doc['username'],
      schoolName:doc['schoolName'],
      receiverId: doc['receiverID'],
      messageData: doc['message'],
      timestamp: doc['timestamp'],
      senderId: doc['sender']
    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom:2.0),
      child:  Container(
            color:Colors.deepOrange,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(profileID: senderId == currentLoggedInID ? receiverId:senderId,)));
            
                 },
                  child: ListTile(
               
                    title: Text(username,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    subtitle: Text(messageData,style: TextStyle(color: Colors.white),),
                  ),
                ),
                Divider(height: 2.0,color: Colors.white54,)
              ],
            ),
          ),
    );
  }
}