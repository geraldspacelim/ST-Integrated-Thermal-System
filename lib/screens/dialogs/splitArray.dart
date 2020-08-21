import 'dart:async';
import 'dart:developer';

import 'package:facial_capture/home.dart';
import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/profilelist.dart';
import 'package:facial_capture/services/database.dart';
import 'package:facial_capture/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SplitArray extends StatelessWidget {
  final Filter filter;
  final String username;
  SplitArray({this.filter, this.username}); 
  StreamController<Counter> cs;
  bool _loading = true; 
  String _ct1;
  String _ct2; 
  int _count1; 
  int _count2;

  @override
  Widget build(BuildContext context) {
    var ct = Provider.of<String>(context);
    try {
      _ct1 = ct.split('-').toList()[1];
      _ct2 = ct.split('-').toList()[2];
    } catch (RangeError)  {
      _ct1 = '-';
      _ct2 = '-';
    }
    // print(ct.toString());
    // print(cs.toString());
     return Stack(
      children: [
        SafeArea(
          child: Column( 
            children: [
              Container(
                height:  MediaQuery.of(context).size.height / 2.3,
                child: FutureBuilder<List<Profile>>(
                  future: DatabaseService().profileDataST(),
                  builder:  (context, snapshot) {
                    List<Profile> profiles = snapshot.data;
                    _count1 = profiles.length;
                    return ProfileList(filter: new Filter(array:"1", temperature:filter.temperature,  datetime:filter.datetime, processed:filter.processed), profiles:profiles, username: username);
                  }
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
                child: FutureBuilder<List<Profile>>(
                  future: DatabaseService().profileDataST(),
                  builder:  (context, snapshot) {
                    List<Profile> profiles = snapshot.data;
                    _count2 = profiles.length;
                    return  ProfileList(filter: new Filter(array:"2", temperature:filter.temperature,  datetime:filter.datetime, processed:filter.processed), profiles: profiles, username: username);
                  }
                ),
              )
            ],
          ),
       ),
      Positioned(
          left:MediaQuery.of(context).size.width/30,
          bottom:MediaQuery.of(context).size.height/2.1,
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
              _count1.toString(),
              // '-',
              style:TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold
              )
          )),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width/30,
          bottom:MediaQuery.of(context).size.height/45,
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
              // cs.countStream2.toString(),
              // cs[1].toString(),
              _count2.toString(),
              // '-',
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
