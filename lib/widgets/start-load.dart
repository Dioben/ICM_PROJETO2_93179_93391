// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:track_keeper/widgets/mainmenu.dart';



class StartLoad extends StatefulWidget {
  const StartLoad({Key key}) : super(key: key);


  @override
  _StartLoadState createState() => _StartLoadState();
}

class _StartLoadState extends State<StartLoad>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.9, curve: Curves.linear),
      reverseCurve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }



  Widget _buildIndicators(BuildContext context, Widget child) {

        return CircularProgressIndicator(strokeWidth: 8,valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFFC0C0C0)),);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("images/map.png",height: double.infinity,width: double.infinity,fit: BoxFit.cover,),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  
                  children: [Container(
                    height: 250,
                    width: 250,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: _buildIndicators,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:50),

                    child: Stack(
                      children: [
                        Text("We'll be moving you along shortly",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,foreground: Paint()..style=PaintingStyle.stroke..strokeWidth=2..color=Colors.grey),),
                        Text("We'll be moving you along shortly",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
                  ]
                ),
              ),
            ),
          ),
       ]
      ),
    );
  }

}

