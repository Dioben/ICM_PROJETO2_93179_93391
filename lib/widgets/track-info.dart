import 'package:flutter/material.dart';
import 'package:track_keeper/datamodel/course.dart';
import 'package:track_keeper/widgets/tracking.dart';

class TrackInfoActivity extends StatelessWidget {
  final Course course;
  @override
    TrackInfoActivity({Key key,@required this.course}):super(key:key);

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text(course.name),actions: [FlatButton(onPressed:()=> goToFollowing(context), child: const Text("Run"))],),
    body: Container(color: Colors.grey,child: Text("TBA"),),);
  }

  void goToFollowing(context) {
    Navigator.push(context,MaterialPageRoute(builder: (context) => TrackingActivity()));
  }
}