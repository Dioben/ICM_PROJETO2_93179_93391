import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_keeper/datamodel/course.dart';

import 'shared.dart';


const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

class TrackingActivity extends StatefulWidget{
  const TrackingActivity({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() =>_TrackingState();

}

class _TrackingState extends State<TrackingActivity> {
  bool recording = false;
  bool map_ready = false;
  Set<Marker> _markers;
  Set<Polyline> _polylines;
  List<LatLng> coords;
  Course course;
  GoogleMap constmap;

  _TrackingState() {
    constmap = GoogleMap(
      myLocationButtonEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      markers: _markers,
      polylines: _polylines,
      mapType: MapType.normal,
      initialCameraPosition: const CameraPosition(
          target: LatLng(40.66101, -7.90971),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING),
      onMapCreated: onMapCreated,);
  }

  @override
  Widget build(BuildContext context) {
    //this should return different things if recording or not recording
    if (!recording) {
      return Scaffold(
          appBar: AppBar(title: const Text("Tracking"),
            actions: [
              IconButton(icon: const Icon(Icons.play_arrow),
                tooltip: "Start recording",
                onPressed: () => startRecording(),)
            ]
            ,),
          body: constmap
      );
    }
    else {
      return Scaffold(
          appBar: AppBar(title: const Text("Tracking"),
            actions: [
              IconButton(icon: const Icon(Icons.stop),
                tooltip: "Submit",
                onPressed: submit(),)
            ]
            ,),
          body: constmap
      );
    }
  }

  startRecording() {
    if (!map_ready){return;}
    recording = true;
    setState(() {

    });
  }

  submit() {}

  void onMapCreated(GoogleMapController controller) {
    //idk man try to get current location to center it?
    map_ready=true;
  }


}