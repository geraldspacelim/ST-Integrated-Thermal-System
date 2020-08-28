import 'dart:convert';
import 'dart:math';

import 'package:facial_capture/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DatabaseService {

  Future updateDatabaseST (Profile profile) async {
    final http.Response response = await http.post(
      'http://http://10.168.4.9:81/API/imagesnap/UpdateTemperatureInfo',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'UserID': profile.uid,
        'array': profile.array, 
        'camera_location': profile.camera_location, 
        'camera_number': profile.camera_number, 
        'captured_DateTime': profile.datetime.toString(), 
        'image_captured': profile.image_captured.toString(),
        'location': profile.location, 
        'manual_dateTime': profile.manual_datetime.toString(),
        'manual_remarks': profile.manual_remarks, 
        'manual_temperature': profile.manual_temperature.toString(), 
        'temperature': profile.temperature.toString(),
        'imagePath': profile.imagePath,
        'isMask': profile.isMask.toString(),
      })
    );
    print (response);
  }


  Future<List<Profile>> profileDataST() async {
   final response =  await http.get('http://192.168.1.104:82/API/imagesnap/GetAllUserImages');
    List profiles = jsonDecode(response.body);
    return profiles.map((profile) => new Profile(uid: profile['UserID'], 
                                                 name: profile['name'],
                                                 datetime: profile['captured_DateTime'],
                                                 camera_number: profile['camera_number'].toString(),
                                                 camera_location: profile['camera_location'].toString(),
                                                 image_captured: profile['image_captured'],
                                                // image_captured: "http://192.168.1.104:80/test.jpg",
                                                 temperature: profile['temperature'],
                                                 array: profile['array'],
                                                 location: profile['location'],
                                                 manual_datetime: profile['manual_dateTime'],
                                                 manual_temperature: profile['manual_temperature'],
                                                 manual_remarks: profile['manual_remarks'],
                                                 imagePath: profile['imagePath'],
                                                 isMask: profile['isMask']
                                                 )).toList();
  }
}




