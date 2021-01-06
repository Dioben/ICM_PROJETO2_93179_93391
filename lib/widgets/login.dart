import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';

import 'mainmenu.dart';

class LoginMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginMenu>{
  bool logging = false; //display a spinny thing while logging in i guess

  TextEditingController namecontrol = TextEditingController();
   TextEditingController passcontrol = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body:Padding(//maybe replace with column/expanded
        padding: const EdgeInsets.symmetric(vertical: 150,),

        child: Row(
          children: [
            Spacer(flex: 2,),
            Expanded(
              flex: 6,
              child: Center(
                child: Column(children: [

                  Expanded(
                    flex:4,
                    child: Stack(
                      children: [ Text("Welcome",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,foreground: Paint()..style=PaintingStyle.stroke..strokeWidth=2..color=Colors.black),),
                        Text("Welcome",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.green),),],
                    ),
                  ),
                  Spacer(flex:2),
                  Expanded(flex:5,child: SizedBox(width:double.infinity,child: TextField(controller: namecontrol,decoration: InputDecoration(hintText: "email"),))),
                  Spacer(flex:2),
                  Expanded(flex:5,child: SizedBox(width:double.infinity,child: TextField(controller: passcontrol,obscureText: true,decoration: InputDecoration(hintText: "password"),))),
                  Spacer(flex:2),
                  Expanded(flex:4,child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [Expanded(flex:8,child: SizedBox(height:double.infinity,child: ElevatedButton(child: Text("Login"),onPressed: ()=>login(),))),Spacer(flex:1),Expanded(flex:8,child: SizedBox(height: double.infinity,child: ElevatedButton(child: Text("Sign In"),onPressed: ()=>skipAhead(context),)))],)),

                ],

                ),
              ),
            ),
            Spacer(flex: 2,),
          ],
        ),
      ),
    );
  }

  login() async{
    if (logging){return;}
    logging=true;
    setState(() {});
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: namecontrol.text.trim(),
          password: passcontrol.text
      );
      await FirebaseApiClient.instance.setUser(userCredential.user);
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MainMenu()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  void skipAhead(context) {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MainMenu()));
  }
}


