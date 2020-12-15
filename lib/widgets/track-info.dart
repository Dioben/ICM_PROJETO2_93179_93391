import 'package:flutter/material.dart';
import 'package:track_keeper/widgets/tracking.dart';

class TrackInfoActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: const Text("Track Info"),actions: [FlatButton(onPressed:()=> goToFollowing(context), child: const Text("Run"))],),
    body: Container(color: Colors.grey,child: Text("TBA"),),);
  }

  void goToFollowing(context) {
    Navigator.push(context,MaterialPageRoute(builder: (context) => TrackingActivity()));
  }
}