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
      boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
        gradient: LinearGradient(
          colors: <Color> [
            gradientBegin, 
            gradientEnd
          ]
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontFamily: 'Open Sans',
              fontSize: 35,
              letterSpacing: 1.5
            ),
          ),
          // SizedBox(width: 10,),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}