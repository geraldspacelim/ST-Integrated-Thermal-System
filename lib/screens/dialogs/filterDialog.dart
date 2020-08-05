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
  double _time = 20.0;
  String _dateDisplay = DateTime.now().toString().split(' ')[0];
  DateTime selectedDate = DateTime.now();
  String _datetimeValue;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    _array = 'default';
    _temperature = 'default';
    _datetime = 'default'; 
    // _sort  = 'ascending'; 
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        _datetimeValue = picked.millisecondsSinceEpoch.toString();
        _dateDisplay = picked.toLocal().toString().split(' ')[0]; 
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
       body: Container(
         padding: EdgeInsets.all(20),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          IconButton(
            icon: Icon(Icons.close),
            iconSize: 30,
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
              // Navigator.pop(context, new Filter(array: null, temperature: null, datetime: null)); 
            },
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
             'Datetime',
             style: TextStyle(
               fontSize: 25,
               fontWeight: FontWeight.bold,
               letterSpacing: 1
             ),
           ),
            RadioListTile(
              value: _time.toStringAsFixed(0),
              activeColor: Colors.blue,
              groupValue: _datetime,
              onChanged: (value) {
                setState(() {
                  _datetime = value;
                });
              },
                title: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: 
                      Text(
                        "Show records " + _time.toStringAsFixed(0) + " minutes ago:",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1
                        ),
                      )
                  ),
                  Expanded(
                      flex: 5,
                      child: Slider(
                      value: _time,
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey,
                      min: 20,
                      max: 60,
                      divisions: 8,
                      label: _time.toStringAsFixed(0) + " Mins",
                      onChanged: (val) => setState(() => _time = val),
                    ),
                  ),
                ],
              ),
            ),
            RadioListTile(
              value: _datetimeValue,
              activeColor: Colors.blue,
              groupValue: _datetime,
              onChanged: (value) {
                setState(() {
                  _datetime = value;
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
                          onPressed: () => {
                            _selectDate(context)
                          },
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
                              " $_dateDisplay",             
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
                });
              },
            ),
            SizedBox(height: 20,),
             Center(
               child: Container(
                 width: 600,
                 height: 40,
                 child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.red)),
                  onPressed: () {
                    // print(_array);
                    // print(_temperature);
                    // print(_datetime);
                  
                    Navigator.pop(context, new Filter(array: _array, temperature: _temperature, datetime: _datetime)); 
                  },
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Apply",
                    style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                    )),
            ),
               ),
             ),
          ],
         ),
       ),
    );
  }
}