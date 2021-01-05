import 'dart:async';

import 'package:flutter/material.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/datamodel/course.dart';
import 'package:track_keeper/widgets/tracking.dart';

class TrackInfoActivity extends StatelessWidget {
  Course course;
  List<Course> courses;
  StreamSubscription<Course> updateStream;
  @override

  TrackInfoActivity(Course course){this.course=course;updateStream=FirebaseApiClient.instance.getOtherRuns(course).listen((event) {courses.add(event); });}

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text(course.name),actions: [FlatButton(onPressed:()=> goToFollowing(context), child: const Text("Run"))],),
    body:  Container(
        padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

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
                        Text((course==null)?"":course.user+" "+course.getFormattedTimestamp(), style: TextStyle(fontSize: 17)),
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
                        Text((course==null)?"":course.formattedTrackLength(), style: TextStyle(fontSize: 17)),
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
                        Text((course==null)?"":course.formattedRuntime(), style: TextStyle(fontSize: 17)),
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
                        Text((course==null)?"":course.formattedMaxSpeed(), style: TextStyle(fontSize: 17)),
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
                        Text((course==null)?"":course.formattedAvgSpeed(), style: TextStyle(fontSize: 17)),
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
                        Text((course==null)?"":course.pictures.toString(), style: TextStyle(fontSize: 17)),
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
}