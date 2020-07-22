import 'dart:async';

import 'package:facial_capture/models/temperature.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class TemperatureDialog extends StatefulWidget {
  double temperature; 
  TemperatureDialog({this.temperature});
  @override
  _TemperatureDialogState createState() => _TemperatureDialogState();
}

class _TemperatureDialogState extends State<TemperatureDialog> {
  double _temperature;
  String _remarks = ""; 
  int _datetime = 0; 
  Timer _timer;

  @override
  void initState() {
    _temperature = widget.temperature;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  // _temperature = widget.temperature;
  return Dialog(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
  child: Container(
    height: 300.0,
    width: 300.0,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
            height: 40,
            width: 40, // 
              child: ClipOval(
                child: Material(
                  color: Colors.black, // button color
                  child: GestureDetector(
                    onTap: () {
                       setState(() {
                          _temperature -= 0.1; 
                        });
                    }, // splash color
                    onTapDown: (TapDownDetails details) {
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          _temperature -= 0.1; 
                        });
                       });
                    },
                    onTapUp: (TapUpDetails details) {
                      _timer.cancel();
                    },
                    onTapCancel: () {
                      _timer.cancel();
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.remove,
                          size: 30,
                          color: Colors.white,
                        ), // icon
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20,),
            Text(
              _temperature.toStringAsFixed(1) + "°C",
              style: TextStyle(
                color: _temperature <= 37.5 ?  Color(0xFF00D963) : Color(0xFFF32013),
                fontSize: 50,
                fontWeight: FontWeight.bold,
                letterSpacing: 1
              ),
            ),
            SizedBox(width: 20,),
            Container(
            height: 40,
            width: 40, // 
              child: ClipOval(
                child: Material(
                  color: Colors.black, // button color
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _temperature += 0.1;
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      _timer = Timer.periodic(Duration(milliseconds: 100), (t) {
                        setState(() {
                          _temperature += 0.1; 
                        });
                       });
                    },
                     onTapUp: (TapUpDetails details) {
                      _timer.cancel();
                    },
                    onTapCancel: () {
                      _timer.cancel();
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          size: 30,
                          color: Colors.white,
                        ), // icon
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.fromLTRB(10,0,10,0),
          child: TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                      hintText: "Additional Remarks (Optional)",
                      border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    _remarks = text; 
                  },
                ),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
            height: 50,
            width: 50, // 
              child: ClipOval(
                child: Material(
                  color: Colors.red, // button color
                  child: InkWell(
                    splashColor: Colors.grey, // splash color
                    onTap: () {
                      Navigator.of(context).pop();
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.cancel,
                          size: 23,
                          color: Colors.white,
                        ), // icon
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 20,),
            Container(
            height: 50,
            width: 50, // 
              child: ClipOval(
                child: Material(
                  color: Color(0xFF00D963), // button color
                  child: InkWell(
                    splashColor: Colors.grey, // splash color
                    onTap: () {
                      Navigator.pop(context, new Temperature(temperature: _temperature.toStringAsFixed(1), datetime: DateFormat.yMd().add_Hm().format(DateTime.now()).toString(), remarks: _remarks));
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.done,
                          size: 23,
                          color: Colors.white,
                        ), // icon
                      ],
                    ),
                  ),
                ),
              ),
          ), 
          ],
        )
      ],
    ),
  ),
);
  }
}