import 'dart:async';

import 'package:facial_capture/models/count.dart';
import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/profilelist.dart';
import 'package:facial_capture/screens/dialogs/filterDialog.dart';
import 'package:facial_capture/screens/dialogs/splitArray.dart';
import 'package:facial_capture/services/database.dart';
import 'package:facial_capture/widgets/gradientAppBar.dart';
import 'package:facial_capture/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // StreamController<int> ct;
  String _array = 'default';
  String _tempertaure = 'default'; 
  String _datetime = 'default'; 
  // int _count = 0;
  bool _loading = true; 
  @override
  // void initState() {
  //   super.initState();
  //   if (DatabaseService().profileData() != null) {
  //     setState(() {
  //       _loading = false; 
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
     if (DatabaseService().profileData() != null) {
      setState(() {
        _loading = false; 
      });
    }
    // var ct = Provider.of<int>(context);
    return  _loading ? Loading() : Stack(
        children: [
          Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.blueGrey,
          appBar: GradientAppBar(
            title: 'INTEGRATED THERMAL SYSTEM',
            gradientBegin: Color(0xff000428 ),
            gradientEnd: Color(0xff004e92),
          ),
          floatingActionButton: FloatingActionButton(
          onPressed: () async {
              final Filter filter = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FilterPage()),
            );
            print(filter.array);
            print(filter.temperature);
            print(filter.datetime);
            
            setState(() {
              _array = filter.array == null ? "default" : filter.array; 
              _tempertaure = filter.temperature  == null ? "default" : filter.temperature;
              _datetime = filter.datetime  == null ? "default" : filter.datetime; 
            });
          },
            child: Icon(
              Icons.sort,
              color: Colors.black,
              ),
            backgroundColor: Colors.white,
          ),
          body: _array == 'split' ? SplitArray(filter: new Filter(array: _array, temperature: _tempertaure, datetime: _datetime)) : SafeArea(
            child: Column( 
              children: [
               Container(
                  child: StreamProvider<List<Profile>>.value(
                    value: DatabaseService().profileData(), 
                    child: Flexible(child: ProfileList(filter: new Filter(array:_array, temperature:_tempertaure,  datetime:_datetime))),
                  ),
                ),
                
              ]
            )
          )
        ),
        _array == 'split' ? Container() : Positioned(
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
              "50",
              // ct.toString(),
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
