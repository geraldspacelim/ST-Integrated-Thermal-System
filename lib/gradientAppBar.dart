import 'package:flutter/material.dart'; 

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget{
  final double _preferredHeight = 100.0; 

  String title; 
  Color gradientBegin, gradientEnd; 

  GradientAppBar({this.title, this.gradientBegin, this.gradientEnd}); 

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _preferredHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            gradientBegin, 
            gradientEnd
          ]
        )
      ),
      child: Text(
        title, 
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 10.0,
          fontSize: 30.0
        )
      ),
      
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}