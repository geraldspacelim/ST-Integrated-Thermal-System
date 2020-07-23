import 'package:facial_capture/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facial_capture/models/temperature.dart';

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
    return querySnapshot.documents.map((doc) {
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
  }

  Stream <List<Profile>> profileDataArray1(String sortType, String array) {
    return profileCollection.orderBy(sortType, descending: true).where('array', isEqualTo: array).snapshots().map(_profileListFromSnapshot);

    // if (sortType == 'temperature' && array == 1) {
    //   return profileCollection.where('array', isEqualTo: array).orderBy('temperature', descending: true).snapshots().map(_profileListFromSnapshot);
    // } else if (sortType == 'temperature' && array == 2) {
    //   return profileCollection.where('array', isEqualTo: array).orderBy('temperature', descending: true).snapshots().map(_profileListFromSnapshot); 
    // }  
  }
}