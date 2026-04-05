import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final String text;
  final VoidCallback ?onPressed ;
   const StandardButton({super.key , required this.text , this.onPressed });
   @override
  Widget build(BuildContext context) {
    return 
    MaterialButton(
            onPressed: onPressed,
            color: Color(0xff2853af),
            textColor: Colors.white,
            minWidth: double.infinity,
            height: 60,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ) ,
            child: Text(text, style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
            ),),

          
          );
  }
}