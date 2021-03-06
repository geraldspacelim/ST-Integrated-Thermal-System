import 'dart:convert';

import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/models/temperature.dart';
import 'package:facial_capture/screens/dialogs/temperatureDialog.dart';
import 'package:facial_capture/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileDialog extends StatefulWidget {
  final Profile profile;
  final String username; 
  ProfileDialog({this.profile, this.username});

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  var _controller = TextEditingController();
  final double circleRadius = 150.0;
  final double circleBorderWidth = 5.0;
  double _previousTemperature; 
  int _previousDateTime;
  double _currentTemperature; 
  int _currentDatetime; 
  String _currentRemarks;
  String _tag = null; 
  String _dateTimeDisplay; 
  String _previousDatetimeDisplay;
  String _username; 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.profile.manual_temperature == 0.0 ) {
      _currentTemperature =  widget.profile.temperature;
      _currentDatetime = widget.profile.datetime;
      _dateTimeDisplay = formatDatetime(_currentDatetime); 
      _previousTemperature = 0.0;
      _previousDatetimeDisplay = "-";
      _currentRemarks = widget.profile.manual_remarks ?? "-";
    } else {
      _currentTemperature = widget.profile.manual_temperature; 
      _currentDatetime = widget.profile.manual_datetime; 
      _dateTimeDisplay = formatDatetime(_currentDatetime); 
      _previousTemperature = widget.profile.temperature; 
      _previousDateTime = widget.profile.datetime; 
      _previousDatetimeDisplay = formatDatetime(_previousDateTime);
    }
        _username = widget.username; 
  } 

  void updateInformation(Temperature temperature) {
    if (temperature == null) {}
    else {
      setState(() {
      _previousDateTime = _currentDatetime;
      _previousDatetimeDisplay = formatDatetime(_previousDateTime); 
      _previousTemperature = _currentTemperature;
      _currentTemperature = temperature.temperature; 
      _currentDatetime = DateTime.now().millisecondsSinceEpoch;
      _dateTimeDisplay = formatDatetime(_currentDatetime); 
      _currentRemarks = temperature.remarks;
      _tag = temperature.tag; 
    });
    } 
  }

  String formatDatetime(_currentDatetime) {
    var dateTimeFormat = DateTime.fromMillisecondsSinceEpoch(_currentDatetime).toString();
    var dateParse = DateTime.parse(dateTimeFormat);
    return ("${dateParse.day}-${dateParse.month}-${dateParse.year} ${dateParse.hour}:${(dateParse.minute).toString().padLeft(2, '0')}");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: circleRadius / 2.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))
            ),
            height: 300.0,
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0 ,0),
                      child: Container(
                        decoration: BoxDecoration(
                        color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        width: 200.0,
                        height: 50.0,
                        // child: Padding(
                          // padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.train, 
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      SizedBox(width: 10,),
                                      // Text(" Station: ",
                                      // style: TextStyle(
                                      //   color: Colors.white,
                                      //   letterSpacing: 1,
                                      //   fontSize: 11,
                                      //   )
                                      // ),
                                      Text(
                                      widget.profile.location ?? "location",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        fontSize: 20
                                        )
                                      ),
                                    ],
                                  )                          
                                ],
                              ),
                            ],          
                          ),
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0 ,0),
                      child: Container(
                        decoration: BoxDecoration(
                        color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        width: 200.0,
                        height: 50.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.camera_alt, 
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                      widget.profile.camera_number ?? "camera number",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        fontSize: 20
                                        )
                                      ),
                                    ],
                                  )                          
                                ],
                              ),
                            ],          
                          ),
                        ),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0 ,0),
                      child: Container(
                        decoration: BoxDecoration(
                        color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        width: 200.0,
                        height: 50.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on, 
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                      widget.profile.camera_location ?? "camera location",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        fontSize: 20
                                        )
                                      ),
                                    ],
                                  )                          
                                ],
                              ),
                            ],          
                          ),
                        ),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0 ,0),
                      child: Container(
                        decoration: BoxDecoration(
                        color: Colors.black,
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        width: 200.0,
                        height: 50.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.directions_walk, 
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                      "Array " + widget.profile.array.toString() ?? "array",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        fontSize: 20
                                        )
                                      ),
                                    ],
                                  )                          
                                ],
                              ),
                            ],          
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 90.0, 0 ,0),
                      child: Container(
                        decoration: BoxDecoration(
                        color: _currentTemperature < 37.5 ?  Color(0xFF00D963) : Color(0xFFF32013),
                            borderRadius: BorderRadius.all(Radius.circular(5),),                      
                        ),
                        width: 340.0,
                        height: 90.0,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                           child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Icon(
                                    Icons.local_hospital, 
                                    color: _currentTemperature < 37.5 ?  Colors.black : Colors.white,
                                    size: 27.0,
                                  ),
                                ],
                              ),
                              SizedBox(width: 5,),
                              VerticalDivider(
                                color: _currentTemperature < 37.5 ?  Colors.black : Colors.white,                            
                              ),
                              SizedBox(width: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Current temperature: ",
                                      style: TextStyle(
                                        color: _currentTemperature < 37.5 ?  Colors.black : Colors.white,
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        )
                                      ),
                                      Text (
                                        _currentTemperature.toStringAsFixed(1) + "°C" ?? "current temp", 
                                        style: TextStyle(
                                          color: _currentTemperature < 37.5 ?  Colors.black : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          fontSize: 15,
                                        ),
                                      ),           
                                    ]
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Text("Time taken: ",
                                      style: TextStyle(
                                        color: _currentTemperature < 37.5 ?  Colors.black : Colors.white,
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        )
                                      ),
                                      Text (
                                        _dateTimeDisplay,
                                        //  DateFormat.yMd().add_Hm().format(DateTime.fromMillisecondsSinceEpoch(_currentDatetime)).toString(),
                                        style: TextStyle(
                                          color: _currentTemperature < 37.5 ?  Colors.black : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          fontSize: 15
                                        ),
                                      )                     
                                    ]
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                        Text(
                                          "Operator: " + "$_username",
                                          style: TextStyle(
                                            color: _currentTemperature < 37.5 ?  Colors.black : Colors.white,
                                            letterSpacing: 1,
                                            fontSize: 15
                                          ),
                                        )    
                                    ],
                                  )              
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20.0, 0 ,0),
                      child: Container(
                        decoration: BoxDecoration(
                        color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        width: 340.0,
                        height: 80.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Icon(
                                    Icons.history, 
                                    color: Colors.black,
                                    size: 30.0,
                                  ),
                                ],
                              ),
                              SizedBox(width: 5,),
                              VerticalDivider(
                                color: Colors.grey[800],                            
                              ),
                              SizedBox(width: 5,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Previous temperature: ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        )
                                      ),
                                      Text (
                                        _previousTemperature == 0.0 ? '-' : _previousTemperature.toStringAsFixed(1) + "°C", 
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          fontSize: 15,
                                        ),
                                      ),           
                                    ]
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Text("Time taken: ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: 15,
                                        )
                                      ),
                                      Text (
                                        // _previousDatetimeDisplay,
                                        _previousDatetimeDisplay,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          fontSize: 15
                                        ),
                                      )                     
                                    ]
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                        Text(
                                          "Operator: " + "$_username",
                                          style: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 1,
                                            fontSize: 15
                                          ),
                                        )    
                                    ],
                                  )              
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: circleRadius,
          height: circleRadius,
          decoration:
              ShapeDecoration(shape: CircleBorder(), color: _currentTemperature < 37.5 ?  Color(0xFF00D963) : Color(0xFFF32013)),
          child: Padding(
            padding: EdgeInsets.all(circleBorderWidth),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: (
                        NetworkImage("http://10.168.4.9:81/imgSnap/${this.widget.profile.uid}" + "${this.widget.profile.camera_number}" + "${this.widget.profile.datetime}.jpg")
                      ))),
            ),
          ),
        ),    
        Padding(
          padding: const EdgeInsets.fromLTRB(360, 95, 0 ,0),
          child: InkWell(
            onTap: () async {
                final Temperature temperature = await showDialog(context: context, builder: (BuildContext context) => TemperatureDialog(temperature: _currentTemperature, remarks: _currentRemarks, tag: _tag));
                updateInformation(temperature);
              }, 
              child: Container(                        
              decoration: BoxDecoration(
              color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                ],
              ),
              width: 200.0,
              height: 52.0,
              // child: Padding(
                // padding: const EdgeInsets.all(0),
                    child : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Add Temperature",
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1.5,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                          )
                        ),
                        SizedBox(width: 5,),
                        Icon(
                          Icons.add_box, 
                          size: 20,
                        )
                      ],
                    ),
              ),
          ),
                      // ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(520, 10, 0, 0),
          child: Container(
            height: 50,
            width: 50, // 
              child: ClipOval(
                child: Material(
                  color: Color(0xFF00D963), // button color
                  child: InkWell(
                    splashColor: Colors.grey, // splash color
                    onTap: () async {
                      // print(widget.profile.uid);
                      // print(_currentTemperature); 
                      // print(_currentDatetime);
                      // print( _currentRemarks);
                      // print(widget.profile.uid);
                      // print(widget.profile.camera_number);
                      await DatabaseService().updateDatabaseST(new Profile (uid: widget.profile.uid,
                                                                           name: widget.profile.name, 
                                                                           datetime: widget.profile.datetime,
                                                                           camera_number: widget.profile.camera_number.toString(), 
                                                                           camera_location: widget.profile.camera_location,
                                                                           image_captured: widget.profile.image_captured, 
                                                                           temperature: widget.profile.temperature,
                                                                           array: widget.profile.array,
                                                                           location: widget.profile.location,
                                                                           manual_datetime: _currentDatetime,
                                                                           manual_temperature: _currentTemperature,
                                                                           manual_remarks: _currentRemarks,
                                                                           imagePath: widget.profile.imagePath,
                                                                           isMask: widget.profile.isMask));
                      // widget.profile.uid, _currentTemperature, _currentDatetime, _currentRemarks);
                      Navigator.pop(context);
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
          )
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(400, 10, 0, 0),
          child: Container(
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
            )
        ),


        
      ],
    );
  }
}