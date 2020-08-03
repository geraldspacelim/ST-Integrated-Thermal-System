import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
             Color(0xff000428),
              Color(0xff004e92),
          ],
        ),
      ),
      child: Center(
        child: SpinKitFadingCube(
          color: Colors.white,
          size: 50.0
        )
      )
    );
  }
}