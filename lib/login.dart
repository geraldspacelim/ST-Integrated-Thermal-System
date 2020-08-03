import 'package:facial_capture/home.dart';
import 'package:facial_capture/widgets/loading.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false; 
  final _formKey = GlobalKey<FormState>(); 
  String email = '';
  String password = ''; 
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Form(
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
              SizedBox(height: 80,),
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
                                    validator: (val) => val.isEmpty ? "Enter a usename": null,
                                    decoration: InputDecoration(
                                      hintText: "Username ",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none             
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                  ),
                                  child: TextFormField(
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
                          Text("Forgot Password?", style: TextStyle(color: Colors.grey),),
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
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                                 Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );          
                            }
                          },
                        ),
                          SizedBox(height: 50,),
                          Container(
                            height: 38.0,
                            width: 200.0,
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