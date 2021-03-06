import 'dart:async';
import 'dart:developer';

import 'package:facial_capture/glob.dart';
import 'package:facial_capture/home.dart';
import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/profilelist.dart';
import 'package:facial_capture/services/database.dart';
import 'package:facial_capture/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';


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
  StreamController _countController1;
  StreamController _countController2;
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
    _splitProfile1 = new StreamController();
    _splitProfile2 = new StreamController();
    _countController1 = new StreamController();
    _countController2 = new StreamController();
    if (!_splitProfile1.isClosed && !_splitProfile2.isClosed) {
      timer = Timer.periodic(Duration(seconds: 2), (_) => loadDetails());
    }
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    _splitProfile1.close();
    _splitProfile2.close();
    _countController1.close();
    _countController2.close();
  }

  loadDetails() async {
    if (!_splitProfile1.isClosed && !_splitProfile2.isClosed) {
        DatabaseService().profileDataST().then((res) async{
        _splitProfile1.add(res);
        _splitProfile2.add(res);
        return res;
    });
    }
    if (!_countController1.isClosed && !_countController2.isClosed) {
      _countController1.add(Glob().arrayCount1);
      _countController2.add(Glob().arrayCount2);
    }

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
                  child: StreamBuilder(
                    stream: _splitProfile1.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                          List<Profile> profiles = snapshot.data;
                          // _count = profiles.length;
                           return  Flexible(child: ProfileList(filter: new Filter(array:"1", temperature:this.widget.filter.temperature,  datetime:this.widget.filter.datetime, processed:this.widget.filter.processed), profiles:profiles, username: this.widget.username));
                      } 
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(child: CircularProgressIndicator());
                        }
                    },
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
              StreamBuilder(
                    stream: _splitProfile2.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                          List<Profile> profiles = snapshot.data;
                          // _count = profiles.length;
                           return  Flexible(child: ProfileList(filter: new Filter(array:"2", temperature:this.widget.filter.temperature,  datetime:this.widget.filter.datetime, processed:this.widget.filter.processed), profiles:profiles, username: this.widget.username));
                      } 
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(child: CircularProgressIndicator());
                        }
                    },
                  ),
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
           label: StreamBuilder(
                    stream: _countController1.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                          return Text(
                                snapshot.data.toString(),
                                style:TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                                )
                            );
                    
                      }                
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Text('-');
                        }
                    },
                  ),
          ),
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
            label: StreamBuilder(
                    stream: _countController2.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                          return Text(
                                snapshot.data.toString(),
                                style:TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold
                                )
                            );
                    
                      }                
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Text('-');
                        }
                    },
                  ),
          ),
        ),
      ] 
     );
  }
}