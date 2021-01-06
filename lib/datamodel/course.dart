import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Course{
   int timestamp;
   double runtime;
   String user;
   String uID;
   double  track_length;
   List<CourseNode> nodes;
   List<String> pictures;
   double max_speed; //no min cuz that'll probably be 0 when the user stops
   double avg_speed;
   int rating;
   String course_id; //
   bool iscopy;
   bool isprivate;
   bool anon;
   String name;
   double lat; //querying inner doc range seems like a mess or even impossible
   double lon;


   Map<String,dynamic> toJson(){

     List nodelist = [];
     for (CourseNode node in nodes){nodelist.add(node.toJson());}
     
     return {'timestamp':timestamp,'runtime':runtime,'user':user,'uID':uID,
                                  'track_length':track_length,'nodes':nodelist,'pictures':pictures,
                                  'max_speed':max_speed,'avg_speed':avg_speed,'rating':rating,
                                    'course_id':course_id,'iscopy':iscopy,'isprivate':isprivate,
                                  'anon':anon,'name':name,'lat':lat,'lon':lon};}

   Course.fromJson(Map<String,dynamic> json){
     timestamp = json['timestamp'] as int;
     runtime = json['runtime'] as double;
     user = json['user'];
     uID = json['uID'];
     track_length = json['track_length'] as double;
     max_speed = json['max_speed'] as double;
     avg_speed = json['avg_speed'] as double;
     rating = json['rating'] as int;
     course_id = json['course_id'];
     name = json['name'];
     iscopy = json['iscopy'] as bool;
     isprivate = json['isprivate'] as bool;
     anon = json['anon'] as bool;
     lat = json['lat'] as double;
     lon = json['lon'] as double;
     pictures = [];
     for (dynamic e in json['pictures']){pictures.add(e as String);}
     nodes = [];
     for(dynamic e in json['nodes']){nodes.add(CourseNode.fromJson(e));}
   }

   Course.copy(Course course){

     iscopy = true;
     pictures=[];
     nodes=[];
     this.course_id = course.course_id;
     this.user = FirebaseAuth.instance.currentUser.displayName;
     this.uID = FirebaseAuth.instance.currentUser.uid;
     max_speed=0;
     avg_speed=0;
     anon=false;
     isprivate=false;
     track_length=0;
     runtime=0;
   }
   Course.original(){
     iscopy=false;
     pictures=[];
     nodes=[];
     this.user = FirebaseAuth.instance.currentUser.displayName;
     this.course_id = FirebaseAuth.instance.currentUser.uid;
     this.uID = FirebaseAuth.instance.currentUser.uid;
     name = "";
     max_speed=0;
     avg_speed=0;
     anon=false;
     isprivate=false;
     track_length=0;
     runtime=0;
   }
   appendNode(CourseNode x){
     if (x.velocity>max_speed){max_speed=x.velocity;}
     nodes.add(x);
     track_length+=x.distance_from_last/1000;
     runtime = nodes.last.time_stamp - nodes.first.time_stamp;
     avg_speed = track_length/((runtime/1000)/3600);
   }

   Stream<LatLng> unwindCourse() async*{
     for (CourseNode x in nodes){yield x.toLatLng();}
   }
   LatLng centerMapPoint(){return nodes.elementAt((nodes.length/2) as int).toLatLng();}
   String getFormattedTimestamp(){
     //todo: figure out the smart stuff to make it look nice
     Duration timepast =DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
     return timepast.toString();}
   String formattedRuntime(){
     double totsecs = runtime/1000;
     String ret ="";
     if (totsecs>3600) {
       int hours = totsecs~/3600;
       ret+= hours.toString()+":";
       totsecs-=hours*3600;
       int mins = totsecs~/60;
       if (mins<10){ret+="0";}
       ret+=mins.toString()+":";
       totsecs-=60*mins;
       int seconds = totsecs.toInt();
       if (seconds<10){ret+="0";}
       ret+=seconds.toString()+" h";
     } else {
       int mins = totsecs~/60;
       ret+=mins.toString() +":";
       totsecs-=60*mins;
       int seconds = totsecs.toInt();
       if (seconds<10){ret+="0";}
       ret+=seconds.toString()+" min";
     }
     return ret;}

   String formattedTrackLength() =>track_length.toStringAsFixed(3)+" km";
   String formattedMaxSpeed() =>max_speed.toStringAsFixed(3)+ " km/h";
   String formattedAvgSpeed()=>avg_speed.toStringAsFixed(3)+ " km/h";

   String toString() => this.toJson().toString();

   void finalize(){
     //calculate rating and avg_speed here, probably also duration based on nodes*time between node adds
     if (nodes.isEmpty){return;}
     runtime = nodes.last.time_stamp - nodes.first.time_stamp;
     lat = nodes.first.lat;
     lon = nodes.first.lon;
     timestamp =  DateTime.now().millisecondsSinceEpoch;
     avg_speed = track_length/((runtime/1000)/3600);
     if (! iscopy)course_id+=timestamp.toString();
     rating = (((avg_speed/6)*((runtime/1e+9)/30))).toInt() ; // avg human walking speed is 6km/h
   }
}




class CourseNode {
   double time_stamp; //gonna have to use system.nano timing cuz duration is api 26
   double distance_from_last;
   double velocity;// km/h
   double lat; //saving location to firebase is tricky so we're using this instead
   double lon;

   CourseNode.initial(Position initial){
    lat = initial.latitude;
    lon = initial.longitude;
    time_stamp = DateTime.now().millisecondsSinceEpoch/1.0;
    velocity=0;
    distance_from_last=0;
   }
   CourseNode.followUp(Position initial,CourseNode previous){
     lat = initial.latitude;
     lon = initial.longitude;
     distance_from_last = Geolocator.distanceBetween(previous.lat, previous.lon, lat, lon);
     time_stamp = DateTime.now().millisecondsSinceEpoch/1.0;
     double timeEllapsedHours = (time_stamp-previous.time_stamp)/1000/3600;
     velocity = distance_from_last/1000/timeEllapsedHours;
   }
  CourseNode.fromJson(Map<String,dynamic> json){
     lat = json['lat'] as double;
     lon = json['lon'] as double;
     time_stamp = json['time_stamp'] as double;
     distance_from_last = json['distance_from_last'] as double;
     velocity = json['velocity'] as double;
   }
  String toString()=>this.toJson().toString();
  LatLng toLatLng() =>LatLng(lat,lon);
   Map<String,dynamic> toJson()=> {'lat':lat,'lon':lon,'distance_from_last':distance_from_last,'time_stamp':time_stamp,'velocity':velocity};

}