// ignore: file_names
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget{
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
  }

   class _MyProfileScreenState extends State<MyProfileScreen>{
     @override
  Widget build(BuildContext context) {
     final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
             width: double.infinity,
              height: double.infinity,
            decoration: BoxDecoration(
              image:DecorationImage(
                image: AssetImage('assets/images/blue_background.jfif'),
                  fit: BoxFit.cover,
              )
            ),
          ),
          Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: Container(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
  BoxShadow(
    color: Colors.grey.withOpacity(0.3),
    blurRadius: 10,
    offset: Offset(0, 5),
  ),
]
              ),
            ), 
          ),
          Positioned(
            top:300,
            left: 20,
            right: 20,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
               
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
  BoxShadow(
    color: Colors.grey.withOpacity(0.3),
    blurRadius: 10,
    offset: Offset(0, 5),
  ),
],

              ),
              child:Column(
                children: [
                   SizedBox(height: screenHeight*0.01,),
                     Text("Malak Samai",style: TextStyle(
                fontSize: screenWidth*0.05,
                fontWeight: FontWeight.bold,
              ),),
                SizedBox(height: screenHeight*0.04,),
                 Container(
                  height: screenHeight*0.001,
                  width: screenWidth*0.7,
                  color:Color(0xffc1c7cf),
                 ),
                 SizedBox(height: screenHeight*0.03,),
                 Row(
                  children: [
                    Text("Items",style: TextStyle(
                      color: Color(0xffa4abb8),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*0.04

                      ),),
                  ],
                 ),

                ],
              )
             
            ), 
          ),
Positioned(
  top: screenHeight * 0.2, // adjust to sit on card edge
  left: 0,
  right: 0,
  child: Center(
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
        image: DecorationImage(
          image: AssetImage("assets/images/malak's_pic.jpg"),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    ),
  ),
),

 


        ],
      ),
    );
  }
   }