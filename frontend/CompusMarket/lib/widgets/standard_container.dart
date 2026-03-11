import 'package:flutter/material.dart';

class StandardContainer extends StatelessWidget {
  final String title;
  final String pargh;
  const StandardContainer({super.key , required this.title , required this.pargh});

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
             iconSize: 30,
                     icon: Icon(Icons.arrow_back , color: Colors.black,)
                     ),),
           Positioned(
            top: 150,
            child: 
            Container(
              width: 440,
              height: 50,
              margin: EdgeInsets.only(left: 10 , right: 10,),
              alignment: Alignment.center,
              child: Text(title , style: TextStyle(
                fontWeight:FontWeight.bold , 
                fontFamily: 'Inter',
                fontSize: 33,

               ),),
            )
           ),
            Positioned(
            top: 200,
            child: 
            Container(
              width: 440,
              height: 50,
              margin: EdgeInsets.only(left: 10 , right: 10,),
              alignment: Alignment.center,
              child: Text(pargh , style: TextStyle( 
                fontSize: 17,
                fontFamily: 'Inter',
                color:Color(0xff353849) 
               ),),
            )
           ),
        ],
      );
}
}