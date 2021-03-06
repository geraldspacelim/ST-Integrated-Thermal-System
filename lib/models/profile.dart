import 'dart:typed_data';

import 'package:flutter/material.dart';

class Profile {
  final String uid; 
  final String name;
  final int datetime; 
  final String camera_number;
  final String camera_location; 
  final String image_captured;
  final double temperature; 
  final String array; 
  final String location;
  final int manual_datetime; 
  final double manual_temperature; 
  final String manual_remarks; 
  final String imagePath; 
  final bool isMask;
  
  const Profile({this.uid, this.name, this.datetime, this.camera_number, this.camera_location, this.image_captured, this.temperature, this.array, this.location, this.manual_datetime, this.manual_temperature, this.manual_remarks, this.imagePath, this.isMask});
}

