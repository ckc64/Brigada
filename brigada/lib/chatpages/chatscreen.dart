import 'package:brigada/chatpages/chatfeed.dart';
import 'package:brigada/chatpages/constants.dart';
import 'package:brigada/school/schoolhomescreen.dart';
import 'package:brigada/widgets/preferences.dart';
import 'package:brigada/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:brigada/school/profilepageschool.dart';
FirebaseAuth fAuth = FirebaseAuth.instance;
  final messageRef = Firestore.instance.collection('messages');
  final chatfeedRef = Firestore.instance.collection('chatfeed');
  final userRef = Firestore.instance.collection('accounts');

String currentLoggedInID,currentLoggedInEmail;

class ChatScreen extends StatefulWidget {
  final profileID;

  const ChatScreen({Key key, this.profileID}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

     TextEditingController messageController = TextEditingController();
    String messageTxt;
     Timestamp timestamp;

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
         appBar:AppBar(
           
        leading: null,
        actions: <Widget>[
          
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
        title: StreamBuilder(
            stream: userRef.document(widget.profileID).snapshots(),
            builder: (context,snapshots){
              if(!snapshots.hasData){
                return circularProgress();
              }
                  return ListTile(
         
            title:GestureDetector(
              onTap: (){},
              child: Text(
                snapshots.data['username'],
                style: TextStyle(
                  color:Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
                );
            },
          ),
        backgroundColor: Colors.deepOrange,
      ),
      body:SafeArea(
         
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(profileID: widget.profileID),
            
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: kMessageTextFieldDecoration,
                      onChanged: (value){
                        messageTxt = value;
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () async{
                     
                      await userRef.document(widget.profileID).get().then((doc){
                          if(doc.exists){

                             messageRef.document(currentLoggedInID)
                       .collection('conversation')
                       .document('receivers')
                       .collection(widget.profileID)
                       .document()
                       .setData({
                          "sender":currentLoggedInEmail,
                          "message":messageTxt,
                          "receiver":widget.profileID,
                          "timestamp":DateTime.now(),
                      
                          "username":doc.data['username']
                       });

                      
                         messageRef.document(widget.profileID)
                        .collection('conversation')
                        .document('receivers')
                        .collection(currentLoggedInID)
                        .document()
                        .setData({
                          "sender":currentLoggedInEmail,
                          "message":messageTxt,
                          "receiver":widget.profileID,
                          "timestamp":DateTime.now(),
                   
                          "username":doc.data['username']
                       });

                       chatfeedRef
                       .document(currentLoggedInID)
                       .collection('chatfeeditem')
                       .document(widget.profileID)
                       .setData({
                         "sender":currentLoggedInEmail,
                          "profpic":doc.data['profpic'],
                          "username":doc.data['username'],
                          "message":messageTxt,
                          "timestamp":DateTime.now(),
                          "receiverID":widget.profileID,
                          "sender":currentLoggedInID
                       });

                         userRef.document(currentLoggedInID).get().then((doc1){
                              if(doc1.exists){
                                       chatfeedRef
                          .document(widget.profileID)
                          .collection('chatfeeditem')
                          .document(currentLoggedInID)
                          .setData({
                         "sender":currentLoggedInEmail,
                          "profpic":doc1.data['profpic'],
                          "username":doc1.data['username'],
                          "message":messageTxt,
                          "timestamp":DateTime.now(),
                          "receiverID":widget.profileID,
                             "sender":currentLoggedInID
                       });
                              }
                          });
                  

                          }
                      });
                       
                       messageController.clear();
                         
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final profileID;

  const MessagesStream({Key key, this.profileID}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
              stream: messageRef.document(currentLoggedInID)
              .collection('conversation')
              .document('receivers')
              .collection(this.profileID).orderBy('timestamp',descending: true).snapshots(),
              builder: (context,snapshots){
                if(!snapshots.hasData){
                    return circularProgress();
                }
                final messages = snapshots.data.documents;
                List<MessageBubble>messageBubbles = [];
                for(var message in messages){
                    final messageText = message.data['message'];
                    final sender = message.data['sender'];
                    final time = message.data['timestamp'];
                    final currentUser = currentLoggedInEmail;
                    final messageBubble = MessageBubble(
                      sender: sender,
                      text: messageText,
                      isMe: currentUser==sender,
                      timestamp: time,
                      );
                    messageBubbles.add(messageBubble);
                }
                return Expanded(
                     child: ListView(
                       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                       reverse: true,
                    children:messageBubbles,
                  ),
                );
              },
            );
  }
}

class MessageBubble extends StatelessWidget {

  final String sender,text;
  final bool isMe;
  final Timestamp timestamp;
  const MessageBubble({Key key, this.sender, this.text,this.isMe, this.timestamp}) : super(key: key);

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30.0) 
            ,bottomRight: Radius.circular(30.0)):BorderRadius.only(topRight: Radius.circular(30),bottomLeft: Radius.circular(30.0) 
            ,bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.deepOrange : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                  child: Text(
              "$text",
              style: TextStyle(
                  color: isMe? Colors.white : Colors.black,
                  fontSize: 15.0,
              ),
            ),
                ),
          ),
            Text(timeago.format(timestamp.toDate()),
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.black45
            )
            ,)
        ],
      ),
    );
  }
}