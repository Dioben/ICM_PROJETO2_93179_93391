import 'dart:core';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'course.dart';

class courseComp{
   Course og;
   Course copy;
   LatLng current;
   int currentnode;
   bool validcopy;
   var errorcode;
   LatLng diffOG;
  CourseComp(Course original, Course dupe){
    og = original;
    copy=dupe;
    validcopy= true;
    currentnode=0;
    current = og.nodes.first.toLatLng();
  }


  void appendNode(Position local){
    CourseNode x;

    if(copy.nodes.length==0){ x= CourseNode.initial(local);}
    else{x= new CourseNode.followUp(local,copy.nodes.last);}
    copy.appendNode(x);
    if (validcopy) //validate proximity
        {
      while (distanceBetween(current.latitude, current.longitude, local.latitude, local.longitude)>50){
        currentnode++;

        if (currentnode>=copy.nodes.length){
          diffOG=LatLng(local.latitude,local.longitude);
          validcopy=false;
          copy.iscopy=false;
          copy.course_id=copy.uID;


          errorcode = "Has drifted over 50 meters from original course";
          break;
        }
        current = copy.nodes[currentnode].toLatLng();
      }

    }

  }
  bool isValidcopy(){return validcopy;}
  String getErrorcode(){return  errorcode;}
  LatLng getDiffOG(){return  diffOG;}

}