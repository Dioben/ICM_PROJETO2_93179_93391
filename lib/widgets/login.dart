import 'package:flutter/material.dart';

class LoginMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginMenu>{
  bool logging = false; //display a spinny thing while logging in i guess
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text("Settings"),),
        body: Text("TBA"));
  }

  login(){
    logging=true;
    setState(() {});
  }
}