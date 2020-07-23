import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/screens/dialogs/profileDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:intl/intl.dart';

class ProfileList extends StatefulWidget {
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
    final profiles = Provider.of<List<Profile>>(context) ?? [];
    // print("length " + profiles.length.toString());
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
  }
}
