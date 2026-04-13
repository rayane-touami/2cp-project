import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final String text;
  final VoidCallback ?onPressed ;
   const StandardButton({super.key , required this.text , this.onPressed });
   @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return 
    MaterialButton(
            onPressed: onPressed,
            color: Color(0xff2853af),
            textColor: Colors.white,
            minWidth: double.infinity,
            height: screenHeight * 0.063,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.035)
            ) ,
            child: Text(text, style: TextStyle(
              fontFamily: 'Inter',
              fontSize: screenWidth * 0.042,
            ),),

          
          );
  }
}