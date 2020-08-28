import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:facial_capture/home.dart';
import 'package:facial_capture/landing.dart';
import 'package:facial_capture/login.dart';
import 'package:facial_capture/models/count.dart';
import 'package:facial_capture/models/user.dart';
import 'package:facial_capture/screens/dialogs/splitArray.dart';
import 'package:facial_capture/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  _enablePlatformOverrideForDesktop();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  runApp(
    MyApp()
  );
}

void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}


class MyApp extends StatelessWidget {
  // final countController = Count();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Login(),
        // home: FilterPage(filter:new Filter(array: 'default', temperature: 'default', datetime: 'default', processed: false)),
      );
    // );
  }
}
