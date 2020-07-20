import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
  SharedPreferences p;

setEmail(String email) async{
  p = await SharedPreferences.getInstance();
  p.setString('email_key', email);
}

getEmail(){
  String email = p.getString('email_key');
  return email;
}

setUserType(String type) async{
  p = await SharedPreferences.getInstance();
  p.setString('type_key', type);
}
getUserType(){
  String utype = p.getString('type_key');
  return utype;
}

setFirstName(String fname) async{
   p = await SharedPreferences.getInstance();
  p.setString('fname_key', fname);
}
getFname(){
  String fname = p.getString('fname_key');
  return fname;
}

setLastName(String lname) async{
   p = await SharedPreferences.getInstance();
  p.setString('lname_key', lname);
}
getLname(){
  String lname = p.getString('lname_key');
  return lname;
}

setAddress(String addr) async{
   p = await SharedPreferences.getInstance();
   p.setString('addr_key', addr);
}
getAddress(){
  String addr = p.getString('addr_key');
  return addr;
}

setMobileNum(String mnum) async{
   p = await SharedPreferences.getInstance();
   p.setString('mnum_key', mnum);
}
getMobileNum(){
    String mnum = p.getString('mnum_key');
    return mnum;
}

setPassword(String pass) async{
  p = await SharedPreferences.getInstance();
  p.setString('pass_key', pass);
}

getPassword(){
  String pass = p.getString('pass_key');
  return pass;
}

setImageLocation(String file) async{
  p = await SharedPreferences.getInstance();
  p.setString('image_key', file);
}

getImageLocation(){
  String file = p.getString('image_key');
  return file;
}

setRequestTitle(String title) async{
  p = await SharedPreferences.getInstance();
  p.setString('request_title', title);
}

getRequestTitle(){
  String reqTitle = p.getString('request_title');
  return reqTitle;
}

setRequestDetails(String details) async{
  p = await SharedPreferences.getInstance();
  p.setString('request_details', details);
}

getRequestDetails(){
  String reqDetails = p.getString('request_details');
  return reqDetails;
}

setSchoolName(String schoolname) async{
  p = await SharedPreferences.getInstance();
  p.setString('schoolname', schoolname);
}

getSchoolName(){
  String schoolname = p.getString('schoolname');
  return schoolname;
}

setSchoolAddress(String schoolAddr) async{
  p = await SharedPreferences.getInstance();
  p.setString('schoolAddr', schoolAddr);
}

getSchoolAddress(){
  String schoolAddr = p.getString('schoolAddr');
  return schoolAddr;
}

//set date/time from
setDate(String dateFrom)async{
  p = await SharedPreferences.getInstance();
  p.setString('date_from', dateFrom);
}
getDate(){
  String dateFrom = p.getString('date_from');
  return dateFrom;
}

setTime(String timeFrom) async{
   p = await SharedPreferences.getInstance();
  p.setString('time_from', timeFrom);
}
getTime(){
  String timeFrom = p.getString('time_from');
  return timeFrom;
}

setUserID(String userID) async{
  p = await SharedPreferences.getInstance();
  p.setString('id_key', userID);
}

getUserID(){
  String userID = p.getString('id_key');
  return userID;
}

setCity(String city) async{
   p = await SharedPreferences.getInstance();
  p.setString('city_key', city);
}

getCity(){
  String userID = p.getString('city_key');
  return userID;
}

//location

setLatitude(double lat) async{
  p = await SharedPreferences.getInstance();
  p.setDouble('lat_key', lat);
}
getLatitude(){
  double lat = p.getDouble('lat_key');
  return lat;
}

setLongitude(double long) async{
  p = await SharedPreferences.getInstance();
  p.setDouble('long_key', long);
}
getLongitude(){
  double long = p.getDouble('long_key');
  return long;
}

clearPreferences() async{
  await p.clear();
}



SharedPreferences p2;

setLoggedInEmail(String email) async{
  p2 = await SharedPreferences.getInstance();
  p2.setString('email', email);
}

getLoggedInEmail(){
  String email = p2.getString('email');
  return email;
}

setLoggedInPassword(String pass) async{
  p2 = await SharedPreferences.getInstance();
  p2.setString('password', pass);
}

getLoggedInPassword(){
  String password = p2.getString('password');
  return password;
}

setLoggedInUID(String uid) async{
  p2 = await SharedPreferences.getInstance();
  p2.setString('uid', uid);
}

getLoggedInUID(){
  String uid = p2.getString('uid');
  return uid;
}

clearLogins()async{
  await p2.clear();
}