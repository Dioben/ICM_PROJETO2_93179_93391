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
  TextEditingController namecontrol = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (signing || currentlynaming) {
      return StartLoad();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text("Sign up")
      // ),
      body: Padding(
        //maybe replace with column/expanded
        padding: const EdgeInsets.symmetric(
          vertical: 150,
        ),

        child: Row(
          children: [
            Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 8,
              child: Center(
                  child: Column(
                children: [
                  Expanded(
                      flex: 5,
                      child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                              controller: namecontrol,
                              decoration: InputDecoration(
                                labelText: "Name:",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide()
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),)),
                  Expanded(
                      flex: 5,
                      child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                              controller: emailcontrol,
                              decoration: InputDecoration(
                                labelText: "Email:",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide()
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),)),
                  Spacer(flex: 2),
                  Expanded(
                      flex: 5,
                      child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                              controller: passcontrol,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password:",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide()
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),)),
                  Expanded(
                      flex: 5,
                      child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                              // controller: passcontrol,
                              obscureText: true,
                              enabled: false,
                              decoration: InputDecoration(
                                labelText: "Confirm password:",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide()
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 16
                              ),
                            ),)),
                  Spacer(flex: 2),
                  Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Spacer(flex: 2),
                          Expanded(
                              flex: 8,
                              child: SizedBox(
                                  height: double.infinity,
                                  child: ElevatedButton(
                                    child: Text("Sign Up"),
                                    onPressed: () => naming
                                        ? setUsername(context)
                                        : signUp(context),
                                  ))),
                          Spacer(flex: 2)
                        ],
                      ))
                ],
              )),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }

  signUp(context) async {
    signing = true;
    setState(() {});
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailcontrol.text.trim(), password: passcontrol.text);
      naming = true;
      signing = false;
      setState(() {});
    } on FirebaseAuthException catch (e) {
      signing = false;
      setState(() {});
      print(e);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    if (naming) setUsername(context);
  }

  setUsername(context) async {
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
      print(e);
      currentlynaming = false;
    }
  }
}
