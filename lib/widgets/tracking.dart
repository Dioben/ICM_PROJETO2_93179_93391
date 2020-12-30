import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors/sensors.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/datamodel/course.dart';
import 'package:track_keeper/widgets/track-info.dart';



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
  List<LatLng> points;
  GoogleMapController mapController;
  StreamSubscription<AccelerometerEvent> accelStream;
  double velocity=0;
  double xaxis=0; //we disregard z axis because it includes gravity and doesnt matter for the most part
  double yaxis=0;
  final ImagePicker picker = ImagePicker();
  _TrackingState() {
    _markers = Set();
    _polylines = Set();
    points = [];
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) {  init_pos= LatLng(value.latitude, value.longitude);setState(() {

    }); if (mapController!=null){mapController..animateCamera(CameraUpdate.newLatLng(init_pos));}
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
                onPressed: submit,)
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
            ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.camera_alt),onPressed: (){takePicture();},),
      );
    }
  }

  startRecording() async {
    //course = Course.original();
    setState(() {
      recording = true;
    });
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    init_pos = LatLng(position.latitude,position.longitude);
    points.add( init_pos);
    if (mapController!=null) {mapController.animateCamera(CameraUpdate.newLatLng(init_pos));}
    setState(() {
      _markers.add(Marker(markerId: MarkerId('Start'),infoWindow: InfoWindow(title: "Start"),position: init_pos));
    });

    positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.bestForNavigation).listen(
        (Position position){
          velocity=position.speed;
        init_pos = LatLng(position.latitude, position.longitude);
       // course.appendNode(CourseNode.followUp(position, course.nodes.last));
        points.add(init_pos);
        _polylines.add(Polyline(polylineId: PolylineId('our track'),visible: true,points: points,color: Colors.red));
        setState(() {
        });
        print(mapController);
        mapController.animateCamera(CameraUpdate.newLatLng(init_pos));
        _markers.add(Marker(markerId: MarkerId('Current'),infoWindow: InfoWindow(title: "Current"),position: init_pos));
        }

    );
    accelStream = accelerometerEvents.listen((event) {
      //TODO: what the hell do i do with this
    });
  }

  submit() async{
    //TODO: SEND TO FIREBASE, REDIRECT US TO THE INFO PAGE MATCHING WHAT WE'VE SUBMITTED
    positionStream.cancel();
    accelStream.cancel();
    course.finalize();
   await FirebaseApiClient.instance.submitCourse(course);
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrackInfoActivity(course: course)));

  }


  @override
  void dispose() {
    if (positionStream!=null){
      positionStream.cancel();
    }
    if (accelStream!=null){accelStream.cancel();}
    super.dispose();
  }


  void onMapCreated(GoogleMapController controller) {
    if(init_pos!=null){controller.animateCamera(CameraUpdate.newLatLng(init_pos));mapController=controller;print("controller assigned");}

  }

  void takePicture() async{
    PickedFile picture = await picker.getImage(source: ImageSource.camera);
    File picfile = File(picture.path);
    String upstreamurl = await FirebaseApiClient.instance.postImage(picfile);
    if (upstreamurl!=null){print("got url $upstreamurl");/*course.pictures.add(upstreamurl);*/}
  }
}