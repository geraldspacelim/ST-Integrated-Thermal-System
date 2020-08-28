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


class SplitArray extends StatefulWidget {
  final Filter filter;
  final String username;
  SplitArray({this.filter, this.username}); 
  @override
  _SplitArrayState createState() => _SplitArrayState();
}

class _SplitArrayState extends State<SplitArray> {

  int _count1; 
  int _count2; 
  StreamController _splitProfile1; 
  StreamController _splitProfile2; 

  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    _splitProfile1 = new StreamController();
    _splitProfile2 = new StreamController();
    Timer.periodic(Duration(seconds: 1), (_) => loadDetails());
  }

  loadDetails() async {
    // if (!_profilesController.isClosed) {
       await DatabaseService().profileDataST().then((res) async{
        _splitProfile1.add(res);
        _splitProfile2.add(res);
        return res;
    });
  }


  @override
  Widget build(BuildContext context) {
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
                    // _count1 = profiles.length;
                    return ProfileList(filter: new Filter(array:"1", temperature:this.widget.filter.temperature,  datetime:this.widget.filter.datetime, processed:this.widget.filter.processed), profiles:profiles, username: this.widget.username);
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
                    // _count2 = profiles.length;
                    return  ProfileList(filter: new Filter(array:"2", temperature:this.widget.filter.temperature,  datetime:this.widget.filter.datetime, processed:this.widget.filter.processed), profiles:profiles, username: this.widget.username);
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
              // _count1.toString(),
              '-',
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
              // _count2.toString(),
              '-',
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