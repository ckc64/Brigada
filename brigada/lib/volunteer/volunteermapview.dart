import 'dart:async';
import 'package:brigada/widgets/spinner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerMapView extends StatefulWidget {
  double currentLat,currentLong;

  VolunteerMapView({Key key, this.currentLat, this.currentLong}) : super(key: key);
  @override
  VolunteerMapViewState createState() => VolunteerMapViewState();
}

class VolunteerMapViewState extends State<VolunteerMapView> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> allMarkers ;
Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {

    populateMarker();
    super.initState(); 
  }

populateMarker(){
    Firestore.instance
    .collection('requestList')
    .getDocuments()
    .then((docs){
      if(docs.documents.isNotEmpty){
        for(int i = 0; i < docs.documents.length; ++i){
          initMarker(docs.documents[i].data,docs.documents[i].documentID);
        }
      }
    });
  }

  void initMarker(request,requestID){
    var markIdVal = requestID;
    final MarkerId markerId = MarkerId(markIdVal);
    //creating a new marker
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(request['location']['latitude'],request['location']['longitude']),
      infoWindow: InfoWindow(title: request['requestTitle'],snippet: request['requestSchoolName'])
    );
    setState(() {
        markers[markerId] = marker;
        
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
    
          _buildContainer(),
        ],
      ),
    );
  }

  Future getRequestListCardsFromFirebase() async {
  QuerySnapshot querySnapshot =
      await Firestore.instance.collection('requestList').getDocuments();

  return querySnapshot.documents;
}

List<Widget> boxes;
  
  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child:  Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                  future : getRequestListCardsFromFirebase(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData){
                      return circularProgress();
                    }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, int index) {
                          return UserRequestList(
                            onTap:() {
                              _gotoLocation(snapshot.data[index].data['location']['latitude'], snapshot.data[index].data['location']['longitude']);
                            
                            },
                            requestOwnerID: snapshot.data[index].data['requestOwnerID'],
                           
                            requestID: snapshot.data[index].data['requestID'],
                            requestTitle:
                                snapshot.data[index].data['requestTitle'],
                            imgPath: snapshot.data[index].data['requestPhoto'],
                            schoolAddress:
                                snapshot.data[index].data['requestAdress'],
                            schoolName: snapshot.data[index].data['requestSchoolName'],
                          );
                        });
                  },
              ),
              
           
            ),
      ),
    );
  }


  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:  CameraPosition(target: LatLng(7.4235695999999995, 125.82254189999999), zoom: 8.0),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values)
      ),
    );
  }

  Set<Marker> _createMarker({String markerID,String markerTitle,double lat,double long}){
    return <Marker>[
      Marker(
        markerId: MarkerId(markerID),
        position: LatLng(lat,long),
        icon:BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: markerTitle)
      ),
    ].toSet();
  }

  Future<void> _gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
  }
}

class UserRequestList extends StatelessWidget {
  final String requestTitle, imgPath, schoolName, schoolAddress,requestID,currentUserID,requestOwnerID;
  final double lat,long;
  final onTap;

  const UserRequestList(
      {Key key,
      this.requestTitle,
      this.imgPath,
      this.schoolAddress,
      this.schoolName,
      this.requestID, this.currentUserID, this.requestOwnerID, this.onTap, this.lat, this.long})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
              onTap: onTap,
          child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Container(
          child: Material(
            color: Colors.grey[100],
            elevation: 0,
            borderRadius: BorderRadius.circular(16),
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
