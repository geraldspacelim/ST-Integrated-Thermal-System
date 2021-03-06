import 'dart:async';
import 'dart:convert';

import 'package:facial_capture/glob.dart';
import 'package:facial_capture/login.dart';
import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/profilelist.dart';
import 'package:facial_capture/screens/dialogs/filterDialog.dart';
import 'package:facial_capture/screens/dialogs/splitArray.dart';
import 'package:facial_capture/services/database.dart';
import 'package:facial_capture/widgets/gradientAppBar.dart';
import 'package:facial_capture/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:xml/xml.dart' as xml;
// import 'package:xml2json/xml2json.dart';

import 'models/profile.dart';
import 'models/profile.dart';
import 'services/database.dart';


class Home extends StatefulWidget {
  final String username, url; 
  Home({this.username, this.url});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // StreamController<Counter> ct;
  String _array;
  String _temperature; 
  String _datetime; 
  int _count = 0;
  // bool _loading = false; 
  bool _processed;
  String _username; 
  bool _showUsername = false;
  StreamController _profilesController;
  StreamController _countController;
  // final myTransformer = ();
  Timer timer;


  // filters 

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? 'test operator';
    _array = prefs.getString('arrayPref') ?? 'default';
    _temperature = prefs.getString('tempPref') ?? 'default';
    _datetime = prefs.getString('datetimePref') ?? 'default';
    _processed = prefs.getBool('processedPref') ?? false;
  }

  @override
  void initState() {
    _profilesController = BehaviorSubject(); 
    _countController = BehaviorSubject();
     timer = Timer.periodic(Duration(seconds: 2), (_) => loadDetails());
    super.initState();
    getSharedPrefs().then((_) => setState(() {
        _username = _username; 
        _array = _array; 
        _temperature = _temperature; 
        _processed = _processed;
        _datetime = _datetime;
      })
    );
  }

  loadDetails() async {
    if (!_profilesController.isClosed) {
      DatabaseService().profileDataST().then((res) async{
        _profilesController.add(res);
        return res;
      });
    }
    if (!_countController.isClosed) {
      _countController.add(Glob().allCount);
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    _profilesController.close();
    _countController.close();
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
        children: [
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          appBar: GradientAppBar(
            title: 'INTEGRATED THERMAL SYSTEM',
            gradientBegin: Color(0xff000428 ),
            gradientEnd: Color(0xff004e92),
          ),
          floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.7,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.sort,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                label: 'Filter',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () async {
                    final Filter filter = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FilterPage(filter: new Filter(array: _array, temperature: _temperature, datetime: _datetime, processed: _processed)),
                  ));
                  // print(filter.array);
                  // print(filter.temperature);
                  // print(filter.datetime);
                  // print(filter.processed);
                  if (filter != null) {
                      setState(() {
                    _array = filter.array == null ? "default" : filter.array; 
                    _temperature = filter.temperature  == null ? "default" : filter.temperature;
                    _datetime = filter.datetime  == null ? "default" : filter.datetime; 
                    _processed = filter.processed == null ? false: filter.processed; 
                  });
                  }
                },
              ), 
              SpeedDialChild(
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                backgroundColor: Colors.white,
                label: 'Logout',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                }
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.assignment_ind,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
                label: this.widget.username.toUpperCase(),
                labelStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                  ),
                labelBackgroundColor: Colors.purple,
                onTap: null
              ),
            ],
          ),
          body: _array == 'split' ? SplitArray(filter: new Filter(array: _array, temperature: _temperature, datetime: _datetime, processed: _processed), username: _username) : SafeArea(
            child: Column( 
              children: [
                Container(
                  child: StreamBuilder(
                    stream: _profilesController.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                          List<Profile> profiles = snapshot.data;
                          _count = profiles.length;
                          return Flexible(child: ProfileList(filter: new Filter(array:_array, temperature:_temperature,  datetime:_datetime, processed: _processed),profiles: profiles, username: _username));
                      } 
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(child: CircularProgressIndicator());
                        }
                    },
                  ),
                )
              ]
            )
          )
        ),
        _array == 'split' ? Container() : Positioned(
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
                    stream: _countController.stream,
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
          //   label: Text(
          //     '-',
          //     // _count.toString(),
          //     // '-',
          //     // _data.count.toString(),
          //     // xyz.count.toString(),
          //     // ct[0].toString(),
          //     // ct.split('-').toList()[0],
          //     style:TextStyle(
          //       color: Colors.black,
          //       fontSize: 25,
          //       fontWeight: FontWeight.bold
          //     )
          // )
          ),
        ),
      ]
    );
  }
}

// final eventProvider = EventProvider();
// // EventProvider (Stream)

// class EventProvider {
//   StreamController<String> sc = StreamController();
//   String count = "";
//   String previousCount = ""; 


//   Stream<String> strStream(){
//     return sc.stream;
//   }

//   updateCount (String updatedCount) {
//     sc.add(updatedCount);
//   }
// }