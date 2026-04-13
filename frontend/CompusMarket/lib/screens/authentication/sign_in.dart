import 'package:compusmarket/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:compusmarket/screens/authentication/sign_up.dart';
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
   TextEditingController emailController = TextEditingController(); 
    TextEditingController PasswordController = TextEditingController();

  bool Status=false; //for checkbox of remember me 
  bool visibility=true;
   bool _submitted = false;
   bool _isLoading = false;
     @override
  void initState() {
    super.initState();
   
    emailController.addListener(() {
      setState(() {});
    });
   
    PasswordController.addListener(() {
      setState(() {});
    });
  }
  @override
  void dispose() {
    emailController.dispose(); 
    PasswordController.dispose(); 
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  print('Height: $screenHeight, Width: $screenWidth');

    return  Scaffold(
      body:Stack(children: [

//===============  Title ===============//

        StandardTitle(title: "Let's Sign You In " , pargh: "Lorem ipsum dolor sit amet , consectetur",),

//============== Sign In ===============//
//        
       Positioned( // posision of the main Container
        top: MediaQuery.of(context).size.height * 0.28,
        left: 0,
        right: 0,
        bottom: 0,
        child: 
        Container(   // Container had all the sign in without title part 
         margin: EdgeInsets.symmetric(
  horizontal: screenWidth * 0.07
),
          child: Column(   // had childs in column
          crossAxisAlignment: CrossAxisAlignment.start, // for the children in the column begin from left :0 
           children: [
            StandardTextfield(title:"Email Adress", hint:"Enter your email adress" ,isEmail: true,controller: emailController,isError: _submitted && emailController.text.isEmpty,),
            StandardTextfield(title:"Password", hint:"Enter your Password",isPassword: true,controller: PasswordController,isError: _submitted && PasswordController.text.isEmpty,),
           Row(
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
                  fontSize: screenWidth*0.035,
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
                    fontSize: screenWidth*0.035,
                  ),
   
                  )
                )
              
              ],
            ),
          
    SizedBox(height:screenHeight * 0.010 ,),
          StandardButton(
            text: _isLoading ? "Signing in..." : "Sign In",
  onPressed: _isLoading ? null : () {
    _testfields(context);
  },
          ),

          SizedBox(height:screenHeight * 0.031 ,),
            
            Row(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? " , style: TextStyle(
                color: Color(0xff808897),
                fontWeight: FontWeight.bold,
                fontSize: screenWidth*0.04,
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
                  fontSize: screenWidth*0.04,
                  fontFamily: 'Inter',
                ),),
              ),
            ],
           ),
          
          SizedBox(height:screenHeight * 0.024 ,),
           Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Container(
                  margin: EdgeInsets.only(right: screenWidth * 0.023),
                color: Color(0xffdfe1e6),
                width: screenWidth*0.16,
                height:  screenHeight* 0.001,
               ),
               Text("Or Sign In With" , 
               style: TextStyle(
                fontSize: screenWidth*0.035,
                color: Color(0xffa4abb8),
               ),),
                Container(
                   margin: EdgeInsets.only(left: screenWidth * 0.023),
                color: Color(0xffdfe1e6),
                width: screenWidth*0.16,
                height: screenHeight* 0.001,
               ),

              ],
            ),
          SizedBox(height:screenHeight * 0.021 ,),

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
          width:screenWidth * 0.2,
          height: screenHeight * 0.058,
          child: Center(
            child: Image.asset("assets/images/google.png", width: screenWidth * 0.14, height: screenHeight * 0.063,),
          ),
        ),
      ),
    ),
    SizedBox(width:screenWidth * 0.046,),
              Material(
      color: Color(0xffeceff3),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {},
        child: SizedBox(
          width: screenWidth * 0.2,
          height: screenHeight * 0.058,
          child: Center(
            child: Image.asset("assets/images/apple.png", width: screenWidth * 0.14, height: screenHeight * 0.063,),
          ),
        ),
      ),
    ),  
               
              ],
            ),
          Spacer(),

           Container(
          margin: EdgeInsets.symmetric(
  horizontal: MediaQuery.of(context).size.width * 0.07
),
          child:   RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Color(0xff666d80) , fontSize: screenWidth * 0.04, fontFamily: 'Inter'),
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
           ),

            SizedBox(height: screenHeight*0.047,)

          ]
          )
        )
       )
      ],)
);
    
  }

 void _testfields(BuildContext context) async {
  setState(() {
    _submitted = true;
  });

  if (emailController.text.isEmpty || PasswordController.text.isEmpty) {
    return;
  }

  setState(() => _isLoading = true);

  try {
    final result = await ApiService.login(
      emailController.text,
      PasswordController.text,
    );

    final token = result['access'];
    print('✅ Logged in! Token: $token');

    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login successful! 🎉')),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Wrong email or password')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
}
