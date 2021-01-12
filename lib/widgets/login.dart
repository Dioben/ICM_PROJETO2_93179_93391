import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/widgets/sign-up.dart';
import 'mainmenu.dart';

class LoginMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginMenu> {
  bool logging = false; //display a spinny thing while logging in i guess

  TextEditingController namecontrol = TextEditingController();
  TextEditingController passcontrol = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String errorCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Track Keeper",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                      shadows: [
                        Shadow(
                            color: Colors.black45,
                            blurRadius: 1,
                            offset: Offset(1, 1.5))
                      ]
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: TextFormField(
                      controller: namecontrol,
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
                          if (errorCode == "invalid-email" || errorCode == "user-not-found")
                            return "Invalid email";
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
                        else if (errorCode != null)
                          if (errorCode == "wrong-password")
                            return "Wrong password";
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
                        "Login",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        await login();
                        _formKey.currentState.validate();
                        errorCode = null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                            )),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
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
                      onPressed: () => SignIn(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  login() async {
    if (logging) {
      return;
    }
    logging = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: namecontrol.text.trim(), password: passcontrol.text);
      await FirebaseApiClient.instance.setUser(userCredential.user);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainMenu()));
    } on FirebaseAuthException catch (e) {
      logging = false;
      setState(() {
        errorCode = e.code;
      });
      if (e.code == "too-many-requests") {
        print(e.code + " -> " + e.toString()); // Should be shown in some way to the user
      }
    }
  }

  void SignIn(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpMenu()));
  }
}
