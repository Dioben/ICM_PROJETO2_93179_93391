import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_keeper/datamodel/course.dart';



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
  StreamSubscription<Position> positionStream;
  Set<Marker> _markers;
  Set<Polyline> _polylines;
  Course course;
  LatLng init_pos;
  _TrackingState() {
    _markers = Set();
    _polylines = Set();
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {  init_pos= LatLng(value.latitude, value.longitude);setState(() {

    });
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition;
    if (init_pos==null) {
      initialCameraPosition =  CameraPosition(
          target: LatLng(0, -7.9306927),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);}
    else{
    initialCameraPosition =  CameraPosition(
      target: init_pos,
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING);
    }
    print(initialCameraPosition);

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
          body: GoogleMap(
            myLocationButtonEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: onMapCreated,
            )
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
          body:GoogleMap(
            myLocationButtonEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
              onMapCreated: onMapCreated
            )
      );
    }
  }

  startRecording() async {
    setState(() {
      recording = true;
    });
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    init_pos = LatLng(position.latitude,position.longitude);
    setState(() {
      _markers.add(Marker(markerId: MarkerId('Start'),infoWindow: InfoWindow(title: "Start"),position: LatLng(position.latitude,position.longitude)));
    });

    positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation).listen(
        (Position position){

        }
    );
  }

  submit() {
    //TODO: SEND TO FIREBASE, REDIRECT US TO THE INFO PAGE MATCHING WHAT WE'VE SUBMITTED
  }


  @override
  void dispose() {
    if (positionStream!=null){
      positionStream.cancel();
    }
    super.dispose();
  }


  void onMapCreated(GoogleMapController controller) {
    if(init_pos!=null){controller.animateCamera(CameraUpdate.newLatLng(init_pos));print("moved to "+init_pos.toString());}

  }
}