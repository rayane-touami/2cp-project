import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../../widgets/standard_Title.dart';
import '../../widgets/standard_textfield.dart';
import '../../widgets/standard_Button.dart';

class CreateNewPasswordScreen extends StatefulWidget{
  @override
  State<CreateNewPasswordScreen> createState() => _CreateNewPasswordScreenState();
  }

  class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen>{
    TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
   bool _submitted = false;
     @override
  void initState() {
    super.initState();
   
    newPasswordController.addListener(() {
      setState(() {});
    });
    confirmPasswordController.addListener(() {
      setState(() {});
    });
  }
  
  @override
  void dispose() {
    newPasswordController.dispose(); 
    confirmPasswordController.dispose(); 
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
     return  Builder(builder: (context) {
      return Scaffold(
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
          child: SingleChildScrollView( child:  Column(   // had childs in column
          crossAxisAlignment: CrossAxisAlignment.start, // for the children in the column begin from left :0 
           children: [
          Container(margin: EdgeInsets.only(bottom: 10),
            child: StandardTextfield(title: "New Password", hint: "Enter new password",isPassword: true,controller: newPasswordController, isError: _submitted && newPasswordController.text.isEmpty, ),),
          StandardTextfield(title: "Confirm Password", hint: "Confirm your password",isPassword: true,controller: confirmPasswordController,isError: _submitted && confirmPasswordController.text.isEmpty, ),
         Container(
          margin: EdgeInsets.only(top: 25),
         child:   StandardButton(text: "Next" ,onPressed: () {
           _Success(context);
         }  ),
         ),
        ],
      ),),
    ),
    )]));},);
  }
  void _Success (BuildContext context){
    setState(() {
    _submitted = true; 
  });
     if (newPasswordController.text.isEmpty ||
      confirmPasswordController.text.isEmpty) {
    print("Fill all fields");
    return;
  }

  if (newPasswordController.text != confirmPasswordController.text) {
    print("Passwords don't match");
    return;
  }

  _showSuccessDialog(context);
}

void _showSuccessDialog(BuildContext context){
showDialog(context: context,
barrierDismissible: true,
 builder:(context){
return Stack(
children: [
  BackdropFilter(
     filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
     child: Container(
      color: Colors.black.withOpacity(0),
     ),
  ),
  Align(
    alignment: Alignment.center,
    child:
  Container(
    // margin: EdgeInsets.symmetric(horizontal: 30 ),
   //  padding: EdgeInsets.only(left: 40 , right: 40), 
   width: 300,
   height: 300,
    decoration: BoxDecoration(
      color: Colors.white,
     borderRadius: BorderRadius.circular(15),),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
       Container(
        margin: EdgeInsets.only(top: 20,),
        child:  SvgPicture.asset(
  'assets/images/check.svg',
  width: 100,
  height: 100,
),
       ),
       Text("Success",style: TextStyle(
        fontFamily: 'Inter',fontWeight: FontWeight.bold,fontSize: 19,color: Colors.black,
        decoration: TextDecoration.none,
      ),),
     SizedBox(height: 8,),
      Text("Your password is succesfully \n created" ,
      textAlign: TextAlign.center,
       style: TextStyle(
        fontFamily: 'Inter',
        height: 1.6,
        fontSize: 14,
        color: Color(0xff808897),
        decoration: TextDecoration.none,
       // fontWeight: FontWeight.normal,
      ),),
      SizedBox(height: 17),
       MaterialButton(
            onPressed: (){},
            color: Color(0xff2853af),
            textColor: Colors.white,
            minWidth: 150,
            height: 55,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ) ,
            child: Text("Continue", style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
            ),),

          
          ),


      ] ),
     ),
    
    ),
]
);
 });
}
  



  }

  
