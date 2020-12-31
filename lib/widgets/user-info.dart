

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/datamodel/User.dart';

class UserStats extends StatelessWidget{
  AppUser user = FirebaseApiClient.user;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(user);
    return Scaffold(appBar: AppBar(title: Text("User Stats"),),
        body: Text("Name: "+  user.username.toString() +"\nTop Score: "+user.top_rating.toString()
            +"\nTrack Count: "+user.coursecount.toString()+"\nTotal Track Length: "+user.formattedTrackLength()+
            "\nTotal Runtime: "+user.formattedRuntime()+"\nAverage Speed: "+user.formattedAvgSpeed()+"\nMax Speed: "+user.formattedMaxSpeed() )
    );
  }
}