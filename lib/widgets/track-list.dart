import 'package:flutter/material.dart';
import 'package:track_keeper/widgets/track-info.dart';

class ViewTrackList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ViewListState();
}

class ViewListState extends State<ViewTrackList>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text("Track List"),),
        body: Column(children: [Expanded(flex: 3,child: TrackTypeSelector(notifyParent: updateSelection,)),
                                Expanded(flex: 9,
                                    child:SingleChildScrollView(
                                    child:ListView.separated(shrinkWrap: true,
                                        itemBuilder: (BuildContext context,int index){
                                          return InkWell(child: Ink(color: Colors.green,height: 50,child: Text("TRACK"),) ,onTap: ()=>goToInfo(),);
                                        },
                                        separatorBuilder: (BuildContext context, int index)=>Divider(),
                                        itemCount: 5)
                                )
                                )
        ],)
        );
  }

  updateSelection(int selector,String value){

  }

  goToInfo() { Navigator.push(context,MaterialPageRoute(builder: (context) => TrackInfoActivity(course: null,)));}
}

class TrackTypeSelector extends StatefulWidget{
  final Function(int,String) notifyParent;
  TrackTypeSelector({Key key,@required this.notifyParent}):super(key:key);
  @override
  State<StatefulWidget> createState() =>TrackTypeSelectionState();
}

class TrackTypeSelectionState extends State<TrackTypeSelector> {
  String owner = "Anyone";
  String sort = "Date";

  @override
  Widget build(BuildContext context) {
    return Row(children: [Expanded(
      child: Center(
        child: DropdownButton<String>(onChanged: (String newval) {
          setState(() => owner = newval);widget.notifyParent(1,newval);
        },
          value: owner,hint: Text("Owner:"),
          items: <String>['Anyone', 'Me']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),);
          }).toList(),),
      ),
    ),
      Expanded(
        child: Center(
          child: DropdownButton<String>(onChanged: (String newval) {
            setState(() => sort = newval);widget.notifyParent(2,newval);
          },
            value: sort,hint: Text("Sort by:"),
            items: <String>['Date', 'Rating']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),);
            }).toList(),),
        ),
      )
    ],);
  }
}