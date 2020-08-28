import 'package:facial_capture/models/filter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'; 


class FilterPage extends StatefulWidget {
  final Filter filter; 
  FilterPage({this.filter}); 
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _array; 
  String _temperature; 
  String _datetime;
  String _datetimeGroupValue; 
  bool _processed; 
  // int _datetimeValue;
  double _periodValue; 
  int _dayValue; 
  
  double _time;

  String _dateDisplay =  DateTime.now().toLocal().toString().split(' ')[0];
  DateTime selectedDate = DateTime.now();

  bool allowSlider = false;
  bool allowDate = false;
  DateTime picked;

  @override
  void initState() {
    super.initState();
    _array = widget.filter.array; 
    _temperature = widget.filter.temperature; 
    _datetime = widget.filter.datetime; 
    _processed = widget.filter.processed; 
    if (_datetime != "default") {
      var temp = int.parse(_datetime); 
      if (temp > 60) {
        _datetimeGroupValue = "day";
        _dayValue = temp;
        _dateDisplay = DateTime.fromMillisecondsSinceEpoch(temp).toLocal().toString().split(' ')[0];
        allowDate = true; 
        allowSlider = false;
      } else if (temp <= 60) {
        _datetimeGroupValue = "period";
        _periodValue = temp.toDouble();
        allowDate = false; 
        allowSlider = true;
      }
    } else {
      _datetimeGroupValue = "default";
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    picked = await showDatePicker( 
        context: context,
        initialDate:_dayValue == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(_dayValue),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        _dayValue = picked.millisecondsSinceEpoch;
        _dateDisplay = picked.toLocal().toString().split(' ')[0]; 
      });
  }


  Future<Null> addStringtoSF(String array, String temperature, String datetime, bool processed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('arrayPref', array); 
    prefs.setString('tempPref', temperature);
    prefs.setString('datetimePref', datetime);
    prefs.setBool('processedPref', processed);
    // if (datetime != 'default'){
    //   prefs.setString('datetimeValuePref', datetime == 'period' ? _time.toString() : _datetimeValue);
    // } 
  }

  String chooseDatetime(String option) {
    if (option == 'period' ) {
      return  _periodValue.toStringAsFixed(0);
    } else if (option == 'day') {
      return _dayValue.toString(); 
    } else {
      return "default"; 
    }
  }

  String formatDatefromEpoch(String epoch) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(epoch));
    return date.toLocal().toString().split(' ')[0]; 
  }
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
         resizeToAvoidBottomPadding: false,
         backgroundColor: Colors.white,
        //  body: SingleChildScrollView(
            body: Container(
             padding: EdgeInsets.all(20),
             child: Stack(
              children: <Widget>[ 
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 40,
                    color: Color(0xFFF32013),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.pop(context, new Filter(array: null, temperature: null, datetime: null)); 
                    },
                  ),

                  ],
                                  
                ),
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                SizedBox(height: 5,),
                 Text(
                   'Filter And Sort By:',
                   style: TextStyle(
                     fontSize: 35,
                     fontWeight: FontWeight.bold,
                     letterSpacing: 1.5
                   ),
                 ),
                 SizedBox(height: 15,),
                 Text(
                   'View',
                   style: TextStyle(
                     fontSize: 25,
                     fontWeight: FontWeight.bold,
                     letterSpacing: 1
                   ),
                 ),
                   RadioListTile(
                    //  autofocus: true,
                    title: const Text(
                      'Gate Array 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1
                      ),
                    ),
                    value: "1",
                    activeColor: Colors.blue,
                    groupValue: _array,
                    onChanged: (value) {
                      setState(() {
                        _array = value;
                      });
                    },
                  ),
                   RadioListTile(
                    title: const Text(
                      'Gate Array 2',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1
                      ),
                    ),
                    value: "2",
                    activeColor: Colors.blue,
                    groupValue: _array,
                    onChanged: (value) {
                      setState(() {
                        _array = value;
                      });
                    },
                  ),
                   RadioListTile(
                    title: const Text(
                      'Split Gate Arrays',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1
                      ),
                    ),
                    value: "split",
                    activeColor: Colors.blue,
                    groupValue: _array,
                    onChanged: (value) {
                      setState(() {
                        _array = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text(
                      'All',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1
                      ),
                    ),
                    value: "default",
                    activeColor: Colors.blue,
                    groupValue: _array,
                    onChanged: (value) {
                      setState(() {
                        _array = value;
                      });
                    },
                  ), 
                  CheckboxListTile(
                    title: Text(
                      "Secondary Temperature Check",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1
                      ),
                    ),
                    value: _processed,
                    onChanged: (value) { 
                      setState(() {
                        _processed = value; 
                      }); 
                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  ),
                 SizedBox(height: 10,),
                 const Divider(
                    color: Colors.grey,
                    // height: 20,
                    indent: 20,
                    endIndent: 20,
                    thickness: 1,
                  ),
                  SizedBox(height: 10,),
                Text(
                   'Temperature',
                   style: TextStyle(
                     fontSize: 25,
                     fontWeight: FontWeight.bold,
                     letterSpacing: 1
                   ),
                 ),
                 RadioListTile(
                    title: const Text(
                      'Temperature above threshold value (>= 37.5°C)',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1
                      ),
                    ),
                    value: "danger",
                    activeColor: Colors.blue,
                    groupValue: _temperature,
                    onChanged: (value) {
                      setState(() {
                        _temperature = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text(
                      'Temperature below threshold value (37.5°C <)',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1
                      ),
                    ),
                    value: "safe",
                    activeColor: Colors.blue,
                    groupValue: _temperature,
                    onChanged: (value) {
                      setState(() {
                        _temperature = value;
                      });
                    },
                  ),
                   RadioListTile(
                    title: const Text(
                      'All',
                       style: TextStyle(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1
                      ),
                    ),
                    value: "default",
                    activeColor: Colors.blue,
                    groupValue: _temperature,
                    onChanged: (value) {
                      setState(() {
                        _temperature = value;
                      });
                    },
                  ),
                    SizedBox(height: 10,),
                  const Divider(
                    color: Colors.grey,
                    // height: 20,
                    indent: 20,
                    endIndent: 20,
                    thickness: 1,
                  ),
                  SizedBox(height: 10,),
                  Text(
                   'Date Time',
                   style: TextStyle(
                     fontSize: 25,
                     fontWeight: FontWeight.bold,
                     letterSpacing: 1
                   ),
                 ),
                  RadioListTile(
                    value: 'period',
                    activeColor: Colors.blue,
                    groupValue: _datetimeGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _datetimeGroupValue = value;
                        _periodValue = 20; 
                        allowDate = false; 
                        allowSlider = true;
                      });
                    },
                      title: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: 
                            Text(
                              "Show only last " + (_periodValue == null ? 20.toString() :_periodValue.toStringAsFixed(0)) + " minutes :",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1
                              ),
                            )
                        ),
                        Expanded(
                            flex: 5,
                            child: Slider(
                            value: _periodValue == null ? 20 : _periodValue,
                            activeColor: Colors.black,
                            inactiveColor: Colors.grey,
                            min: 20,
                            max: 60,
                            divisions: 8,
                            label: (_periodValue == null ? 20.toString() :_periodValue.toStringAsFixed(0)) + " Mins",
                            onChanged: allowSlider ? (val) => setState(() => _periodValue = val) : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RadioListTile(
                    value: 'day',
                    activeColor: Colors.blue,
                    groupValue: _datetimeGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _datetimeGroupValue = value;
                        _dayValue = DateTime.now().millisecondsSinceEpoch;
                        allowSlider = false;
                        allowDate = true; 
                      });
                    },
                    title: Row(
                      children: [
                        Expanded(
                          flex: 3,
                            child: Text(
                            'Show records on:', 
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1
                            )
                          ),
                        ),
                        Expanded(
                          flex: 5,
                            child: Container(
                            // width: 200,
                            height: 40,
                            child: RaisedButton(
                                color: Colors.white,
                                onPressed: allowDate ?
                                 () => {
                                  _selectDate(context) 
                                } : null,
                                shape: RoundedRectangleBorder(
                                   side: BorderSide(color: Colors.black, width: 1),
                                   
                                borderRadius: BorderRadius.circular(5.0)),
                                elevation: 4.0,
                                child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    // " " + formatDatefromEpoch(_datetimeValue == null ? DateTime.now().millisecondsSinceEpoch.toString() : _datetimeValue ),   
                                    " " + _dateDisplay,    
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15.0),
                                  ),
                                  SizedBox(width: 115,),
                                  Text(
                                    'Change',
                                    style: TextStyle(
                                      color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15.0),
                                    ),
                            
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                   RadioListTile(
                    title: const Text(
                      'All',
                       style: TextStyle(
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1
                      ),
                    ),
                    value: "default",
                    activeColor: Colors.blue,
                    groupValue: _datetimeGroupValue,
                    onChanged: (value) {
                      setState(() {
                        _datetimeGroupValue = value;
                        allowDate = false; 
                        allowSlider = false;
                      });
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                      child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      color: Colors.red,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                         addStringtoSF(_array, _temperature, chooseDatetime(_datetimeGroupValue), _processed); 
                          Navigator.pop(context, new Filter(array: _array, temperature: _temperature, datetime: chooseDatetime(_datetimeGroupValue), processed: _processed)); 
                      },
                      child: Text(
                        "apply changes".toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),// ),
                ],
               ),
              ]
             ),
           ),
        //  ),
      );   
  }
}