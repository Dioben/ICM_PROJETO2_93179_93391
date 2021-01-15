import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/datamodel/course.dart';
import 'package:track_keeper/widgets/login.dart';
import 'package:track_keeper/widgets/settings.dart';
import 'package:track_keeper/widgets/track-info.dart';
import 'package:track_keeper/widgets/track-list.dart';
import 'package:track_keeper/widgets/tracking.dart';
import 'package:track_keeper/widgets/user-info.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: FractionallySizedBox(
          widthFactor: 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Track Keeper",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                  shadows: [
                    Shadow(
                        color: Colors.black45,
                        blurRadius: 1,
                        offset: Offset(1, 1.5))
                  ]
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                width: 200,
                height: 45,
                child: ElevatedButton(
                  child: Text(
                    "Free play",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () => freePlay(context),
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: 200,
                height: 45,
                child: ElevatedButton(
                  child: Text(
                    "Tracks",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () => viewTracks(context),
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: 200,
                height: 45,
                child: ElevatedButton(
                  child: Text(
                    "User info",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () => userInfo(context),
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: 200,
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 97,
                      height: 45,
                      child: ElevatedButton(
                        child: Text(
                          "Logout",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () => toLogin(context),
                      )
                    ),
                    Container(
                      width: 97,
                      height: 45,
                      child: ElevatedButton(
                        child: Text(
                          "Settings",
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () => viewSettings(context),
                      )
                    ),
                  ],
                ),
              )
            ],

          ),
        ),
      ),
    );
  }

  freePlay(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TrackingActivity()));
  }

  userInfo(context) {
    if (FirebaseApiClient.user==null){print("user future hasnt finished yet");return;}
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserStats()));
  }

  viewTracks(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ViewTrackList()));
  }

  viewSettings(context) async {
    //Navigator.push(context,MaterialPageRoute(builder: (context) => SettingsMenu()));
    Stream<Course> courses = FirebaseApiClient.instance
        .getNearbyRecent(LatLng(40.6405, -8.6538), 30);
    await for (Course val in courses) {
      print(val.getFormattedTimestamp());
    }
  }

  toLogin(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginMenu()));
  }
}
