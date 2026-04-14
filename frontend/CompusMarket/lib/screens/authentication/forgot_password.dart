import 'package:flutter/material.dart';
import '../../widgets/standard_Title.dart';
import '../../widgets/standard_textfield.dart';
import '../../widgets/standard_Button.dart';
import 'package:compusmarket/screens/authentication/Enter_OTP.dart';

class ForgotPasswordScreen extends StatefulWidget{
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
 
}

  class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>{
    TextEditingController emailController = TextEditingController(); 
     bool _submitted = false;
     @override
  void initState() {
    super.initState();
   
    emailController.addListener(() {
      setState(() {});
    });
  }
  @override
  void dispose() {
    emailController.dispose(); 
    super.dispose();
  }


    @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.white,
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
            StandardTextfield(title:"E-mail", hint:"Enter your email" ,isEmail: true, controller: emailController,isError: _submitted && emailController.text.isEmpty,),
           Container(
            margin: EdgeInsets.only(top:30,),
           child:   StandardButton(text: "Next",onPressed: () {
            _test(context);
                  
           },),
           )
        ], 
      ),
    ),
   )
        ]
      )
    );
  }
  void _test(BuildContext context){
    setState(() {
    _submitted = true; 
  });
  if(emailController.text.isEmpty){
    print("Fill all fields");
    return;
  } 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OTPScreen()),);

  }
  }