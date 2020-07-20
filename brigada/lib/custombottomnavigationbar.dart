import 'package:flutter/material.dart';

class CustomBottomNavigationItem{

  Icon icon;
  Text text;

  CustomBottomNavigationItem({this.icon,this.text});

}

List<CustomBottomNavigationItem> bottomItem = [ 
    CustomBottomNavigationItem(icon: Icon(Icons.home,size: 20),text: Text("Home")),
    CustomBottomNavigationItem(icon: Icon(Icons.search,size: 20),text: Text("Search")),
   
    CustomBottomNavigationItem(icon: Icon(Icons.map,size: 20),text: Text("Requests")),
    CustomBottomNavigationItem(icon: Icon(Icons.person_outline,size: 20,),text: Text("Profile")),
];