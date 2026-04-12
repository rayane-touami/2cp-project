import 'package:flutter/material.dart';
import '../../widgets/standard_Title.dart';
import '../../widgets/standard_textfield.dart';
import '../../widgets/standard_Button.dart';
import 'package:compusmarket/screens/authentication/Enter_OTP.dart';
void main() {
  runApp(MaterialApp(
    home: SignUpScreen(), 
  ));
}

class SignUpScreen extends StatefulWidget{
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
  }
  class _SignUpScreenState extends State<SignUpScreen>{
    TextEditingController emailController = TextEditingController(); 
    TextEditingController univerController = TextEditingController(); 
    TextEditingController nameController = TextEditingController(); 
    TextEditingController PasswordController = TextEditingController();
     bool _submitted = false;
     @override
  void initState() {
    super.initState();
   
    emailController.addListener(() {
      setState(() {});
    });
    univerController.addListener(() {
      setState(() {});
    });
    nameController.addListener(() {
      setState(() {});
    });
    PasswordController.addListener(() {
      setState(() {});
    });
  }
  @override
  void dispose() {
    emailController.dispose(); 
    univerController.dispose(); 
    nameController.dispose(); 
    PasswordController.dispose(); 
    super.dispose();
  } 
    @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
       StandardTitle(title: "Create Account" , pargh: "Lorem ipsum dolor sit amet , consectetur",), 
       Positioned( // posision of the main Container
        top: 265,
        left: 0,
        right: 0,
        bottom: 0,
        child: 
        Container(  
          margin: EdgeInsets.only(left: 30 , right: 30,),
          child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start, 
           children: [
            StandardTextfield(title:"Full Name", hint:"Enter your name",controller: nameController,isError: _submitted && nameController.text.isEmpty,),
            StandardTextfield(title:"University", hint:"Enter your university",controller: univerController,isError: _submitted && univerController.text.isEmpty,),
            StandardTextfield(title:"E-mail", hint:"Enter your email",isEmail: true,controller: emailController,isError: _submitted && emailController.text.isEmpty,),
            StandardTextfield(title:"Password", hint:"Enter your Password",isPassword: true,controller: PasswordController,isError: _submitted && PasswordController.text.isEmpty,),
            SizedBox(height: 10,),
            StandardButton(text: "Create An Account",onPressed: () {
              _testemail(context);
            },),
            SizedBox(height: 30,),
          // Container(
          //   margin: EdgeInsets.only(bottom: 35),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //        Container(
          //         margin: EdgeInsets.only(right: 10),
          //       color: Color(0xffdfe1e6),
          //       width: 70,
          //       height: 1,
          //      ),
          //      Text("Or Sign In with" , 
          //      style: TextStyle(
          //       fontSize: 15,
          //       color: Color(0xffa4abb8),
          //      ),),
          //       Container(
          //          margin: EdgeInsets.only(left: 10),
          //       color: Color(0xffdfe1e6),
          //       width: 70,
          //       height: 1,
          //      ),

          //     ],
          //   ),
            
          // ),
    //       Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Material(
    //   color: Color(0xffeceff3),
    //   borderRadius: BorderRadius.circular(10),
    //   child: InkWell(
    //     borderRadius: BorderRadius.circular(10),
    //     onTap: () {},
    //     child: SizedBox(
    //       width: 85,
    //       height: 55,
    //       child: Center(
    //         child: Image.asset("assets/images/google.png", width: 60, height: 60),
    //       ),
    //     ),
    //   ),
    // ),
    // SizedBox(width: 20,),
    //           Material(
    //   color: Color(0xffeceff3),
    //   borderRadius: BorderRadius.circular(10),
    //   child: InkWell(
    //     borderRadius: BorderRadius.circular(10),
    //     onTap: () {},
    //     child: SizedBox(
    //       width: 85,
    //       height: 55,
    //       child: Center(
    //         child: Image.asset("assets/images/apple.png", width: 60, height: 60),
    //       ),
    //     ),
    //   ),
    // ),  
               
    //           ],
    //         ),
            Spacer(),

           Container(
            margin: EdgeInsets.only(left: 30 , right: 30, bottom: 45 ),
          child:   RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Color(0xff666d80) , fontSize: 17, fontFamily: 'Inter'),
              children: [
                TextSpan(text: "By signing up you agree to our "),
                TextSpan(
                  text: "Terms ", style: TextStyle(color: Colors.black),
                ),
                TextSpan(text: "and "),
                TextSpan(text: "Conditions of Use" , style: TextStyle(color: Colors.black))
              ]
            )
           
           )
           )


           ],),),), 
      ],
    ),
  );
  }

  void _testemail (BuildContext context){
    setState(() {
    _submitted = true; 
  });
 if(nameController.text.isEmpty || emailController.text.isEmpty || PasswordController.text.isEmpty ||univerController.text.isEmpty ){
    print("Fill all fields");
    return;
  } 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OTPScreen()),);

  }
  }
  