

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserStats extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(appBar: AppBar(title: Text("User Stats"),),
        body: Text("Name:  Guy mcGuy\nTop Score: -11\nTrack Count: 45e+20\nTotal Track Length: 2.-5km\nTotal Runtime: 30 years\nAverage Speed: 0.000km/h")
    );
  }
}