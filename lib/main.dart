import 'package:facial_capture/home.dart';
import 'package:facial_capture/login.dart';
import 'package:facial_capture/models/count.dart';
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
  final countController = Count();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login() 
    );
  }
}

