import 'dart:ui';
import 'package:compusmarket/screens/authentication/sign_in.dart';
import 'package:compusmarket/services/auth_services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../../widgets/standard_Title.dart';
import '../../widgets/standard_textfield.dart';
import '../../widgets/standard_Button.dart';

class CreateNewPasswordScreen extends StatefulWidget{
  final String email; 
  final String code; 

const CreateNewPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

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
  return Scaffold(
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StandardTitle(
            title: "Create a \n New Password",
            pargh: "Enter your new password",
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StandardTextfield(
                  title: "New Password",
                  hint: "Enter new password",
                  isPassword: true,
                  controller: newPasswordController,
                  isError: _submitted && newPasswordController.text.isEmpty,
                ),
                SizedBox(height: 10),
                StandardTextfield(
                  title: "Confirm Password",
                  hint: "Confirm your password",
                  isPassword: true,
                  controller: confirmPasswordController,
                  isError: _submitted && confirmPasswordController.text.isEmpty,
                ),
                SizedBox(height: 25),
                StandardButton(
                  text: "Next",
                  onPressed: () => _Success(context),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
 // ignore: non_constant_identifier_names
 void _Success(BuildContext context) async {
  setState(() => _submitted = true);

  if (newPasswordController.text.isEmpty ||
      confirmPasswordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Please fill all fields.')),
    );
    return;
  }

  if (newPasswordController.text != confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Passwords do not match.')),
    );
    return;
  }

  try {
    await AuthService.resetPassword(
      widget.email,
      widget.code,
      newPasswordController.text,
    );
    // ignore: use_build_context_synchronously
    _showSuccessDialog(context);
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Reset failed. Try again.')),
    );
  }
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
      // ignore: deprecated_member_use
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
            onPressed: (){
               Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (route) => false,
    );
            },
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

  
