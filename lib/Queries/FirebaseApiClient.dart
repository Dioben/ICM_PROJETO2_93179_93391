import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApiClient{
  static CollectionReference mainCollection;
  static User user;
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
}