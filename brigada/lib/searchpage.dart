import 'package:brigada/requestdetailpage.dart';
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  final currentUserID;

  const SearchPage({Key key, this.currentUserID}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
     Future<QuerySnapshot> searchResultFuture;
   TextEditingController searchController = TextEditingController();
final accountsRef = Firestore.instance.collection('requestList');
  handleSearch(String query){
      Future<QuerySnapshot> users = accountsRef
      .where("requestSchoolName",isGreaterThanOrEqualTo:query)
      .getDocuments();
      
      setState(() {
        searchResultFuture = users; 
      });

  }
  clearSearch(){
    searchController.clear();
  }

   Future getUserRequestListCardsFromFirebase() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('requestList')
        .getDocuments();

    return querySnapshot.documents;
  }

  AppBar buildSearchField(){
    return AppBar(
        backgroundColor: Colors.deepOrange,
        title: TextFormField(
          style: TextStyle(color: Colors.white),
          controller: searchController,
          decoration: InputDecoration(
            
            hintText: "Search for a school...",
            hintStyle: TextStyle(fontFamily: 'Montserrat-Regular',color:Colors.white),
            filled: true,
            
            prefixIcon: Icon(
              Icons.library_books,
              color:Colors.white,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear,color: Colors.white,),
              onPressed: ()=>searchController.clear(),
            )
          ),
          onFieldSubmitted: handleSearch,
        )
    );
  }
  Container buildNoContent(){
    return Container(
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

    buildSearchResults(){
    return FutureBuilder(
      future:searchResultFuture,
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return circularProgress();
        }
        List<Container> searchResults = [];
        snapshot.data.documents.forEach((doc){
         
          searchResults.add(
          Container(
            color:Colors.deepOrange,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: ()=> Navigator.push(context, MaterialPageRoute
                              (builder: (context)=> RequestDetailPage(requestID: doc['requestID'],
                              currentUserID: widget.currentUserID,
                              requestOwnerID: doc['requestOwnerID'],
                              )
                              )),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(doc['requestPhoto']),
                    ),
                    title: Container(
                      width: 200,
                     child: Text(doc['requestTitle'],
                        style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    )
                    ),
                  
                    ),
                    subtitle: Text(doc['requestSchoolName'],style: TextStyle(color: Colors.white),),
                  ),
                ),
                Divider(height: 2.0,color: Colors.white54,)
              ],
            ),
          )
          );
        });
        return ListView(
            children: searchResults
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: buildSearchField(),
         body: searchResultFuture == null ? buildNoContent()
        : buildSearchResults(),
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

