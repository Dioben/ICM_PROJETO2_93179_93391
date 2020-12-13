import 'package:flutter/material.dart';

class ViewTrackList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ViewListState();
}

class ViewListState extends State<ViewTrackList>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text("Track List"),),
        body: Text("TBA"));
  }
}