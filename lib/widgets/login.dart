import 'package:flutter/material.dart';

import 'mainmenu.dart';

class LoginMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginMenu>{
  bool logging = false; //display a spinny thing while logging in i guess
  String name;//putting this here in case we've gotta persist this on failed logins
  String password;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

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
                  Expanded(flex:5,child: SizedBox(width:double.infinity,child: ElevatedButton(child: Text("Username Field"),onPressed: ()=>{}))),
                  Spacer(flex:2),
                  Expanded(flex:5,child: SizedBox(width:double.infinity,child: ElevatedButton(child: Text("Password Field"),onPressed: ()=>{},))),
                  Spacer(flex:2),
                  Expanded(flex:5,child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [Expanded(flex:8,child: SizedBox(height:double.infinity,child: ElevatedButton(child: Text("Login"),onPressed: ()=>skipAhead(context),))),Spacer(flex:1),Expanded(flex:8,child: SizedBox(height: double.infinity,child: ElevatedButton(child: Text("Sign In"),onPressed: ()=>{},)))],)),

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

  login(){
    logging=true;
    setState(() {});
  }
  void skipAhead(context) {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MainMenu()));
  }
}


