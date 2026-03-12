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
             onPressed: () {},
             iconSize: 28,
                     icon: Icon(Icons.arrow_back , color: Colors.black,)
                     ),),

           Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Column( children: [
            SizedBox(
              height: 50,
              child: Text(title , style: TextStyle(
                fontWeight:FontWeight.bold , 
                fontFamily: 'Inter',
                fontSize: 28,
               ),),
            ),
              SizedBox(
              height: 50,
              child: Text(pargh , style: TextStyle( 
                fontSize: 15,
                fontFamily: 'Inter',
                color:Color(0xff353849) 
               ),),
            )
            ])
           ),

        ],
      );
}
}