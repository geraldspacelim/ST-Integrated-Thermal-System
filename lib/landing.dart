import 'package:facial_capture/home.dart';
import 'package:facial_capture/login.dart';
import 'package:facial_capture/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    if(user == null){
      return Login();
    }else{
      return Home();
    }
  }
}