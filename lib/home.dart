import 'package:facial_capture/gradientAppBar.dart';
import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/profilelist.dart';
import 'package:facial_capture/screens/dialogs/filterDialog.dart';
import 'package:facial_capture/services/database.dart';
import 'package:facial_capture/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _array = '1';
  String _filter = 'temperature'; 
  String _sort = 'descending'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey,
      appBar: GradientAppBar(
        title: 'FEVER DETECTION SYSTEM',
        gradientBegin: Color(0xff43cea2),
        gradientEnd: Color(0xff185a9d)
      ),
      floatingActionButton: FloatingActionButton(
       onPressed: () async {
          final Filter filter = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FilterPage()),
        );
        setState(() {
          _array = filter.array == null ? _array : filter.array; 
          _filter = filter.filter  == null ? _array : filter.filter;
          _sort = filter.sort  == null ? _array : filter.sort; 
        });
       },
        child: Icon(
          Icons.sort,
          color: Colors.black,
          ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.3,
              child: StreamProvider<List<Profile>>.value(
                value: DatabaseService().profileDataArray1('1', _filter, _sort), 
                child: ProfileList(),
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
                value: DatabaseService().profileDataArray1('2', _filter, _sort), 
                child: ProfileList(),
              ),
            )
          ],
        ),
      )
    );
  }
}
