import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/models/temperature.dart';
import 'package:facial_capture/screens/dialogs/temperatureDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileDialog extends StatefulWidget {
  final Profile profile;
  ProfileDialog({this.profile});

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  var _controller = TextEditingController();
  final double circleRadius = 150.0;
  final double circleBorderWidth = 5.0;
  String _previousTemperature = "-"; 
  String _previousDateTime = "-";
  String _currentTemperature; 
  String _currentDatetime; 

  @override
  void initState() {
    // TODO: implement initState
    _currentTemperature = widget.profile.temperature.toString();
    _currentDatetime = DateFormat.yMd().add_Hm().format(DateTime.fromMicrosecondsSinceEpoch(widget.profile.datetime)).toString();
    super.initState();
  } 

  void updateInformation(Temperature temperature) {
    if (temperature == null) {}
    else {
      setState(() {
      _previousDateTime = _currentDatetime;
      _previousTemperature = _currentTemperature;
      _currentTemperature = temperature.temperature; 
      _currentDatetime = temperature.datetime; 
      // _newTemperature = temperature.temperature == null ? _newTemperature : temperature.temperature;
      // _newTimeTaken = temperature.datetime == null ? _newTimeTaken : temperature.datetime  ;
      // _controller.text = temperature.remarks == null? "" : temperature.remarks; 

    });
    } 
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.train, 
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("Station",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 10,
                                    )
                                  ),
                                  // Text("hello")
                                ],
                              ),
                              SizedBox(height: 5,),
                               Row(
                                children: [
                                  Text(
                                  widget.profile.location,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5
                                    )
                                  ),
                                  // Text("hello")
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
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.camera_alt, 
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("Camera #",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 10,
                                    )
                                  ),
                                  // Text("hello")
                                ],
                              ),
                              SizedBox(height: 5,),
                               Row(
                                children: [
                                  Text(
                                  widget.profile.camera_number,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5
                                    )
                                  ),
                                  // Text("hello")
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
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on, 
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("Camera location",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 10,
                                    )
                                  ),
                                  // Text("hello")
                                ],
                              ),
                              SizedBox(height: 5,),
                               Row(
                                children: [
                                  Text(
                                  widget.profile.camera_location,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5
                                    )
                                  ),
                                  // Text("hello")
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
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.directions_walk, 
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("Array #",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 10,
                                    )
                                  ),
                                  // Text("hello")
                                ],
                              ),
                              SizedBox(height: 5,),
                               Row(
                                children: [
                                  Text(
                                  widget.profile.array,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5
                                    )
                                  ),
                                  // Text("hello")
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
                        color: double.parse(_currentTemperature) <= 37.5 ?  Color(0xFF00D963) : Color(0xFFF32013),
                            borderRadius: BorderRadius.all(Radius.circular(5),),                      
                        ),
                        width: 340.0,
                        height: 90.0,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                 children: [
                                  Icon(
                                    Icons.local_hospital, 
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("Current Temperature: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    )
                                  ),
                                  Text (
                                    _currentTemperature + "°C",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                 ]
                              ),
                              SizedBox(height: 5,), 
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    "Time Taken: " + _currentDatetime,
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 5,), 
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    "Operator: " + "test operator",
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10
                                    ),
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
                        color: Color(0xFFFBCE32),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        width: 340.0,
                        height: 80.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                 children: [
                                  Icon(
                                    Icons.history, 
                                    color: Colors.black,
                                    size: 12.0,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("History",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontSize: 10,
                                    )
                                  ),
                                 ]
                              ),
                              SizedBox(height: 5,),
                               Row(
                                 children: [
                                  Text("Pervious temperature: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontSize: 10,
                                    )
                                  ),
                                  Text (
                                    _previousTemperature, 
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5
                                    ),
                                  ),           
                                 ]
                              ),
                              Row(
                                 children: [
                                  Text("Time taken: ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontSize: 10,
                                    )
                                  ),
                                  Text (
                                    _previousDateTime,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  )                     
                                 ]
                              ),
                              Row(
                                children: [
                                    Text(
                                      "Operator: " + "test operator",
                                      style: TextStyle(
                                        color: Colors.black,
                                        letterSpacing: 1,
                                        fontSize: 10
                                      ),
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
              ShapeDecoration(shape: CircleBorder(), color: double.parse(_currentTemperature) <= 37.5 ?  Color(0xFF00D963) : Color(0xFFF32013)),
          child: Padding(
            padding: EdgeInsets.all(circleBorderWidth),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        widget.profile.image_captured,
                      ))),
            ),
          ),
        ),    
        Padding(
          padding: const EdgeInsets.fromLTRB(360, 95, 0 ,0),
          child: InkWell(
            onTap: () async {
                final Temperature temperature = await showDialog(context: context, builder: (BuildContext context) => TemperatureDialog(temperature: widget.profile.temperature,));
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
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(4, 1), // changes position of shadow
                  ),
                  ],
              ),
              child: ClipOval(
                child: Material(
                  color: Color(0xFF00D963), // button color
                  child: InkWell(
                    splashColor: Colors.grey, // splash color
                    onTap: () {
                      print("clicked");
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
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(4, 1), // changes position of shadow
                  ),
                  ],
              ),
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