import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/datamodel/course.dart';
import 'package:track_keeper/widgets/tracking.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'following.dart';

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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(7.0, 7.0, 7.0, 7.0),
            width: 60,
            child: RaisedButton( 
              onPressed: () => goToFollowing(context),
              color: Theme.of(context).accentColor,
              child: Text("Run",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
                  ),
              ),
            ),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/2,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(20, 10 , 20, 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor
                )
              ),
              child: AbsorbPointer(
                absorbing: true,
                child: GoogleMap(
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  tiltGesturesEnabled: false,
                  markers: _markers,
                  polylines: _polylines,
                  mapType: MapType.normal,
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: onMapCreated,
                  zoomControlsEnabled: false
                ),
              ),
            ),
            widget.course.pictures.length == 0 ? Container() : Container(
              height: MediaQuery.of(context).size.height/1.5,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor
                )
              ),
              child: Swiper(
                itemCount: widget.course.pictures.length,
                pagination: SwiperPagination(),
                autoplay: true,
                autoplayDelay: 10000,
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return CachedNetworkImage(
                    progressIndicatorBuilder: (context, url, downloadProgress) => 
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: (MediaQuery.of(context).size.height/1.5)/2 - 30,
                          horizontal: (MediaQuery.of(context).size.width-40)/2 -30
                        ),
                        child: CircularProgressIndicator(value: downloadProgress.progress)
                      ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.fitWidth,
                    imageUrl: widget.course.pictures[index],
                  );
                },
              ),
            ),
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
            courses.length == 0 ? Container(height: 10) : Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 10 , 20, 0),
                  child: AppBar(
                    title: Text("Runs made on the same course"),
                    automaticallyImplyLeading: false,
                  ),
                ),
                Container(
                  height: (() {
                    double maxSize = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - AppBar().preferredSize.height*2 - 20;
                    if (maxSize > 130.0 * courses.length)
                      return 130.0 * courses.length;
                    return maxSize;
                  })(),
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor
                    )
                  ),
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemExtent: 130,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: courses.length,
                    itemBuilder: (context, index) =>
                      InkWell(
                        onTap: () => goToInfo(courses[index]),
                        child: Ink(
                          color: (() {
                            if (index % 2 == 0) return Colors.grey[300];
                            else return Colors.grey[200];
                          })(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TrackItemFieldList(title: "Track name:", value: courses[index].name),
                              TrackItemFieldList(title: "Runner name:", value: courses[index].user),
                              TrackItemFieldList(title: "Date uploaded:", value: courses[index].getFormattedTimestamp()),
                              TrackItemFieldList(title: "Runtime:", value: courses[index].formattedRuntime()),
                              TrackItemFieldList(title: "Rating:", value: courses[index].rating.toString()),
                            ],
                          )
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onRefresh() async {
    await getCurrentPosition();
    courses = [];
    updateStream =
        FirebaseApiClient.instance.getOtherRuns(widget.course).listen((event) {
      courses.add(event);
      setState(() {});
    });
    _refreshController.refreshCompleted();
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
        context, MaterialPageRoute(builder: (context) => FollowingActivity(widget.course)));
  }

  goToInfo(Course course) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TrackInfoActivity(course))
    );
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

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
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
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
          ),
        ),
      ],
    );
  }
}


class TrackItemFieldList extends StatefulWidget {
  TrackItemFieldList({Key key, @required this.title, @required this.value}) : super(key: key);
  final String title;
  final String value;

  @override
  _TrackItemFieldListState createState() => new _TrackItemFieldListState();
}

class _TrackItemFieldListState extends State<TrackItemFieldList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20,
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title , style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(widget.value , style: TextStyle(fontSize: 15)),
            ],
          )
        ),
        Container(
          height: 1,
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 1),
          child: SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
          ),
        ),
      ],
    );
  }
}