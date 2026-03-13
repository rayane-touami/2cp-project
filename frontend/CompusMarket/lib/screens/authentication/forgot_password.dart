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
          StandardTitle(title: "Forgot Password" , pargh: "Recover your account password",),
          Positioned( // posision of the main Container
        top: 265,
        left: 0,
        right: 0,
        bottom: 0,
        child: 
        Container(   // Container had all the sign in without title part 
          margin: EdgeInsets.only(left: 30 , right: 30,),
          child: Column(   // had childs in column
          crossAxisAlignment: CrossAxisAlignment.start, // for the children in the column begin from left :0 
           children: [
            StandardTextfield(title:"E-mail", hint:"Enter your email"),
           Container(
            margin: EdgeInsets.only(top:30,),
           child:   StandardButton(text: "Next"),
           )
        ], 
      ),
    ),
   )
        ]
      )
    )
   );
  }
  }