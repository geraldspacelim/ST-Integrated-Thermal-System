import 'package:facial_capture/models/count.dart';
import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/screens/dialogs/profileDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:intl/intl.dart';

class ProfileList extends StatefulWidget {
  final Filter filter; 
  ProfileList({this.filter}); 
  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
void _showEditPanel(Profile profile){
    showModalBottomSheet(
      backgroundColor:  Colors.transparent,
      context: context, 
      builder: (context) {
        return ProfileDialog(profile: profile);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var profiles = Provider.of<List<Profile>>(context) ?? [];
    int currentMillieseconds = int.parse(DateTime.now().millisecondsSinceEpoch.toString());
    if (widget.filter.array != 'default' && widget.filter.temperature == 'default' && widget.filter.datetime == 'default') {
      print("array selected");
      profiles = profiles.where((i) => i.array == widget.filter.array).toList();
    } 
    else if (widget.filter.temperature != 'default' && widget.filter.array == 'default' && widget.filter.datetime == 'default' ) {
      print("temperature selected");
      profiles = profiles.where((i) =>  widget.filter.temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5).toList();
    } 
    else if (widget.filter.datetime != 'default' && widget.filter.temperature == 'default' && widget.filter.array == 'default') {
      print("datetime selected"); 
      profiles = profiles.where((i) => int.parse(widget.filter.datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : i.datetime >= int.parse(widget.filter.datetime) && i.datetime <= int.parse(widget.filter.datetime) + 86400000).toList();
    } 
    else if (widget.filter.array != 'default' && widget.filter.temperature != 'default' && widget.filter.datetime == 'default') {
      print("array and temperature selected");
      var temp_profiles = profiles.where((i) => i.array == widget.filter.array).toList();
      profiles = temp_profiles.where((i) =>  widget.filter.temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5).toList();
    } 
    else if (widget.filter.array != 'default' && widget.filter.temperature == 'default' && widget.filter.datetime != 'default') {
      print("array and datetime selected"); 
      var temp_profiles = profiles.where((i) => i.array == widget.filter.array).toList();
      profiles = temp_profiles.where((i) => int.parse(widget.filter.datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : i.datetime >= int.parse(widget.filter.datetime) && i.datetime <= int.parse(widget.filter.datetime) + 86400000).toList();
    } 
    else if (widget.filter.array == 'default' && widget.filter.temperature != 'default' && widget.filter.datetime != 'default') {
      print("temperature and datetime selected");
      var temp_profiles = profiles.where((i) =>  widget.filter.temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5).toList();
      profiles = temp_profiles.where((i) => int.parse(widget.filter.datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : i.datetime >= int.parse(widget.filter.datetime) && i.datetime <= int.parse(widget.filter.datetime) + 86400000).toList();
    } else if (widget.filter.array != 'default' && widget.filter.temperature != 'default' && widget.filter.datetime != 'default'){
      print("all selected");
      var temp_profiles = profiles.where((i) => i.array == widget.filter.array).toList();
      var temp_profiles_2 = temp_profiles.where((i) =>  widget.filter.temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5).toList();
      profiles = temp_profiles_2.where((i) => int.parse(widget.filter.datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : i.datetime >= int.parse(widget.filter.datetime) && i.datetime <= int.parse(widget.filter.datetime) + 86400000).toList();
    }
    // print(profiles.length);
    Count().updateCount(profiles.length); 
    // return Flexible(
        return GridView.builder(
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
                color: profiles[index].temperature <= 37.5 ?  Color(0xFF00D963) : Color(0xFFF32013),
                shape: RoundedRectangleBorder(
                  side:  BorderSide(
                    color: profiles[index].temperature <= 37.5 ?  Color(0xFF00D963) : Color(0xFFF32013),
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
                    SizedBox(height: 5.0),
                    Text(
                      profiles[index].name, 
                      style: TextStyle(
                        fontSize: 10,
                        color: profiles[index].temperature <= 37.5 ? Colors.black : Colors.white,
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      DateFormat.yMEd().add_Hm().format(new DateTime.fromMillisecondsSinceEpoch(profiles[index].datetime)),
                      style: TextStyle(
                        fontSize: 10,
                        color: profiles[index].temperature <= 37.5 ? Colors.black : Colors.white,
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      profiles[index].temperature.toStringAsFixed(1) + "°C", 
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: profiles[index].temperature <= 37.5 ? Colors.black : Colors.white,
                      )
                    )
                  ]
                ),
              ), 
          ),
            );
        },
      );
    // );
  }
}
