import 'package:compusmarket/screens/authentication/sign_up.dart';
import 'package:flutter/material.dart';
import '../../widgets/standard_Title.dart';
import '../../widgets/standard_textfield.dart';
import '../../widgets/standard_Button.dart';
import 'package:compusmarket/screens/authentication/forgot_password.dart';


//===========  Statfulwidget  ===========//
void main() {
  runApp(MaterialApp(
    home: SignInScreen(), 
  ));
}

class SignInScreen extends StatefulWidget{
  @override
  State<SignInScreen> createState() => _SignInScreenState();
  }

class _SignInScreenState extends State<SignInScreen>{

  bool Status=false; //for checkbox of remember me 
  bool visibility=true;

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body:Stack(children: [

//===============  Title ===============//

        StandardTitle(title: "Let's Sign You In " , pargh: "Lorem ipsum dolor sit amet , consectetur",),

//============== Sign In ===============//
//        
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
            StandardTextfield(title:"Email Adress", hint:"Enter your email adress"),
            StandardTextfield(title:"Password", hint:"Enter your Password",isPassword: true,),
          Container(
           margin: EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                 Transform.scale(
                  scale: 1.5,
                 child:  Checkbox(
                value: Status, 
                shape: CircleBorder(),
                side: BorderSide(
                  color: Color(0xffdfe1e6)
                ),
              onChanged: (val){
                setState(() {
                  Status = val!;
                });
              })
                ),

                Text("Remember Me",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: Color(0xff666d80)
                ), 
                ),
                Spacer(),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),);
                  } ,
                  child: Text("Forgot Password" ,
                  style:TextStyle(
                    color:Colors.red,
                    fontFamily: 'Inter' ,
                    fontSize: 15,
                  ),
   
                  )
                )
              
              ],
            ),
          ),

          StandardButton(text: "Sign In",onPressed: () {},),

          Container(
            margin: EdgeInsets.only(top: 30 , bottom: 25),
            
           child:  Row(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? " , style: TextStyle(
                color: Color(0xff808897),
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Inter',
              ),),

              InkWell(
                 
                onTap: () {
                   Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),);
                } ,
                child: Text(" Sign Up" , style: TextStyle(
                  color: Color(0xff2853af),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  fontFamily: 'Inter',
                ),),
              ),
            ],
           )
          ),
          
          Container(
            margin: EdgeInsets.only(bottom: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Container(
                  margin: EdgeInsets.only(right: 10),
                color: Color(0xffdfe1e6),
                width: 70,
                height: 1,
               ),
               Text("Or Sign In with" , 
               style: TextStyle(
                fontSize: 15,
                color: Color(0xffa4abb8),
               ),),
                Container(
                   margin: EdgeInsets.only(left: 10),
                color: Color(0xffdfe1e6),
                width: 70,
                height: 1,
               ),

              ],
            ),
          ),

           Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
      color: Color(0xffeceff3),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {},
        child: SizedBox(
          width: 85,
          height: 55,
          child: Center(
            child: Image.asset("assets/images/google.png", width: 60, height: 60),
          ),
        ),
      ),
    ),
    SizedBox(width: 20,),
              Material(
      color: Color(0xffeceff3),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {},
        child: SizedBox(
          width: 85,
          height: 55,
          child: Center(
            child: Image.asset("assets/images/apple.png", width: 60, height: 60),
          ),
        ),
      ),
    ),  
               
              ],
            ),
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

            

          ]
          )
        )
       )
      ],)
);
    
  }

}
