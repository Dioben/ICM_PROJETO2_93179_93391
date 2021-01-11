import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/widgets/start-load.dart';
import 'mainmenu.dart';

class SignUpMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignUpState();
}

class SignUpState extends State<SignUpMenu> {
  bool signing = false;
  bool naming =
      false; //return different widget that calls setUsername instead of signUp if this is true
  bool currentlynaming = false;

  TextEditingController emailcontrol = TextEditingController();
  TextEditingController passcontrol = TextEditingController();
  TextEditingController passconfcontrol = TextEditingController();
  TextEditingController namecontrol = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String errorCode;

  @override
  Widget build(BuildContext context) {
    if (signing || currentlynaming) {
      return StartLoad();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sign up")
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.fromLTRB(0, 0, 0, AppBar().preferredSize.height),
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: TextFormField(
                    controller: namecontrol,
                    decoration: InputDecoration(
                      labelText: "Name:",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide()),
                    ),
                    style: TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please write a name";
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: TextFormField(
                    controller: emailcontrol,
                    decoration: InputDecoration(
                      labelText: "Email:",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide()),
                    ),
                    style: TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please write an email";
                      else if (errorCode != null)
                        if (errorCode == "email-already-in-use")
                          return "Email unavailable";
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: TextFormField(
                    controller: passcontrol,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password:",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide()),
                    ),
                    style: TextStyle(fontSize: 16),
                    validator: (value) {
                      if (value.isEmpty)
                        return "Please write a password";
                      else if (passconfcontrol.text != passcontrol.text)
                        return "Passwords don't match";
                      else if (errorCode != null)
                        if (errorCode == "weak-password")
                          return "Password should be at least 6 characters long";
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: TextFormField(
                    controller: passconfcontrol,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm password:",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide()),
                    ),
                    style: TextStyle(fontSize: 16),
                    validator: (value) {
                      if (passconfcontrol.text != passcontrol.text)
                        return "Passwords don't match";
                      return null;
                    },
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    width: 160,
                    height: 45,
                    child: ElevatedButton(
                      child: Text(
                        "Sign up",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        if (naming)
                          await setUsername();
                        else {
                          await signUp();
                        }
                        _formKey.currentState.validate();
                        errorCode = null;
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  signUp() async {
    signing = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailcontrol.text.trim(), password: passcontrol.text);
      naming = true;
      signing = false;
    } on FirebaseAuthException catch (e) {
      signing = false;
      errorCode = e.code;
      setState(() {});
    }
    if (naming) await setUsername();
  }

  setUsername() async {
    //separated in case the whole process fails to go through
    currentlynaming =
        true; //prevent button spam, maybe loading screen? idk if loading screen setState here
    try {
      await FirebaseAuth.instance.currentUser
          .updateProfile(displayName: namecontrol.text.trim());
      FirebaseApiClient.instance.setUser(FirebaseAuth.instance.currentUser);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainMenu()));
    } catch (e) {
      currentlynaming = false;
    }
  }
}