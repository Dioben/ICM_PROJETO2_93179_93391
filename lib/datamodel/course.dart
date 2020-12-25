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
   Course.fromDocument(docData){this.timestamp=docData['timestamp'];
                                this.runtime=docData['runtime'];
                                this.user=docData['user'];
                                this.uID=docData['uID'];
                                this.track_length = docData['track_length'];
                                this.max_speed = docData['max_speed'];
                                this.avg_speed = docData['avg_speed'];
                                this.rating = docData['rating'];
                                this.course_id = docData['course_id'];
                                this.iscopy = docData['iscopy'];
                                this.isprivate=docData['isprivate'];
                                this.anon =docData['anon'];
                                this.name = docData['name'];
                                this.lat = docData['lat'];
                                this.lon= docData['lon'];
                                //TODO: figure out how to pass pics and nodes into lists
          }
   String toJson(){return null;}
}

class CourseNode {
   double time_stamp; //gonna have to use system.nano timing cuz duration is api 26
   double distance_from_last;
   double velocity;// km/h
   double lat; //saving location to firebase is tricky so we're using this instead
   double lon;

   CourseNode Initial(Position initial){
    lat = initial.latitude;
    lon = initial.longitude;
    time_stamp = DateTime.now().millisecondsSinceEpoch as double;
    velocity=0;
    distance_from_last=0;
   }
   CourseNode FollowUp(Position initial,CourseNode previous){
     lat = initial.latitude;
     lon = initial.longitude;
     distance_from_last = Geolocator.distanceBetween(previous.lat, previous.lon, lat, lon);
     time_stamp = DateTime.now().millisecondsSinceEpoch as double;
     double time_ellapsed_hours = (time_stamp-previous.time_stamp)/1000/3600;
     velocity = distance_from_last/1000/time_ellapsed_hours;
   }

  LatLng toLatLng() =>LatLng(lat,lon);
}