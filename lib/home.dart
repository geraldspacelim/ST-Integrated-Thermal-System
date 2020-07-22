import 'package:facial_capture/gradientAppBar.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/profilelist.dart';
import 'package:facial_capture/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black,
      appBar: GradientAppBar(
        title: 'FEVER DETECTION SYSTEM',
        gradientBegin: Color(0xff43cea2),
        gradientEnd: Color(0xff185a9d)
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.3,
              child: StreamProvider<List<Profile>>.value(
                value: DatabaseService().profileDataArray1('temperature', '1'), 
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
                value: DatabaseService().profileDataArray1('temperature', '2'), 
                child: ProfileList(),
              ),
            )
          ],
        ),
      )
    );
  }
}