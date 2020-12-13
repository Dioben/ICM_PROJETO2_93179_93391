import 'package:flutter/material.dart';

class SettingsMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsMenu>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text("Settings"),),
        body: Text("TBA"));
  }
}