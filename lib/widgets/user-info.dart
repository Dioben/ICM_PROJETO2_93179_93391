

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:track_keeper/Queries/FirebaseApiClient.dart';
import 'package:track_keeper/datamodel/User.dart';

class UserStats extends StatelessWidget{
  AppUser user = FirebaseApiClient.user;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(user);
    return Scaffold(appBar: AppBar(title: Text("User Stats"),),
        body:
        Container(
            padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                        height: 20,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 0, 80, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Name:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user.username, style: TextStyle(fontSize: 17)),
                          ],
                        )
                    ),
                    Container(
                      height: 3,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 3, 80, 10),
                      child: SizedBox(
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        height: 20,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Top Score:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user.top_rating.toString(), style: TextStyle(fontSize: 17)),
                          ],
                        )
                    ),
                    Container(
                      height: 3,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 3, 20, 10),
                      child: SizedBox(
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        height: 20,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Track Count:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user.coursecount.toString(), style: TextStyle(fontSize: 17)),
                          ],
                        )
                    ),
                    Container(
                      height: 3,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 3, 20, 10),
                      child: SizedBox(
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        height: 20,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Track Length:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user.formattedTrackLength(), style: TextStyle(fontSize: 17)),
                          ],
                        )
                    ),
                    Container(
                      height: 3,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 3, 20, 10),
                      child: SizedBox(
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        height: 20,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Runtime:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user.formattedRuntime(), style: TextStyle(fontSize: 17)),
                          ],
                        )
                    ),
                    Container(
                      height: 3,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 3, 20, 6),
                      child: SizedBox(
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                        height: 20,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Max Speed:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user.formattedMaxSpeed(), style: TextStyle(fontSize: 17)),
                          ],
                        )
                    ),
                    Container(
                      height: 3,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 3, 20, 6),
                      child: SizedBox(
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Container(
                        height: 20,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Average Speed:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(user.formattedAvgSpeed(), style: TextStyle(fontSize: 17)),
                          ],
                        )
                    ),
                    Container(
                      height: 3,
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(20, 3, 20, 6),
                      child: SizedBox(
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.green),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )

        )

    );
  }
}