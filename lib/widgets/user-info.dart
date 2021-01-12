

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
            padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserItemField(title: "Name:", value: user.username, icon: Icons.person),
                UserItemField(title: "Top Rating:", value: user.top_rating.toString(), icon: Icons.star_border_outlined),
                UserItemField(title: "Track Count:", value: user.coursecount.toString(), icon: Icons.edit_road_rounded),
                UserItemField(title: "Total Track Length:", value: user.formattedTrackLength(), icon: Icons.show_chart_rounded),
                UserItemField(title: "Total Runtime:", value: user.formattedRuntime(), icon: Icons.timer_rounded),
                UserItemField(title: "Max Speed:", value: user.formattedMaxSpeed(), icon: Icons.directions_run_rounded),
                UserItemField(title: "Average Speed:", value: user.formattedAvgSpeed(), icon: Icons.directions_walk_rounded),
              ],
            )

        )

    );
  }
}

class UserItemField extends StatefulWidget {
  UserItemField({Key key, @required this.title, @required this.value, @required this.icon})
      : super(key: key);
  final String title;
  final String value;
  final IconData icon;

  @override
  _UserItemFieldState createState() => new _UserItemFieldState();
}

class _UserItemFieldState extends State<UserItemField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 20,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(widget.value, style: TextStyle(fontSize: 17)),
                    Container(child: Icon(widget.icon, size: 18,), margin: EdgeInsets.fromLTRB(2,0,0,0),),
                  ],
                ),
              ],
            )),
        Container(
          height: 2,
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(20, 3, 20, 10),
          child: SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
          ),
        ),
      ],
    );
  }
}