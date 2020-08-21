import 'dart:convert';
import 'dart:math';

import 'package:facial_capture/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DatabaseService {

  final CollectionReference profileCollection = Firestore.instance.collection('profiles');

  // Future uploadPhoto(String personId, String url) async {
  //   await profileCollection.document(personId).setData({
  //     'name': personId, 
  //     'datetime': new DateTime.now().millisecondsSinceEpoch,
  //     'camera_number': 'test',
  //     'camera_location': 'test',
  //     'image_captured': url
  //   });
  // }

  // Future update

  Future updateDatabase (String uid, double newTemperature, int newTimeTaken, String remarks) async {
    final DocumentReference postRef = Firestore.instance.collection('profiles').document(uid);
    Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      await tx.update(postRef, <String, dynamic>{'manual_datetime': postSnapshot.data['datetime'], 
                                                 'manual_remakrs': remarks, 
                                                 'manual_temperature': postSnapshot.data['temperature'], 
                                                 'temperature': newTemperature,
                                                 'datetime': newTimeTaken, 
        });
      }
    });
  }

  // profiles snapshot 
  List <Profile> _profileListFromSnapshot(QuerySnapshot querySnapshot) {
    List <Profile> listOfProfiles =  querySnapshot.documents.map((doc) {
      return Profile(
        uid: doc.data['uid'],
        name: doc.data['name'],
        datetime: doc.data['datetime'], 
        camera_number: doc.data['camera_number'],
        camera_location: doc.data['camera_location'],
        image_captured: doc.data['image_captured'],
        temperature: doc.data['temperature'],
        array: doc.data['array'],
        location: doc.data['location'],
        manual_datetime: doc.data['manual_datetime'],
        manual_temperature: doc.data['manual_temperature'],
        manual_remarks: doc.data['manual_remarks'],
      );
    }).toList();
    return (listOfProfiles);
  }

  Future updateDatabaseST (Profile profile) async {
    final http.Response response = await http.post(
      'http://192.168.1.104:82/API/imagesnap/UpdateTemperatureInfo',
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
                                                 imagePath: profile['imagePath'])).toList();
  }


  // Stream<List<Profile>> getProfilesStream (Duration refreshTime) async * {
  //   while (true) {
  //     await Future.delayed(refreshTime);
  //     yield await profileDataST();
  //   }
  // }

  
}




