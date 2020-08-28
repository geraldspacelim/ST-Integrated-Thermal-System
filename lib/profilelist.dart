import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:facial_capture/home.dart';
import 'package:facial_capture/main.dart';
import 'package:facial_capture/models/count.dart';
import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/screens/dialogs/profileDialog.dart';
import 'package:facial_capture/screens/dialogs/splitArray.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/profile.dart';
import 'models/profile.dart'; 

class ProfileList extends StatefulWidget {
  final List<Profile> profiles;
  final Filter filter; 
  final String username;  
  ProfileList({this.profiles, this.username, this.filter}); 
  // final String username; 
  // ProfileList({this.filter, this.username}); 
  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {

final ScrollController _scrollController  = ScrollController();
// final Count countController = Count();
var profiles;
double _threshold_temperature = 37.5;
double _temperature; 
bool _loading = true; 
Map<int, String> dates = {1: 'Mon', 2: 'Tues', 3: 'Wed', 4: 'Thur', 5: 'Fri', 6: 'Sat', 7: 'Sun'};
// Counter counter;

void _showEditPanel(Profile profile){
    showModalBottomSheet(
      backgroundColor:  Colors.transparent,
      context: context, 
      builder: (context) {
        return ProfileDialog(profile: profile, username: this.widget.username);
      }
    );
  }
  
  String formatDatetime(_currentDatetime) {
    var dateTimeFormat = DateTime.fromMillisecondsSinceEpoch(_currentDatetime).toString();
    var dateParse = DateTime.parse(dateTimeFormat);
    return ("${dates[dateParse.weekday]}, ${dateParse.day}-${dateParse.month}-${dateParse.year} ${dateParse.hour}:${dateParse.minute.toString().padLeft(2, '0')}");
  }

  Color formatTemperatureColour(previous_temp, current_temp) {
    if (previous_temp == 0.0) {
      return current_temp <= _threshold_temperature ?  Color(0xFF2DC990) : Color(0xFFFC6041);
    }
    return Color(0xFFFCB941);
  }

  @override
  Widget build(BuildContext context) {
    profiles = this.widget.profiles ?? [];    

    int currentMillieseconds = int.parse(DateTime.now().millisecondsSinceEpoch.toString());
   
    if (widget.filter.processed) {
      profiles = profiles.where((i) => i.manual_temperature != 0.0).toList(); 
    } 

    if (widget.filter.array != 'default') { 
      profiles = profiles.where((i) => widget.filter.array == '1' ? i.name.toLowerCase() == 'unknown' : i.name.toLowerCase() != 'unknown').toList();
    }

    if (widget.filter.temperature != 'default') {
      profiles = profiles.where((i) =>  widget.filter.temperature == 'danger' ? (i.manual_temperature == 0.0 ? i.temperature : i.manual_temperature) >= 37.5 : (i.manual_temperature == 0.0 ? i.temperature : i.manual_temperature) < 37.5).toList();
    }

    if (widget.filter.datetime != 'default') {
      profiles = profiles.where((i) => int.parse(widget.filter.datetime) <= 60 ? (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) >= int.parse(widget.filter.datetime) && (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) <= int.parse(widget.filter.datetime) + 86400000).toList();
    }
    
        return Scrollbar(
          isAlwaysShown: true,
          controller: _scrollController,
                  child: GridView.builder(
                    controller: _scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: profiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.75,
          ),
          itemBuilder: (BuildContext context, int index) {
              return GestureDetector(

                onTap: () => _showEditPanel( 
                  profiles[index]
                  
                ),
               child: Card(
                  elevation: 8,
                  color: formatTemperatureColour(profiles[index].manual_temperature, profiles[index].temperature),
                  shape: RoundedRectangleBorder(
                    side:  BorderSide(
                      color: formatTemperatureColour(profiles[index].manual_temperature, profiles[index].temperature),
                      width: 3.0),
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  margin: EdgeInsets.all(10),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    children: <Widget>[
                    Column(
                    children: [
                      Expanded(
                        flex: 3,
                          child: Container(
                          // width: double.infinity,
                          // height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("http://10.168.4.9:81/imgSnap/${profiles[index].uid}" + "${profiles[index].camera_number}" + "${profiles[index].datetime}.jpg"),
                              // image: NetworkImage(profiles[index].image_captured),         
                              // image: MemoryImage((profiles[index].image_captured)),
                              // image: MemoryImage(img),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        flex: 1,
                        child: Column(
                            children:[
                            Text(
                            // profiles[index].datetime .toString(),
                            formatDatetime(profiles[index].manual_datetime == 0 ? profiles[index].datetime: profiles[index].manual_datetime),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black
                              // profiles[index].temperature <= _threshold_temperature ? Colors.black : Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.5),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                // profiles[index].manual_temperature.toString() + "°C", 
                                profiles[index].manual_temperature == 0.0 ? "-" : (profiles[index].temperature.toString() +  "°C"),
                                                                // profiles[index].manual_temperature == 0.0 ? "-" : profiles[index].temperature.toString() + "°C",
                                style: TextStyle(
                                  // fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: formatColour(profiles[index].temperature, profiles[index].manual_temperature)
                                  // formatColour(profiles[index].temperature, profiles[index].manual_temperature)
                                  // profiles[index].temperature <=_threshold_temperature ? Colors.black : Colors.white,
                                )
                              ),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: formatColour(profiles[index].temperature, profiles[index].manual_temperature)
                                  // profiles[index].temperature <=_threshold_temperature ? Colors.black : Colors.white,
                                )
                              ),
                              Text(
                                profiles[index].manual_temperature == 0.0 ? (profiles[index].temperature.toString() + "°C") : (profiles[index].manual_temperature.toString() +  "°C"),
                                // profiles[index].manual_temperature.toString() + "°C", 
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: formatColour(profiles[index].temperature, profiles[index].manual_temperature)
                                  // formatColour(profiles[index].temperature, profiles[index].manual_temperature)
                                  // profiles[index].temperature <= _threshold_temperature ? Colors.black : Colors.white,
                                )
                              )
                            ],
                          ),                        
                          ]
                        ),
                      ),
                    ]
                  ),
                   Visibility(
                     visible: profiles[index].isMask ? false : true,
                  child: Row (
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: <Widget>[
                         Container(
                            height: 35, 
                            width: 35,
                            // color: Colors.black,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle
                            ),
                            child: Center(
                              child: Icon(
                                Icons.warning,
                                color: Colors.red[700],
                                ),
                            ),
                          ),
                       ],
                     ),
                   ),
                  ],
                  )
                // ), 
                ),
              );
          },
      ),
        );
    // );
  }


  Color formatColour(double temperature, double manual_temperature) {
    if (manual_temperature == 0.0) {
      if (temperature >= 37.5) {
        return Color(0xFFFE0202); 
      }
      return Colors.black;
    } else {
      if (manual_temperature >= 37.5) {
        return Color(0xFFFE0202); 
      }
      return Colors.black;
    }
  }
}

