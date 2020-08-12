import 'dart:math';

import 'package:facial_capture/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facial_capture/models/temperature.dart';
import 'package:intl/intl.dart';

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
        manual_remarks: doc.data['manual_remarks']
      );
    }).toList();
    return (listOfProfiles);
  }

  Stream <List<Profile>> profileData() {
    return profileCollection.orderBy('datetime', descending: true).snapshots().map(_profileListFromSnapshot);
  //   int currentMillieseconds = int.parse(DateTime.now().millisecondsSinceEpoch.toString());
  //   if (array != 'default' && temperature == 'default' && datetime == 'default') {
  //     // print("array selected");
  //     profiles = profiles.where("array", isEqualTo: array);
  //   } 
  //   else if (temperature != 'default' && array == 'default' && datetime == 'default' ) {
  //     // print("temperature selected");
  //     profiles = profiles.where("temperature", isGreaterThanOrEqualTo: temperature == 'danger' ?  37.5 :  37.5);
  //   } 
  //   else if (datetime != 'default' && temperature == 'default' && array == 'default') {
  //     // print("datetime selected"); 
  //     profiles = profiles.where("datetime", isGreaterThanOrEqualTo: int.parse(datetime) <= 60 ? currentMillieseconds - (int.parse(datetime)*60000) : datetime >= int.parse(datetime) && i.datetime <= int.parse(datetime) + 86400000);
  //   } 
  //   else if (array != 'default' && temperature != 'default' && datetime == 'default') {
  //     // print("array and temperature selected");
  //     var temp_profiles = profiles.where((i) => i.array == array);
  //     return temp_profiles.where((i) =>  temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5).snapshots().map(_profileListFromSnapshot);
  //   } 
  //   else if (array != 'default' &&temperature == 'default' && datetime != 'default') {
  //     // print("array and datetime selected"); 
  //     var temp_profiles = profiles.where((i) => i.array == array);
  //     return temp_profiles.where((i) => int.parse(datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(datetime)*60000) : i.datetime >= int.parse(datetime) && i.datetime <= int.parse(datetime) + 86400000).snapshots().map(_profileListFromSnapshot);
  //   } 
  //   else if (array == 'default' && temperature != 'default' && datetime != 'default') {
  //     // print("temperature and datetime selected");
  //     var temp_profiles = profiles.where((i) =>  temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5);
  //     return temp_profiles.where((i) => int.parse(datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(datetime)*60000) : i.datetime >= int.parse(datetime) && i.datetime <= int.parse(datetime) + 86400000).snapshots().map(_profileListFromSnapshot);
  //   } else if (array != 'default' && temperature != 'default' && datetime != 'default'){
  //     // print("all selected");
  //     var temp_profiles = profiles.where((i) => i.array ==array);
  //     var temp_profiles_2 = temp_profiles.where((i) => temperature == 'danger' ? i.temperature >= 37.5 : i.temperature < 37.5);
  //     return temp_profiles_2.where((i) => int.parse(datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(datetime)*60000) : i.datetime >= int.parse(datetime) && i.datetime <= int.parse(datetime) + 86400000).snapshots().map(_profileListFromSnapshot);
  //   }
  //   if (processed) {
  //     return profiles.where((i) => i.manual_temperature != 0.1).snapshots().map(_profileListFromSnapshot);
  //   }

  //   return profiles.snapshots().map(_profileListFromSnapshot);

  }
}



