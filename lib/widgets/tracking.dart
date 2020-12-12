import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'shared.dart';

class TrackingActivity extends StatefulWidget{
  const TrackingActivity({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() =>_TrackingState();

}

class _TrackingState extends State<TrackingActivity>{
  bool recording=false;
  @override
  Widget build(BuildContext context) {
    //this should return different things if recording or not recording
    if (!recording){
    return Scaffold(
      appBar: AppBar(title: const Text("Tracking"),actions: [IconButton(icon: const Icon(Icons.play_arrow),tooltip: "Start recording",onPressed: ()=>startRecording(),)]
        ,),
    body: ReusableTrackingLayout(),//implement this in the shared file    
    );}
    else{
      return Scaffold(
        appBar: AppBar(title: const Text("Tracking"),actions: [IconButton(icon: const Icon(Icons.stop),tooltip: "Submit",onPressed: submit(),)]
          ,),
        body: ReusableTrackingLayout(),//implement this in the shared file    
      );
    }
  }

  startRecording() {
    recording=true;
    setState(() {
      
    });
  }

  submit() {}
}