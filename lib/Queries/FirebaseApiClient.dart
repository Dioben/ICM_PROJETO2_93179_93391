import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_keeper/datamodel/User.dart';
import 'package:track_keeper/datamodel/course.dart';
import 'package:vector_math/vector_math.dart';
class FirebaseApiClient{
  static CollectionReference mainCollection;
  static AppUser user;
  static DocumentReference userUpstream;
  static CollectionReference userCourses;
  static Reference imagefolder;
  static final FirebaseApiClient instance = FirebaseApiClient._construct();

  factory FirebaseApiClient.getInstance(){return instance;}
  static FirebaseApiClient _construct() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    mainCollection = db.collection("courses");
    imagefolder = FirebaseStorage.instance.ref("images");
  }

  Future<bool>  postImage() async{
  //image stuff here, unsure how filepath and stuff is gonna work so putting a stub only
    //return true if success, false otherwise
  }

  void setUser(User user) async{
    userUpstream= FirebaseFirestore.instance.collection("users").doc(user.uid);
    userCourses = FirebaseFirestore.instance.collection("privatecourses").doc("mandatory").collection(user.uid);
    userUpstream.get().then((value){
                          if (value.exists){
                                  FirebaseApiClient.user = AppUser.fromJson(value.data());
                          }else{
                            FirebaseApiClient.user = AppUser();
                          }
    });
  }
  submitCourse(Course course) async{
    user.total_runtime+=course.runtime;
    user.total_tracklength+=course.track_length;
    user.avg_speed = user.total_tracklength/user.total_runtime/1000/3600;
    user.max_speed = max(user.max_speed, course.max_speed);
    user.top_rating=max(user.top_rating,course.rating);
    if (!course.isprivate){
      mainCollection.add(course.toJson());
      userUpstream.set(user.toJson());
    }
    userCourses.add(course.toJson());
  }

   Stream<Course> getNearbyRecent(LatLng coords, int limit) async*{
    double r = 100.0/6371.0; //100 km over earth radius
    double latmin = degrees(radians(coords.latitude)-r);
    double latmax = degrees(radians(coords.latitude)+r);

    double deltaLon = degrees(asin(sin(r)/cos(radians(coords.longitude))));
    double longmin = coords.longitude-deltaLon;
    double longmax = coords.longitude+deltaLon;

    QuerySnapshot result = await mainCollection.orderBy("timestamp",descending: true).limit(limit*20).get();
    result.docs.forEach((element) async* {
        Map<String,dynamic> data = element.data();
        if (element['lat']>latmin && element['lat']<latmax && element['lon']<longmin && element['lon']<longmax) yield Course.fromJson(data);
      });




  }

}