import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/profilelist.dart';
import 'package:facial_capture/screens/dialogs/filterDialog.dart';
import 'package:facial_capture/screens/dialogs/splitArray.dart';
import 'package:facial_capture/services/database.dart';
import 'package:facial_capture/widgets/gradientAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _array = 'default';
  String _tempertaure = 'default'; 
  String _datetime = 'default'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey,
      appBar: GradientAppBar(
        title: 'FEVER DETECTION SYSTEM',
        gradientBegin: Color(0xff43cea2),
        gradientEnd: Color(0xff185a9d),
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
          _array = filter.array == null ? _array : filter.array; 
          _tempertaure = filter.temperature  == null ? _array : filter.temperature;
          _datetime = filter.datetime  == null ? _array : filter.datetime; 
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
                value: DatabaseService().profileData(_array, _tempertaure, _datetime), 
                child: ProfileList(),
              ),
            ),
          ]
         )
      )
    );
  }
}
