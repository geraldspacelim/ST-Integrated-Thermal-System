import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/profilelist.dart';
import 'package:facial_capture/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SplitArray extends StatelessWidget {
  final Filter filter;
  SplitArray({this.filter}); 
  @override
  Widget build(BuildContext context) {
     return Stack(
      children: [
        SafeArea(
          child: Column( 
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.3,
                child: StreamProvider<List<Profile>>.value(
                  value: DatabaseService().profileData(), 
                  child: ProfileList(filter: new Filter(array:"1", temperature:filter.temperature,  datetime:filter.datetime, processed: filter.processed)),
                ),
              ),
              // SizedBox(height: MediaQuery.of(context).size.height/4),
                const Divider(
                color: Colors.white,
                // height: 20,
                indent: 15,
                endIndent: 15,
                thickness: 3,
              ),
              Container(
                height:  MediaQuery.of(context).size.height / 2.3,
                child: StreamProvider<List<Profile>>.value(
                  value: DatabaseService().profileData(), 
                  child: ProfileList(filter: new Filter(array:"2", temperature:filter.temperature,  datetime:filter.datetime, processed:filter.processed)),
                ),
              )
            ],
          ),
       ),
      Positioned(
          left:20.0,
          bottom:435.0,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
            color: Colors.white,
            onPressed: () {}, 
            icon: Icon(
              Icons.people,
              size: 30,
              ), 
            label: Text(
              "100",
              style:TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold
              )
          )),
        ),
        Positioned(
          left:20.0,
          bottom:20.0,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
            color: Colors.white,
            onPressed: () {}, 
            icon: Icon(
              Icons.people,
              size: 30,
              ), 
            label: Text(
              "100",
              style:TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold
              )
          )),
        ),
      ] 
     );
  }
}