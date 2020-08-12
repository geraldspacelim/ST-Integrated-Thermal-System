import 'dart:async';
import 'dart:collection';

import 'package:facial_capture/home.dart';
import 'package:facial_capture/main.dart';
import 'package:facial_capture/models/count.dart';
import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/screens/dialogs/profileDialog.dart';
import 'package:facial_capture/screens/dialogs/splitArray.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

class ProfileList extends StatefulWidget {
  final Filter filter; 
  final String username; 
  ProfileList({this.filter, this.username}); 
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
        return ProfileDialog(profile: profile, username: widget.username);
      }
    );
  }
  
  String formatDatetime(_currentDatetime) {
    var dateTimeFormat = DateTime.fromMillisecondsSinceEpoch(_currentDatetime).toString();
    var dateParse = DateTime.parse(dateTimeFormat);
    return ("${dates[dateParse.weekday]}, ${dateParse.day}-${dateParse.month}-${dateParse.year} ${dateParse.hour}:${dateParse.minute}");
  }

  Color formatTemperatureColour(previous_temp, current_temp) {
    if (previous_temp == 0.1) {
      return current_temp <= _threshold_temperature ?  Color(0xFF2DC990) : Color(0xFFFC6041);
    }
    return Color(0xFFFCB941);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   counter  = new Counter();
  // }
  
  @override
  Widget build(BuildContext context) {
    var profiles = Provider.of<List<Profile>>(context) ?? [];
    // DataProvider _data = Provider.of<DataProvider>(context);
    // counter  = new Counter();
    // print("counter invoked")
    int totalProfiles = profiles.length; 

    int currentMillieseconds = int.parse(DateTime.now().millisecondsSinceEpoch.toString());
    if (widget.filter.array != 'default' && widget.filter.temperature == 'default' && widget.filter.datetime == 'default') {
      // print("array selected");
      profiles = profiles.where((i) => i.array == widget.filter.array).toList();
    } 
    else if (widget.filter.temperature != 'default' && widget.filter.array == 'default' && widget.filter.datetime == 'default' ) {
      // print("temperature selected");
      profiles = profiles.where((i) =>  widget.filter.temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5).toList();
    } 
    else if (widget.filter.datetime != 'default' && widget.filter.temperature == 'default' && widget.filter.array == 'default') {
      // print("datetime selected"); 
      profiles = profiles.where((i) => int.parse(widget.filter.datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : i.datetime >= int.parse(widget.filter.datetime) && i.datetime <= int.parse(widget.filter.datetime) + 86400000).toList();
    } 
    else if (widget.filter.array != 'default' && widget.filter.temperature != 'default' && widget.filter.datetime == 'default') {
      // print("array and temperature selected");
      var temp_profiles = profiles.where((i) => i.array == widget.filter.array).toList();
      profiles = temp_profiles.where((i) =>  widget.filter.temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5).toList();
    } 
    else if (widget.filter.array != 'default' && widget.filter.temperature == 'default' && widget.filter.datetime != 'default') {
      // print("array and datetime selected"); 
      var temp_profiles = profiles.where((i) => i.array == widget.filter.array).toList();
      profiles = temp_profiles.where((i) => int.parse(widget.filter.datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : i.datetime >= int.parse(widget.filter.datetime) && i.datetime <= int.parse(widget.filter.datetime) + 86400000).toList();
    } 
    else if (widget.filter.array == 'default' && widget.filter.temperature != 'default' && widget.filter.datetime != 'default') {
      // print("temperature and datetime selected");
      var temp_profiles = profiles.where((i) =>  widget.filter.temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5).toList();
      profiles = temp_profiles.where((i) => int.parse(widget.filter.datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : i.datetime >= int.parse(widget.filter.datetime) && i.datetime <= int.parse(widget.filter.datetime) + 86400000).toList();
    } else if (widget.filter.array != 'default' && widget.filter.temperature != 'default' && widget.filter.datetime != 'default'){
      // print("all selected");
      var temp_profiles = profiles.where((i) => i.array == widget.filter.array).toList();
      var temp_profiles_2 = temp_profiles.where((i) =>  widget.filter.temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5).toList();
      profiles = temp_profiles_2.where((i) => int.parse(widget.filter.datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : i.datetime >= int.parse(widget.filter.datetime) && i.datetime <= int.parse(widget.filter.datetime) + 86400000).toList();
    }
    if (widget.filter.processed) {
      profiles = profiles.where((i) => i.manual_temperature != 0.1).toList(); 
    }

    String previousCount = eventProvider.previousCount; 
    if (previousCount != "") {
      var countList = previousCount.split('-');
      if (widget.filter.array == '1') {
        countList[0] = profiles.length.toString();
        countList[1] = profiles.length.toString();
      }
      else if (widget.filter.array == '2') {
        countList[0] = profiles.length.toString();
        countList[2] = profiles.length.toString();
      }
      else {
        countList[0] = profiles.length.toString();
      }
      var updatedCountList = countList.join("-");
        print(updatedCountList);
        eventProvider.previousCount = updatedCountList; 
        eventProvider.updateCount(updatedCountList);
    } else {
        var defaultString = "${profiles.length}-0-0";
        eventProvider.previousCount = defaultString; 
        eventProvider.updateCount(defaultString); 
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
            // var date = new DateTime.fromMillisecondsSinceEpoch(profiles[index].datetime);
            // print(date);
              return GestureDetector(
                onTap: () => _showEditPanel( 
                  profiles[index]
                  // context: context,
                  // builder: (BuildContext context) => ProfileDialog(profile: profiles[index]),
                ),
                child: Card(
                  elevation: 3,
                  color: formatTemperatureColour(profiles[index].manual_temperature, profiles[index].temperature),
                  shape: RoundedRectangleBorder(
                    side:  BorderSide(
                      color: formatTemperatureColour(profiles[index].manual_temperature, profiles[index].temperature),
                      width: 3.0),
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  margin: EdgeInsets.all(10),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(profiles[index].image_captured),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        formatDatetime(profiles[index].datetime),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black
                          // profiles[index].temperature <= _threshold_temperature ? Colors.black : Colors.white,
                        ),
                      ),
                      SizedBox(height: 3.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            profiles[index].manual_temperature != 0.1 ? profiles[index].manual_temperature.toString() + "°C" : '  -  ',
                            style: TextStyle(
                              // fontWeight: FontWeight.w400,
                              fontSize: 11,
                              color: profiles[index].manual_temperature != 0.1 && profiles[index].temperature >= 37.5 ? Color(0xFFFE0202) : Colors.black
                              // profiles[index].temperature <=_threshold_temperature ? Colors.black : Colors.white,
                            )
                          ),
                          Text(
                            '|',
                             style: TextStyle(
                              fontSize: 15,
                              color: profiles[index].manual_temperature != 0.1 && profiles[index].temperature >= 37.5 ? Color(0xFFFE0202) : Colors.black
                              // profiles[index].temperature <=_threshold_temperature ? Colors.black : Colors.white,
                            )
                          ),
                          Text(
                            profiles[index].temperature.toString() + "°C", 
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: profiles[index].manual_temperature != 0.1 && profiles[index].temperature >= 37.5 ? Color(0xFFFE0202) : Colors.black
                              // profiles[index].temperature <= _threshold_temperature ? Colors.black : Colors.white,
                            )
                          )
                        ],
                      )
                    ]
                  ),
                ), 
            ),
              );
          },
      ),
        );
    // );
  }
}

