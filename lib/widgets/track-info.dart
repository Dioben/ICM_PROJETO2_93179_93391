import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/datamodel/course.dart';
import 'package:track_keeper/widgets/tracking.dart';

class TrackInfoActivity extends StatefulWidget {
  Course course;
  @override
  TrackInfoActivity(Course course) {
    this.course = course;
  }

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
  double currLat;
  double currLon;

  @override
  void initState() {
    super.initState();
    courses = [];
    _markers = Set();
    _polylines = Set();
    points = [];
    initialCameraPosition = CameraPosition(
        target: widget.course.nodes.first.toLatLng(),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);

    updateStream =
        FirebaseApiClient.instance.getOtherRuns(widget.course).listen((event) {
      courses.add(event);
      setState(() {});
    });

    getCurrentPosition();
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
        actions: [
          FlatButton(
              onPressed: () => goToFollowing(context), child: const Text("Run"))
        ],
      ),
      body: Container(
          padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              TrackItemField(title: "Track name:", value: widget.course.name),
              TrackItemField(title: "Runner name:", value: widget.course.user),
              TrackItemField(
                  title: "Date uploaded:",
                  value: widget.course.getFormattedTimestamp()),
              TrackItemField(
                  title: "Length:",
                  value: widget.course.formattedTrackLength()),
              TrackItemField(
                  title: "Runtime:", value: widget.course.formattedRuntime()),
              TrackItemField(
                  title: "Rating:", value: widget.course.rating.toString()),
              TrackItemField(
                  title: "Distance away:",
                  value: (() {
                    if (currLon != null && currLat != null)
                      return widget.course.formattedDistance(currLat, currLon);
                    else
                      return "Unknown";
                  })()),
              TrackItemField(
                  title: "Maximum speed:",
                  value: widget.course.formattedMaxSpeed()),
              TrackItemField(
                  title: "Average speed:",
                  value: widget.course.formattedAvgSpeed()),
              TrackItemField(
                  title: "pictures:",
                  value: (widget.course == null)
                      ? ""
                      : widget.course.pictures.toString()),
            ],
          )),
    );
  }

  getCurrentPosition() async {
    Position currPos = await Geolocator.getCurrentPosition();
    setState(() {
      currLat = currPos.latitude;
      currLon = currPos.longitude;
    });
  }

  void goToFollowing(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TrackingActivity()));
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
    setState(() {});
    widget.course.unwindCourse().listen((event) {
      points.add(event);
      _polylines.add(Polyline(
          polylineId: PolylineId('our track'),
          visible: true,
          points: points,
          color: Colors.red));
      setState(() {});
    });
  }
}

class TrackItemField extends StatefulWidget {
  TrackItemField({Key key, @required this.title, @required this.value})
      : super(key: key);
  final String title;
  final String value;

  @override
  _TrackItemFieldState createState() => new _TrackItemFieldState();
}

class _TrackItemFieldState extends State<TrackItemField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 20,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(widget.value, style: TextStyle(fontSize: 17)),
              ],
            )),
        Container(
          height: 2,
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(20, 3, 20, 10),
          child: SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }
}
