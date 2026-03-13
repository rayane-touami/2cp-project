import 'package:flutter/material.dart';
import '../../widgets/standard_Title.dart';
import '../../widgets/standard_textfield.dart';
import '../../widgets/standard_Button.dart';
void main() {
 runApp( MyApp());// it should be the widjet name in capital for first letter

}

class MyApp extends StatefulWidget{
  @override
  State<MyApp> createState() => _MyAppState();
  }

  class _MyAppState extends State<MyApp>{
    @override
  Widget build(BuildContext context) {
     return MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          StandardTitle(title: "Create a \n New Password" , pargh: "Enter your new password",),
          Positioned( // posision of the main Container
        top: 300,
        left: 0,
        right: 0,
        bottom: 0,
        child: 
        Container(   // Container had all the sign in without title part 
          margin: EdgeInsets.only(left: 30 , right: 30,),
          child: Column(   // had childs in column
          crossAxisAlignment: CrossAxisAlignment.start, // for the children in the column begin from left :0 
           children: [
          Container(margin: EdgeInsets.only(bottom: 10),
            child: StandardTextfield(title: "New Password", hint: "Enter new password",isPassword: true,),),
          StandardTextfield(title: "Confirm Password", hint: "Confirm your password",isPassword: true,),
         Container(
          margin: EdgeInsets.only(top: 25),
         child:   StandardButton(text: "Next"),
         )
        ],
      ),
    )
    )])));
  }
  }