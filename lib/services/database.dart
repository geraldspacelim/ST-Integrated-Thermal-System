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

  Stream <List<Profile>> profileData(String array, String temperature, String datetime) {
    print(array); 
    print(temperature);
    print(datetime);
    int milliseconds = 0;
    int currentMillieseconds = 0;
    if (datetime != 'default') {
       milliseconds = int.parse(datetime);
       currentMillieseconds = int.parse(DateTime.now().millisecondsSinceEpoch.toString());
    }
    if (temperature == 'default' && datetime == 'default' && array == 'default') {
      return profileCollection.orderBy('datetime', descending: true).snapshots().map(_profileListFromSnapshot);
    } else if (temperature == 'safe' && array == 'default') {
      return profileCollection.where('temperature', isLessThan: 37.5).orderBy('temperature', descending: true).orderBy('datetime', descending : true).snapshots().map(_profileListFromSnapshot);
    }  else if (temperature == 'danger' && array == 'default') {
      return profileCollection.where('temperature', isGreaterThanOrEqualTo: 37.5).orderBy('temperature', descending: false).orderBy('datetime', descending : true).snapshots().map(_profileListFromSnapshot);
    } else if (milliseconds <= 60 && array == 'default' && temperature == 'default') {
      return profileCollection.where('datetime', isGreaterThanOrEqualTo: currentMillieseconds - milliseconds * 60000).orderBy('datetime', descending: true).snapshots().map(_profileListFromSnapshot);
    } else if (milliseconds > 60 && array == 'default' && temperature == 'default') {
      return profileCollection.where('datetime', isGreaterThanOrEqualTo: milliseconds).where('datetime', isLessThanOrEqualTo: milliseconds + 86400000).orderBy('datetime', descending: true).snapshots().map(_profileListFromSnapshot);
    } else if (temperature == 'default' && datetime == 'default') {
      return profileCollection.where('array', isEqualTo: array).orderBy('array').orderBy('datetime', descending: true).snapshots().map(_profileListFromSnapshot);
    }

  }
}