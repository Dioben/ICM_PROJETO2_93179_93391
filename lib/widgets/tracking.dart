import 'dart:async';
import 'dart:io';
import 'dart:ui';

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

class TrackingActivity extends StatefulWidget {
  const TrackingActivity({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TrackingState();
}

class _TrackingState extends State<TrackingActivity>
    with SingleTickerProviderStateMixin {
  bool recording = false;
  StreamSubscription<Position> positionStream;
  Set<Marker> _markers;
  Set<Polyline> _polylines;
  Course course;
  LatLng init_pos;
  List<LatLng> points;
  GoogleMapController mapController;
  StreamSubscription<AccelerometerEvent> accelStream;
  double velocity = 0;
  double xaxis =
      0; //we disregard z axis because it includes gravity and doesnt matter for the most part
  double yaxis = 0;
  bool submitted = false;
  bool picturemode = false;
  bool expanded = false;
  bool isPrivate = true;
  bool isAnonymous = false;
  int steps_until_tracking =5;
  TextEditingController namecontrol = TextEditingController();
  final ImagePicker picker = ImagePicker();
  _TrackingState() {
    _markers = Set();
    _polylines = Set();
    points = [];
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      init_pos = LatLng(value.latitude, value.longitude);
      setState(() {});
      if (mapController != null) {
        mapController..animateCamera(CameraUpdate.newLatLng(init_pos));
      }
    });
  }

  AnimationController animationController;
  Animation<double> slideAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    slideAnimation =
        Tween<double>(begin: 2.2, end: 1.0).animate(animationController);

    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition;
    if (init_pos == null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(0, -7.9306927),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    } else {
      initialCameraPosition = CameraPosition(
          target: init_pos,
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }

    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Tracking"),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 7.0),
            child: (() {
              if (!recording) return
                Tooltip(
                  message: "Start recording",
                  child: RawMaterialButton(
                    onPressed: () => startRecording(),
                    elevation: 2.0,
                    fillColor: Colors.greenAccent[700],
                    padding: EdgeInsets.all(8.0),
                    shape: CircleBorder(),
                    child: Icon(Icons.play_arrow),
                  ),
                );
              else return
                Tooltip(
                  message: "Submit",
                  child: RawMaterialButton(
                    onPressed: () {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text("Submit your track:"), 
                                content: SingleChildScrollView(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                    height: 205,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: namecontrol,
                                          decoration: InputDecoration(
                                            labelText: "Track name:",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide()
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 18
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              RaisedButton(
                                                color: isPrivate ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                                                onPressed: () => setState(() => isPrivate = true),
                                                textColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(7),
                                                    bottomLeft: Radius.circular(7),
                                                  )
                                                ),
                                                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                                child: Text("Private",
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              RaisedButton(
                                                color: !isPrivate ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
                                                onPressed: () => setState(() => isPrivate = false),
                                                textColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(7),
                                                    bottomRight: Radius.circular(7),
                                                  )
                                                ),
                                                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                                child: Text("Public",
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        CheckboxListTile(
                                          dense: true,
                                          value: isAnonymous,
                                          onChanged: (newValue) {
                                            setState(() {
                                              isAnonymous = newValue;
                                            });
                                          },
                                          controlAffinity: ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.all(0),
                                          activeColor: Theme.of(context).accentColor,
                                          title: Text("Anonymous",
                                              style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          alignment: Alignment.centerRight,
                                          child: RaisedButton( 
                                            onPressed: () { 
                                              Navigator.of(context).pop(); 
                                              submit();
                                            },
                                            color: Theme.of(context).accentColor,
                                            child: Text("Confirm",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white
                                                ),
                                            ),
                                          ),
                                        ), 
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          );
                        }
                      );
                    },
                    elevation: 2.0,
                    fillColor: Colors.redAccent[700],
                    padding: EdgeInsets.all(8.0),
                    shape: CircleBorder(),
                    child: Icon(Icons.stop),
                  ),
                );
            })(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          FractionallySizedBox(
            alignment: Alignment(0.0, -1.0),
            heightFactor: 0.8,
            child: GoogleMap(
              myLocationButtonEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: _polylines,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: onMapCreated,
              zoomControlsEnabled: false,
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment(0.0, slideAnimation.value),
            heightFactor: 0.59,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 74.0, 0.0, 0.0),
                  child: SizedBox(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TrackItemField(title: "Length:", value: (course==null)?"":course.formattedTrackLength(), rightBorder: 80,),
                      TrackItemField(title: "Current speed:", value: (course==null)?"":velocity.toStringAsFixed(2)+" km/h",),
                      TrackItemField(title: "Runtime:", value: (course==null)?"":course.formattedRuntime(),),
                      TrackItemField(title: "Maximum speed:", value: (course==null)?"":course.formattedMaxSpeed(),),
                      TrackItemField(title: "Average speed:", value: (course==null)?"":course.formattedAvgSpeed(),),
                    ],
                  )
                  
                ),
                Align(
                  alignment: Alignment(0.95, -1.0),
                  child: SizedBox(
                    width: 60,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (() {
                          if (recording) return
                            Tooltip(
                              message: "Take a photo",
                              child: RawMaterialButton(
                                onPressed: () => takePicture(),
                                elevation: 2.0,
                                fillColor: Colors.green[800],
                                padding: EdgeInsets.all(8.0),
                                shape: CircleBorder(),
                                child: Icon(Icons.camera_alt),
                              ),
                            );
                          else return
                            Container();
                        })(),
                        Tooltip(
                          message: (() {
                            if (!expanded) return "Expand";
                            else return "Contract";
                          })(),
                          child: RawMaterialButton(
                            onPressed: () => expandAndContractInfo(),
                            elevation: 2.0,
                            fillColor: Colors.green[800],
                            padding: EdgeInsets.all(4.0),
                            shape: CircleBorder(),
                            child: (() {
                            if (!expanded) return Icon(Icons.arrow_drop_up, size: 40);
                            else return Icon(Icons.arrow_drop_down, size: 40);
                            })(),
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }

  void expandAndContractInfo() {
    if (!expanded)
      animationController.forward();
    else
      animationController.reverse();
    setState(() {
      expanded = !expanded;
    });
  }

  startRecording() async {
    //if (mapController==null){return;}
    course = Course.original();
    setState(() {
      recording = true;
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    init_pos = LatLng(position.latitude, position.longitude);
    points.add(init_pos);
    course.appendNode(CourseNode.initial(position));
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(init_pos));
    }
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('Start'),
          infoWindow: InfoWindow(title: "Start"),
          position: init_pos));
    });

    positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation)
        .listen((Position position) {
      velocity = position.speed/1000*3600;
      if (velocity>100){steps_until_tracking=5;return;}
      if (steps_until_tracking>0){steps_until_tracking--;return;}

      init_pos = LatLng(position.latitude, position.longitude);
      CourseNode node = CourseNode.followUp(position, course.nodes.last);
      course.appendNode(node);
      points.add(init_pos);
      _polylines.add(Polyline(
          polylineId: PolylineId('our track'),
          visible: true,
          points: points,
          color: Colors.red));
      _markers.add(Marker(
          markerId: MarkerId('Current'),
          infoWindow: InfoWindow(title: "Current"),
          position: init_pos));
      if (!picturemode) {
        setState(() {});
        if (mapController != null)
          mapController.animateCamera(CameraUpdate.newLatLng(init_pos));
      }
    });
    accelStream = accelerometerEvents.listen((event) {
      //TODO: what the hell do i do with this
    });
  }

  submit() async {
    //cancel all streams,submit course,view it
    if (submitted) return;
    submitted = true;
    positionStream.cancel();
    accelStream.cancel();
    course.finalize();
    course.name = namecontrol.text.trim();
    course.isprivate= isPrivate;
    course.anon = isAnonymous;
    await FirebaseApiClient.instance.submitCourse(course);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TrackInfoActivity(course)));
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream.cancel();
    }
    if (accelStream != null) {
      accelStream.cancel();
    }
    super.dispose();
  }

  void onMapCreated(GoogleMapController controller) {
    if (init_pos != null) {
      controller.animateCamera(CameraUpdate.newLatLng(init_pos));
      mapController = controller;
      print("controller assigned");
    }
  }

  void takePicture() async {
    print("takePicture");
    try {
      picturemode = true;
      final PickedFile picture =
          await picker.getImage(source: ImageSource.camera);
      File picfile = File(picture.path);
      print("got to path");
      picturemode = false;
      String upstreamurl = await FirebaseApiClient.instance.postImage(picfile);
      if (upstreamurl != null) {
        print("got url $upstreamurl");
        course.pictures.add(upstreamurl);
      }
    } catch (e) {
      print(e);
    }
  }
}


class TrackItemField extends StatefulWidget {
  TrackItemField({Key key, @required this.title, @required this.value, this.rightBorder}) : super(key: key);
  final String title;
  final String value;
  final double rightBorder;

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
          margin: EdgeInsets.fromLTRB(20, 0, widget.rightBorder == null ? 20 : widget.rightBorder, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(widget.value , style: TextStyle(fontSize: 17)),
            ],
          )
        ),
        Container(
          height: 3,
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(20, 3, widget.rightBorder == null ? 20 : widget.rightBorder, 10),
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