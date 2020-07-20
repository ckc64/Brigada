import 'dart:math';

import 'package:brigada/custombottomnavigationbar.dart';
import 'package:brigada/home_background.dart';
import 'package:brigada/requestdetailpage.dart';
import 'package:brigada/searchpage.dart';
import 'package:brigada/volunteer/requestlistpage.dart';
import 'package:brigada/volunteer/volunteerProfile.dart';
import 'package:brigada/volunteer/volunteermapview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:brigada/widgets/spinner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'package:timeago/timeago.dart' as timeago;

import 'fadeanimation.dart';

class Home extends StatefulWidget {
  final currentUserID,currentLoc;
  double currentLat,currentLong;

  Home({Key key, this.currentUserID, this.currentLoc,this.currentLat,this.currentLong}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final requestRef = Firestore.instance.collection('requestList');
  final userRef = Firestore.instance.collection('accounts');
  String currentLocCity;


  int requestLength;

  

  getCurrentCityLocation() async{
Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
     List<Placemark> placemarks = 
     await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
     Placemark placemark = placemarks[0];
    String currentCity = "${placemark.locality}";
 if (!mounted) return;
    setState(() {
      
      currentLocCity = currentCity;
    });
  }



  buildNoRequest() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "No Request Found",
        style: TextStyle(fontSize: 20.0, color: Colors.grey),
      ),
    );
  }

//bottomnvbar
  Widget buildItem(CustomBottomNavigationItem item, bool isSelected) {
    return Container(
      height: 40.0,
      width: isSelected ? 125.0 : 50.0,
      decoration: isSelected
          ? ShapeDecoration(shape: StadiumBorder(), color: Colors.deepOrange)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconTheme(
                data: IconThemeData(
                    size: 20.0,
                    color: isSelected ? Colors.white : Colors.grey[500]),
                child: item.icon),
            SizedBox(
              width: 5.0,
            ),
            DefaultTextStyle.merge(
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat-Regular',
                    fontSize: 16.0),
                child: isSelected ? item.text : Container())
          ],
        ),
      ),
    );
  }

  int currentIndex = 0; //for bottomnav
  List<Widget> pages;
  PageController _pageController;
  int selectedIndex = 0; //forpageview
  
 

  @override
  void initState() {
    
    super.initState();
    getCurrentCityLocation();
   
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: selectedIndex);
  }

  Future getRequestListCardsFromFirebase() async {
  QuerySnapshot querySnapshot =
      await Firestore.instance.collection('requestList')
      .where("requestCity",isGreaterThanOrEqualTo:currentLocCity).getDocuments();

  return querySnapshot.documents;
}


String currentUsername;
bool isOwnerName;
  _definePages() {
    pages = [
      Stack(
        children: <Widget>[
          HomeBackground(
            screenHeight: MediaQuery.of(context).size.height,
          ),
          FutureBuilder(
            future: userRef.document(widget.currentUserID).get(),
              builder:(context, snapshot){
                 
                if(!snapshot.hasData){
                  return circularProgress();
                }
               
                 return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>RequestListPage(currentUserID: widget.currentUserID,currentLocCity: widget.currentLoc,))),
                            icon: Icon(Icons.list),
                            iconSize: 30,
                            color: Colors.white70,
                            splashColor: Colors.deepOrange[600],
                          ),
                        )),
                    FadeAnimation(1.8,
                                         Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "Hi, "+snapshot.data['firstname'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat-Bold'),
                        ),
                      ),
                    ),
                    FadeAnimation(1.8,
                                          Padding(
                        padding: EdgeInsets.only(left: 70),
                        child: Text(
                          "What's good in",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat-Light'),
                        ),
                      ),
                    ),
                    FadeAnimation(1.8,
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 150),
                        child: Text(
                          widget.currentLoc == null ? "your city" : widget.currentLoc,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat-Bold'),
                        ),
                      ),
                    ),

                    //Search Bar
                    SizedBox(height: 10.0),
                    FadeAnimation(1.8,
                                           Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: TextFormField(
                            onTap: () => Navigator.push(context, 
                            MaterialPageRoute(builder: (context)=>SearchPage())
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Request",
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 28.0,
                                color: Colors.grey,
                              ),
                            ),
                            // onFieldSubmitted: handleSearch,
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: getRequestListCardsFromFirebase(),
                      builder: (context,snapshot){
                        if(!snapshot.hasData){
                          return circularProgress();
                        }
                          return Column(
                           
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                     Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 20,left:20),
                        child: FadeAnimation(1.8,
                                                 Text(
                            "REQUEST IN YOUR CITY (${snapshot.data.length == 0 ? 0 : selectedIndex+1}/${snapshot.data.length})",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                         FadeAnimation(1.8,
                                                     Container(
                      height: 330.0,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        onPageChanged: (_selectedIndex) {
                            setState(() {
                              selectedIndex = _selectedIndex;
                            });
                        },
                        physics: BouncingScrollPhysics(),
                        itemCount:snapshot.data.length,
                        itemBuilder: (context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute
                                (builder: (context)=> RequestDetailPage(requestID: snapshot.data[index].data['requestID'],currentUserID: widget.currentUserID,)
                                ));
                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 24.0,
                                        top: (index - selectedIndex)
                                                .abs()
                                                .toDouble() *
                                            24,
                                        bottom: (index - selectedIndex)
                                                .abs()
                                                .toDouble() *
                                            24),
                                    width: 300.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(snapshot.data[index].data['requestPhoto']),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                                      ),
                                    ),
                                  ),
                            
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SizedBox(height: 60,),
                                            Icon(Icons.location_on,
                                                size: 16, color: Colors.white),
                                                SizedBox(width: 5),
                                            Container(
                                              width: 200,
                                              child: Text(
                                                  snapshot.data[index].data['requestAddress'],
                                                  
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontFamily:
                                                          'Montserrat-Regular')),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 150,
                                        ),
                                        Container(
                                          width: 240.0,
                                          child: Text(
                                              snapshot.data[index].data['requestTitle'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontFamily: 'Montserrat-Bold')),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 250.0,
                                          child: Text(timeago.format(snapshot.data[index].data['dateposted'].toDate()),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily:
                                                      'Montserrat-Regular')),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(

                                          width: 250.0,
                                          child: Text("Posted by ${snapshot.data[index].data['requestSchoolName']}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      'Montserrat-Regular')),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                        },
                      ),
                    ),
                         ),
                          ],
                        );
                          
                          
                     
                     
                       }               
                       
                    
                    ),
                   
                  ],
                ),
                 
              ),
            );
              }
                     
          )
        ],
      ),
      SearchPage(currentUserID: widget.currentUserID,),
     VolunteerMapView(),
     VolunteerProfile(currentUserID: widget.currentUserID,)
     //ProfilePageVolunteer(currentUserID: widget.currentUserID)
    ];
  }

  @override
  Widget build(BuildContext context) {
    _definePages();

    return WillPopScope(
      onWillPop: (){},
          child: Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          height: 55.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: bottomItem.map((item) {
              int itemIndex = bottomItem.indexOf(item);
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = itemIndex;
                      print(currentIndex);
                    });
                  },
                  child: buildItem(item, currentIndex == itemIndex));
            }).toList(),
          ),
        ),
        body: pages[currentIndex],
      ),
    );
  }
}
