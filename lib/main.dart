import 'dart:async';
import 'dart:developer';
import 'package:facial_capture/home.dart';
import 'package:facial_capture/landing.dart';
import 'package:facial_capture/login.dart';
import 'package:facial_capture/models/count.dart';
import 'package:facial_capture/models/user.dart';
import 'package:facial_capture/screens/dialogs/splitArray.dart';
import 'package:facial_capture/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  runApp(
    MyApp()
  );
}


class MyApp extends StatelessWidget {
  // final countController = Count();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
        home: MultiProvider(
          providers: [
              StreamProvider<String>.value(initialData: eventProvider.count, value: eventProvider.strStream()),
              // StreamProvider<int>.value(value: eventProvider1.intStream()),
              // StreamProvider<int>.value(value: eventProvider2.intStream()),
              // ChangeNotifierProvider(builder: (_) => DataProvider(), create: (BuildContext context) {  },),
          ],
          child: Landing(),
        )
      ),
    );
  }
}
