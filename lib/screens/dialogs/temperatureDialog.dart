import 'dart:async';

import 'package:facial_capture/models/temperature.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class TemperatureDialog extends StatefulWidget {
  double temperature; 
  String remarks; 
  String tag;
  TemperatureDialog({this.temperature, this.remarks, this.tag});
  @override
  _TemperatureDialogState createState() => _TemperatureDialogState();
}

class _TemperatureDialogState extends State<TemperatureDialog> {
  double _temperature;
  int _datetime = 0; 
  Timer _timer;
  bool _cleared = false;
  bool _not_cleared = false; 
  bool _others = false;
  var txt = TextEditingController();
  bool _show_error = false; 
  String _tag; 
  
  @override
  void initState() {
    _temperature = widget.temperature;
    txt.text = widget.remarks;
    if (widget.tag == 'cleared') {
      _cleared = true;
    } else if (widget.tag == 'not cleared') {
      _not_cleared = true; 
    } else if (widget.tag == 'others') {
      _others = true; 
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  // _temperature = widget.temperature;
  return Dialog(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18.0),
    side: BorderSide(
      color: _show_error ? Colors.red : Colors.white,
      width: 3,
      )
    ), //this right here
  child: Container(
    height: 370.0,
    width: 320.0,

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
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [          
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black)),
            color: _cleared ? Colors.black : Colors.white,
            textColor: _cleared ? Colors.white : Colors.black,
            padding: EdgeInsets.all(8.0),
            onPressed: () {
              setState(() {
                _cleared = true; 
                _not_cleared = false; 
                _others = false; 
                _show_error = false;
                _tag = "cleared"; 
                txt.text = "Cleared"; 
              });
            },
            child: Text(
              "cleared".toUpperCase(),
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black)),
             color: _not_cleared ? Colors.black : Colors.white,
            textColor: _not_cleared ? Colors.white : Colors.black,
            padding: EdgeInsets.all(8.0),
            onPressed: () {
              setState(() {
                _cleared = false; 
                _not_cleared = true; 
                _others = false; 
                _show_error = false;
                _tag = "not cleared";
                txt.text = "Not Cleared"; 
              });
            },
            child: Text(
              "not cleared".toUpperCase(),
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
            FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black)),
             color: _others ? Colors.black : Colors.white,
            textColor: _others ? Colors.white : Colors.black,
            padding: EdgeInsets.all(8.0),
            onPressed: () {
              setState(() {
                _cleared = false; 
                _not_cleared = false; 
                _others = true; 
                txt.text = "Others";
                _tag = "others";
                _show_error = false;
              });
            },
            child: Text(
              "others".toUpperCase(),
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
          ],
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.fromLTRB(10,0,10,0),
          child: TextField(
            controller: txt,
                  maxLines: 3,
                  maxLength: 100,
                  decoration: InputDecoration(
                      hintText: 'Additional Remarks',
                      hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black54
                      ),
                      // hintText: "Additional Remarks (Optional)",
                      border: OutlineInputBorder(),
                  ),
                ),
        ),
        SizedBox(height: 5,),
        Text(          
          "Please select a tag",
          style: TextStyle(
            color: _show_error ? Colors.red : Colors.transparent,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 15,),
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
                      if (_cleared == false && _not_cleared == false && _others == false ) {
                        setState(() {
                          _show_error = true;
                        });
                      } else {
                          Navigator.pop(context, new Temperature(temperature: double.parse(_temperature.toStringAsFixed(1)), datetime: DateTime.now().millisecondsSinceEpoch, remarks: txt.text, tag: _tag));
                      }
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