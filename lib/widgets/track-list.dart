import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/datamodel/course.dart';
import 'package:track_keeper/widgets/track-info.dart';

class ViewTrackList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ViewListState();
}

class ViewListState extends State<ViewTrackList> {
  List<Course> courses;
  StreamSubscription<Course> updateStream;
  LatLng userpos;
  List<String> queryselectors = ["Anyone", "Date"];
  @override
  ViewListState() {
    courses = [];
    Geolocator.getCurrentPosition().then((value) {
      userpos = LatLng(value.latitude, value.longitude);
      if (updateStream == null) {
        updateStream = FirebaseApiClient.instance
            .getNearbyRecent(userpos, 30)
            .listen((event) {
          courses.add(event);
          setState(() {});
        });
      }
    });
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Track List"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TrackTypeSelector(
                notifyParent: updateSelection,
              )
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent)
                ),
                child: new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: courses.length,
                      itemBuilder: (context, index) =>
                        InkWell(
                          onTap: () => goToInfo(courses[index]),
                          child: Ink(
                            color: (() {
                              if (index % 2 == 0) return Colors.green[100];
                              else return Colors.lightGreen[100];
                            })(),
                            height: 50,
                            child: Text(courses[index].name),
                          ),
                        ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 10,
            )
          ],
        ));
  }

  updateSelection(int selector, String value) {
    queryselectors[selector] = value;
    doQuery();
  }

  goToInfo(Course course) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TrackInfoActivity(
                  course: course,
                )));
  }

  void doQuery() async {
    if (queryselectors[0] == "Anyone" && userpos == null) {
      return;
    } //provide feedback to user here
    if (updateStream != null) {
      updateStream.cancel();
    }
    courses = [];
    setState(() {});
    if (queryselectors[0] == "Anyone") {
      if (queryselectors[1] == "Date") {
        updateStream = FirebaseApiClient.instance
            .getNearbyRecent(userpos, 30)
            .listen((event) {
          courses.add(event);
          setState(() {});
        });
      } else {
        updateStream = FirebaseApiClient.instance
            .getNearbyTopRated(userpos, 30)
            .listen((event) {
          courses.add(event);
          setState(() {});
        });
      }
    } else {
      if (queryselectors[1] == "Date") {
        updateStream =
            FirebaseApiClient.instance.getMyCourses().listen((event) {
          courses.add(event);
          setState(() {});
        });
      } else {
        updateStream =
            FirebaseApiClient.instance.getMyCoursesByRating().listen((event) {
          courses.add(event);
          setState(() {});
        });
      }
    }
  }
}

class TrackTypeSelector extends StatefulWidget {
  final Function(int, String) notifyParent;
  TrackTypeSelector({Key key, @required this.notifyParent}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TrackTypeSelectionState();
}

class TrackTypeSelectionState extends State<TrackTypeSelector> {
  String owner = "Anyone";
  String sort = "Date";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: DropdownButton<String>(
              onChanged: (String newval) {
                setState(() => owner = newval);
                widget.notifyParent(0, newval);
              },
              value: owner,
              hint: Text("Owner:"),
              items: <String>['Anyone', 'Me']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: DropdownButton<String>(
              onChanged: (String newval) {
                setState(() => sort = newval);
                widget.notifyParent(1, newval);
              },
              value: sort,
              hint: Text("Sort by:"),
              items: <String>['Date', 'Rating']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}
