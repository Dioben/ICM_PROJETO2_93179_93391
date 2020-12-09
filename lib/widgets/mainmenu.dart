import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body:Padding(
        padding: const EdgeInsets.symmetric(vertical: 150,horizontal: 20),
        child: Center(
          child: Column(children: [
            Stack(
            children: [ Text("Track Keeper",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,foreground: Paint()..style=PaintingStyle.stroke..strokeWidth=3..color=Colors.black),),
              Text("Track Keeper",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.green),),],
          ),
            SizedBox(height:20),
            RaisedButton(child: Text("Free Play"),),
            SizedBox(height:20),
            RaisedButton(child: Text("Tracks"),),
            SizedBox(height:20),
            RaisedButton(child: Text("User Stats"),),
            SizedBox(height:20),
            Row(mainAxisAlignment:MainAxisAlignment.center,children: [RaisedButton(child: Text("Logout")),SizedBox(width: 10,),RaisedButton(child: Text("Settings"))],),

          ],

          ),
    ),
      ),
    );
  }
}