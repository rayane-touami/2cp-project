import 'package:flutter/material.dart';

class StandardTitle extends StatelessWidget {
  final String title;
  final String pargh;
  const StandardTitle({super.key , required this.title , required this.pargh});

  @override
  Widget build(BuildContext context) {
     final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return 
      Stack(
        children: [
          Positioned(
            top: screenHeight * 0.073,
            left: screenWidth * 0.047,
            child: 
           IconButton(
             onPressed: () {
              Navigator.pop(context);
             },
             iconSize: screenWidth * 0.065,
                     icon: Icon(Icons.arrow_back , color: Colors.black,)
                     ),),

                     Positioned(
                      top: screenHeight * 0.157,
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
                      fontSize: screenWidth * 0.061,
                       ),),),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                       pargh, // manually control where it breaks
                       textAlign: TextAlign.center,
                       style: TextStyle(
                       fontFamily: 'Inter',
                       fontSize: screenWidth * 0.035,
                      color: Color(0xff353849),
                      ),
                     ),],
                  ),
                )

        ],
      );
}
}