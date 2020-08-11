import 'package:facial_capture/models/filter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'; 


class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _array; 
  String _temperature; 
  String _datetime;
  double _time;
  String _dateDisplay = DateTime.now().toString().split(' ')[0];
  DateTime selectedDate = DateTime.now();
  String _datetimeValue;
  bool allowSlider = false;
  bool allowDate = false;
  DateTime picked;
  bool _processed = false; 

  // _time.toStringAsFixed(0)
  // _datetimeValue

  @override
  void initState() {
    super.initState();
    getSharedPrefs().then((_) => setState(() {
      _array = _array;
      _temperature = _temperature; 
      _datetime = _datetime;
      _processed = _processed;
      // if (_datetime == 'period') {
      //   _time = _time;
      //   allowSlider = true;
      // } else if (_datetime == 'day') {
      //   _datetimeValue = _datetimeValue;
      //    allowDate = true; 
      // } else {
      //   _datetimeValue  = _datetimeValue;
      // }

      _datetime == 'period' ? _time = _time : _datetimeValue = _datetimeValue;
      _datetime == 'period' ? allowSlider = true: allowDate = true; 
      // _time = _time; 
      // _datetimeValue = _datetimeValue;
    })
    );
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _array = prefs.getString('arrayPref') ?? 'default';
    _temperature = prefs.getString('tempPref') ?? 'default';
    _datetime = prefs.getString('datetimePref') ?? 'default';
    _processed = prefs.getBool('processedPref') ?? false;
    // print(prefs.getString('datetimeValuePref'));
    if (_datetime == 'period') {
      _time = double.parse(prefs.getString('datetimeValuePref'));
    } else if (_datetime == 'day') {
      _datetimeValue = prefs.getString('datetimeValuePref');
    } 
    // _datetimeValue = prefs.getString('datetimeValuePref') ?? 'default';
  }

  Future<Null> _selectDate(BuildContext context) async {
    picked = await showDatePicker( 
        context: context,
        initialDate:_datetimeValue == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(int.parse(_datetimeValue)),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        _datetimeValue = picked.millisecondsSinceEpoch.toString();
        // _dateDisplay = picked.toLocal().toString().split(' ')[0]; 
      });
  }


  Future<Null> addStringtoSF(String array, String temperature, String datetime, bool processed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('arrayPref', array); 
    prefs.setString('tempPref', temperature);
    prefs.setString('datetimePref', datetime);
    prefs.setBool('processedPref', processed);
    if (datetime != 'default'){
      prefs.setString('datetimeValuePref', datetime == 'period' ? _time.toStringAsFixed(0) : _datetimeValue);
    } 
  }

  String chooseDatetime(String option) {
    if (option == 'period') {
      return  _time.toStringAsFixed(0);
    } else if (option == 'day') {
      return _datetimeValue; 
    } else {
      return 'default'; 
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
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 40,
                    color: Color(0xFFF32013),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.pop(context, new Filter(array: null, temperature: null, datetime: null)); 
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.check),
                    iconSize: 40,
                    color: Color(0xFF00D963),
                    onPressed: () {
                        addStringtoSF(_array, _temperature, _datetime, _processed); 
                        Navigator.pop(context, new Filter(array: _array, temperature: _temperature, datetime: chooseDatetime(_datetime), processed: _processed)); 
                    },
                  ),
                  
                ],
              ),
              SizedBox(height: 10,),
               Text(
                 'Filter And Sort By:',
                 style: TextStyle(
                   fontSize: 35,
                   fontWeight: FontWeight.bold,
                   letterSpacing: 1.5
                 ),
               ),
               SizedBox(height: 20,),
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
                    "Secondary Temeperature Check",
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
               SizedBox(height: 5,),
               const Divider(
                  color: Colors.grey,
                  // height: 20,
                  indent: 20,
                  endIndent: 20,
                  thickness: 1,
                ),
                SizedBox(height: 5,),
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
                    'Temperature above threshold value',
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
                    'Temperature below threshold value',
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
                  SizedBox(height: 5,),
                const Divider(
                  color: Colors.grey,
                  // height: 20,
                  indent: 20,
                  endIndent: 20,
                  thickness: 1,
                ),
                SizedBox(height: 5,),
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
                  groupValue: _datetime,
                  onChanged: (value) {
                    setState(() {
                      _datetime = value;
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
                            "Show only last " + (_time == null ? 20.toString() :_time.toStringAsFixed(0)) + " minutes :",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1
                            ),
                          )
                      ),
                      Expanded(
                          flex: 5,
                          child: Slider(
                          value: _time == null ? 20 : _time,
                          activeColor: Colors.black,
                          inactiveColor: Colors.grey,
                          min: 20,
                          max: 60,
                          divisions: 8,
                          label: (_time == null ? 20.toString() :_time.toStringAsFixed(0)) + " Mins",
                          onChanged: allowSlider ? (val) => setState(() => _time = val) : null,
                        ),
                      ),
                    ],
                  ),
                ),
                RadioListTile(
                  value: 'day',
                  activeColor: Colors.blue,
                  groupValue: _datetime,
                  onChanged: (value) {
                    setState(() {
                      _datetime = value;
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
                                  " " + formatDatefromEpoch(_datetimeValue == null  ? DateTime.now().millisecondsSinceEpoch.toString() : _datetimeValue),    
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
                  groupValue: _datetime,
                  onChanged: (value) {
                    setState(() {
                      _datetime = value;
                      allowDate = false; 
                      allowSlider = false;
                    });
                  },
                ),
              ],
             ),
           ),
        //  ),
      );   
  }
}