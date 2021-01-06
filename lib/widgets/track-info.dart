import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/datamodel/course.dart';
import 'package:track_keeper/widgets/tracking.dart';

class TrackInfoActivity extends StatefulWidget {
  Course course;
  @override

  TrackInfoActivity(Course course){this.course=course;}

  @override
  _TrackInfoActivityState createState() => _TrackInfoActivityState();
}

class _TrackInfoActivityState extends State<TrackInfoActivity> {
  List<Course> courses;
  StreamSubscription<Course> updateStream;
  Set<Marker> _markers;
  Set<Polyline> _polylines;
  CameraPosition initialCameraPosition;
  List<LatLng> points;
  GoogleMapController mapController;
  @override
  void initState(){
    super.initState();
    courses = [];
    _markers=Set();
    _polylines=Set();
    points = [];
    initialCameraPosition = CameraPosition(
        target: widget.course.nodes.first.toLatLng(),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);

    updateStream=FirebaseApiClient.instance.getOtherRuns(widget.course).listen((event) {courses.add(event);setState(() {

  }); });}

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text(widget.course.name),actions: [FlatButton(onPressed:()=> goToFollowing(context), child: const Text("Run"))],),
    body:  Container(
        padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          /*GoogleMap(
          myLocationButtonEnabled: true,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          markers: _markers,
          polylines: _polylines,
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: onMapCreated,
          zoomControlsEnabled: false,
        )
            ,*/
            Column(
              children: [
                Container(
                    height: 20,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 80, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Uploaded by:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text((widget.course==null)?"":widget.course.user+" "+widget.course.getFormattedTimestamp(), style: TextStyle(fontSize: 17)),
                      ],
                    )
                ),
                Container(
                  height: 3,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 3, 80, 10),
                  child: SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),

            Column(
              children: [
                Container(
                    height: 20,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 80, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Length:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text((widget.course==null)?"":widget.course.formattedTrackLength(), style: TextStyle(fontSize: 17)),
                      ],
                    )
                ),
                Container(
                  height: 3,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 3, 80, 10),
                  child: SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),

            Column(
              children: [
                Container(
                    height: 20,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Runtime:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text((widget.course==null)?"":widget.course.formattedRuntime(), style: TextStyle(fontSize: 17)),
                      ],
                    )
                ),
                Container(
                  height: 3,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 3, 20, 10),
                  child: SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                    height: 20,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Maximum speed:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text((widget.course==null)?"":widget.course.formattedMaxSpeed(), style: TextStyle(fontSize: 17)),
                      ],
                    )
                ),
                Container(
                  height: 3,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 3, 20, 10),
                  child: SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                    height: 20,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Average speed:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text((widget.course==null)?"":widget.course.formattedAvgSpeed(), style: TextStyle(fontSize: 17)),
                      ],
                    )
                ),
                Container(
                  height: 3,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 3, 20, 6),
                  child: SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                    height: 20,
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20, 0, 80, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("pictures:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text((widget.course==null)?"":widget.course.pictures.toString(), style: TextStyle(fontSize: 17)),
                      ],
                    )
                ),
                Container(
                  height: 3,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 3, 80, 10),
                  child: SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )

    ),);
  }

  void goToFollowing(context) {
    Navigator.push(context,MaterialPageRoute(builder: (context) => TrackingActivity()));
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _markers.add(Marker(
        markerId: MarkerId('Start'),
        infoWindow: InfoWindow(title: "Start"),
        position: widget.course.nodes.first.toLatLng()));
    _markers.add(Marker(
        markerId: MarkerId('Finish'),
        infoWindow: InfoWindow(title: "Finish"),
        position: widget.course.nodes.last.toLatLng()));
    setState(() {

    });
    widget.course.unwindCourse().listen((event) {points.add(event);  _polylines.add(Polyline(
        polylineId: PolylineId('our track'),
        visible: true,
        points: points,
        color: Colors.red));
    setState(() {});
    });

  }
}