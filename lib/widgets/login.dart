import 'package:flutter/material.dart';

class LoginMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginMenu>{
  bool logging = false; //display a spinny thing while logging in i guess
  String name;//putting this here in case we've gotta persist this on failed logins
  String password;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Text("TBA"));
  }

  login(){
    logging=true;
    setState(() {});
  }
}