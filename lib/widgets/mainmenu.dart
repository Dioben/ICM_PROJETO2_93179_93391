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

class MainMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:Padding(//maybe replace with column/expanded
        padding: const EdgeInsets.symmetric(vertical: 150,),

        child: Row(
          children: [
            Spacer(flex: 2,),
            Expanded(
              flex: 6,
              child: Center(
                child: Column(children: [
                  
                  Expanded(
                    flex:4,
                    child: Stack(
                    children: [ Text("Track Keeper",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,foreground: Paint()..style=PaintingStyle.stroke..strokeWidth=3..color=Colors.black),),
                      Text("Track Keeper",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.green),),],
                ),
                  ),
                  Spacer(flex:2),
                  Expanded(flex:5,child: SizedBox(width:double.infinity,child: ElevatedButton(child: Text("Free Play"),onPressed: ()=>freePlay(context)))),
                  Spacer(flex:2),
                  Expanded(flex:5,child: SizedBox(width:double.infinity,child: ElevatedButton(child: Text("Tracks"),onPressed: ()=>viewTracks(context),))),
                  Spacer(flex:2),
                  Expanded(flex:5 ,child: SizedBox(width:double.infinity,child: ElevatedButton(child: Text("User Stats"),onPressed:()=> userInfo(context),))),
                  Spacer(flex:2),
                  Expanded(flex:5,child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [Expanded(flex:8,child: SizedBox(height:double.infinity,child: ElevatedButton(child: Text("Logout"),onPressed: ()=>toLogin(context),))),Spacer(flex:1),Expanded(flex:8,child: SizedBox(height: double.infinity,child: ElevatedButton(child: Text("Settings"),onPressed: ()=>viewSettings(context),)))],)),

                ],

                ),
    ),
            ),
            Spacer(flex: 2,),
          ],
        ),
      ),
    );
  }

  freePlay(context){
    Navigator.push(context,MaterialPageRoute(builder: (context) => TrackingActivity()));
  }
  userInfo(context){
    Navigator.push(context,MaterialPageRoute(builder: (context) => UserStats()));
  }
  viewTracks(context){
    Navigator.push(context,MaterialPageRoute(builder: (context) => ViewTrackList()));
  }
  viewSettings(context) async{
    //Navigator.push(context,MaterialPageRoute(builder: (context) => SettingsMenu()));
    Stream<Course> courses = FirebaseApiClient.instance.getNearbyRecent(LatLng(40.6405, -8.6538), 30);
    await for (Course val in courses){print(val.getFormattedTimestamp());}
  }
  toLogin(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginMenu()));
  }
}