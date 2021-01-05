import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';

import 'mainmenu.dart';

bool signing = false;
bool naming = false; //return different widget that calls setUsername instead of signUp if this is true
bool currentlynaming = false;
signUp() async{
  signing=true;
  setState(() {});
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "sample text",
        password: "sample text"
    );
    naming=true;
    signing=false;
    setState(() {});

  } on FirebaseAuthException catch (e) {
    signing=false;
    setState(() {});
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
  if (naming)  setUsername();

}

setUsername() async{ //separated in case the whole process fails to go through
  currentlynaming=true; //prevent button spam, maybe loading screen? idk if loading screen setState here
  try {
    await FirebaseAuth.instance.currentUser.updateProfile(displayName: "sample text");
    await FirebaseApiClient.instance.setUser(FirebaseAuth.instance.currentUser);
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MainMenu()));
  }catch(e){print(e);currentlynaming=false;}
}