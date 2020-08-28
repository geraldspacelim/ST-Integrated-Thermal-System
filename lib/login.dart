import 'dart:async';

import 'package:facial_capture/home.dart';
import 'package:facial_capture/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = false; 
  final _formKey = GlobalKey<FormState>(); 
  String username = '';
  String password = ''; 
  String error = '';

  // new edits 
  String url = ""; 
  var txt = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    url = "http://10.168.4.9:81";
    txt.text = url; 
    usernameController.text = "AFC";
    username = usernameController.text;
    passwordController.text = "password";
    password = usernameController.text;
  }

  _settings(context) {
     Alert(
      context: context,
      title: "CONFIGURATION",
      content: Column(
        children: <Widget>[
          TextField(
            controller: txt,
            decoration: InputDecoration(
              icon: Icon(Icons.language),
              labelText: 'URL',
            ),
            onChanged: (value) {
              url = value; 
            },
          ),
        ],
      ),
      buttons: [
        DialogButton(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color(0xff000428),
                Color(0xff004e92),
              ]
            ),
          onPressed: () {
            // prefs.setString('url', url);
            Navigator.pop(context);
          },
          child: Text(
            "SUBMIT",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
  }
  

 @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Form(
      key: _formKey, 
          child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color(0xff000428),
                Color(0xff004e92),
              ]
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        // print("tap");
                        txt.text = url;
                        _settings(context);
                      },
                        child: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    )
                ],),
              ),
              SizedBox(height: 50,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Login", style: TextStyle(
                      color: Colors.white, fontSize: 60
                    ),),
                    SizedBox(height: 10,),
                    Text("Integrated Thermal System", style: TextStyle(color: Colors.white, fontSize: 25),),
                  ],
                ),
              ),
              SizedBox(height: 80),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 60,),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                color: Color.fromRGBO(0, 4, 40, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10)
                              )]
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200]))
                                  ),
                                  child: TextFormField(
                                    controller: usernameController,
                                    validator: (val) => val.isEmpty ? "Enter a usename": null,
                                    decoration: InputDecoration(
                                      hintText: "Username ",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none             
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        username = value; 
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                  ),
                                  child: TextFormField(
                                    controller: passwordController,
                                    obscureText: true,
                                    validator: (val) => val.isEmpty ? "Enter a password": null,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none                         
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                          Text("Forget Password?", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 40,),
                           RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                            ),
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff000428),
                                  Color(0xff004e92)
                                ]
                              )
                            ),
                              child: Center(
                              child: Text(
                                "Login", 
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => {
                                _loading = true
                              });
                              // await AuthService().signInAnonymously();
                              //  SharedPreferences prefs = await SharedPreferences.getInstance();
                              //  prefs.setString('username', username); 
                               Timer(
                                Duration(seconds: 3),(){
                                  setState(() {
                                    _loading = false; 
                                      // return Home();
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(username: username)));
                                  });
                                  }
                                );
                            
                            }
                          },
                        ),
                          SizedBox(height: 60,),
                          Container(
                            height: 95.0,
                            width: 515.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/STlogo.jpg'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )                  
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}