import 'dart:io';
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
  FirebaseApiClient._construct() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    mainCollection = db.collection("courses");
    imagefolder = FirebaseStorage.instance.ref("images");
  }

  Future<String>  postImage(File image) async{
    String name = user.uid+DateTime.now().toString()+".png";
    Reference thispic = imagefolder.child(name);
    try {
      await thispic.putFile(image);
      String url = await thispic.getDownloadURL();
      return url;
    }on FirebaseException catch (e) {
    return null;
    }

  }

  void setUser(User user) async{
    userUpstream= FirebaseFirestore.instance.collection("users").doc(user.uid);
    userCourses = FirebaseFirestore.instance.collection("privatecourses").doc("mandatory").collection(user.uid);
    userUpstream.get().then((value){
                          if (value.exists){
                                  FirebaseApiClient.user = AppUser.fromJson(value.data());
                          }else{
                            FirebaseApiClient.user = AppUser(user);
                          }
    });
  }
  submitCourse(Course course) async{
    user.total_runtime+=course.runtime;
    user.total_tracklength+=course.track_length;
    user.avg_speed = user.total_tracklength/user.total_runtime/1000/3600;
    user.max_speed = max(user.max_speed, course.max_speed);
    user.top_rating=max(user.top_rating,course.rating);
    user.coursecount++;
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
    Iterator it = result.docs.iterator;
    while (it.moveNext()){
      DocumentSnapshot element = it.current;
      Map<String,dynamic> data = element.data();
      if (element['lat']>latmin && element['lat']<latmax && element['lon']>longmin && element['lon']<longmax){ yield Course.fromJson(data);}
    }


    
  }
  Stream<Course> getNearbyTopRated(LatLng coords, int limit) async*{
    double r = 100.0/6371.0; //100 km over earth radius
    double latmin = degrees(radians(coords.latitude)-r);
    double latmax = degrees(radians(coords.latitude)+r);

    double deltaLon = degrees(asin(sin(r)/cos(radians(coords.longitude))));
    double longmin = coords.longitude-deltaLon;
    double longmax = coords.longitude+deltaLon;

    QuerySnapshot result = await mainCollection.orderBy("rating",descending: true).limit(limit*20).get();
    Iterator it = result.docs.iterator;
    while (it.moveNext()){
      DocumentSnapshot element = it.current;
      Map<String,dynamic> data = element.data();
      if (element['lat']>latmin && element['lat']<latmax && element['lon']>longmin && element['lon']<longmax){ yield Course.fromJson(data);}
    }
  }

  Stream<Course> getMyCourses() async*{
    QuerySnapshot result = await userCourses.orderBy("timestamp", descending: true).get();
    Iterator it = result.docs.iterator;
    while (it.moveNext()){
      DocumentSnapshot element = it.current;
      Map<String,dynamic> data = element.data();
      yield Course.fromJson(data);
    }
  }

  Stream<Course> getMyCoursesByRating() async*{
    QuerySnapshot result = await userCourses.orderBy("rating", descending: true).get();

    Iterator it = result.docs.iterator;
    while (it.moveNext()){
      DocumentSnapshot element = it.current;
      Map<String,dynamic> data = element.data();
      yield Course.fromJson(data);
    }
  }
  Stream<Course> getOtherRuns(Course course) async*{
    String uid = course.course_id;
    int ts = course.timestamp;
    QuerySnapshot result = await userCourses.where('course_id',isEqualTo: uid).get();
    Iterator it = result.docs.iterator;
    while (it.moveNext()){
      DocumentSnapshot element = it.current;
      Map<String,dynamic> data = element.data();
      if (data['ts']!=ts || data['uID']!=uid){yield Course.fromJson(data);}
    }

  }

}