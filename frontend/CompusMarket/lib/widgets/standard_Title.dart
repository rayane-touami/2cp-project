import 'package:flutter/material.dart';

class StandardTitle extends StatelessWidget {
  final String title;
  final String pargh;
  const StandardTitle({super.key , required this.title , required this.pargh});

  @override
  Widget build(BuildContext context) {
    return 
      Stack(
        children: [
          Positioned(
            top: 70,
            left: 20,
            child: 
           IconButton(
             onPressed: () {
              Navigator.pop(context);
             },
             iconSize: 28,
                     icon: Icon(Icons.arrow_back , color: Colors.black,)
                     ),),

                     Positioned(
                      top: 150,
                       left: 0,
                       right: 0,
                     child: Column(
                     children: [
                      SizedBox(
                      child: Text(title,
                      textAlign: TextAlign.center,
                       style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 26,
                       ),),),
                      SizedBox(height: 10,),
                      Text(
                       pargh, // manually control where it breaks
                       textAlign: TextAlign.center,
                       style: TextStyle(
                       fontFamily: 'Inter',
                       fontSize: 15,
                      color: Color(0xff353849),
                      ),
                     ),],
                  ),
                )

        ],
      );
}
}