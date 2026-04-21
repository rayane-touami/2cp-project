import 'package:flutter/material.dart';
import '../../widgets/standard_Title.dart';
import '../../widgets/standard_textfield.dart';
import '../../widgets/standard_Button.dart';
import 'package:compusmarket/screens/authentication/Enter_OTP.dart';
import 'package:compusmarket/services/auth_services.dart';


class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
  }
  class _SignUpScreenState extends State<SignUpScreen>{
    TextEditingController emailController = TextEditingController(); 
    TextEditingController numberController = TextEditingController();  
    TextEditingController nameController = TextEditingController(); 
    TextEditingController PasswordController = TextEditingController();
     bool _submitted = false;
     bool _isLoading = false;
List<dynamic> _universities = [];
String? _selectedUniversityId;
     @override
  void initState() {
    super.initState();
    _loadUniversities();
   
    emailController.addListener(() {
      setState(() {});
    });
    numberController.addListener(() {
      setState(() {});
    });
    nameController.addListener(() {
      setState(() {});
    });
    PasswordController.addListener(() {
      setState(() {});
    });
  }

Future<void> _loadUniversities() async {
  try {
    final unis = await AuthService.getUniversities();
    print('✅ Universities loaded: ${unis.length}');
    setState(() => _universities = unis);
  } catch (e) {
    print('❌ Error loading universities: $e');
  }
}

  @override
  void dispose() {
    emailController.dispose(); 
    numberController.dispose(); 
    nameController.dispose(); 
    PasswordController.dispose(); 
    super.dispose();
  } 
    @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
  return Scaffold(
      backgroundColor: Colors.white,
    body: SingleChildScrollView(
   child:  Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       StandardTitle(title: "Create Account" , pargh: "Lorem ipsum dolor sit amet , consectetur",), 
       Padding( 
         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
          child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start, 
           children: [
            StandardTextfield(title:"Full Name", hint:"Enter your name",controller: nameController,isError: _submitted && nameController.text.isEmpty,),
            StandardTextfield(title:"E-mail", hint:"Enter your email",isEmail: true,controller: emailController,isError: _submitted && emailController.text.isEmpty,),
            StandardTextfield(title:"Phone Number", hint:"Enter your phone number",isPhone: true,controller: numberController,isError: _submitted && numberController.text.isEmpty,),
            StandardTextfield(title:"Password", hint:"Enter your Password",isPassword: true,controller: PasswordController,isError: _submitted && PasswordController.text.isEmpty,),
         Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      "University",
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        fontSize: screenWidth * 0.037, // same as textfields
      ),
    ),
    SizedBox(height: screenHeight * 0.0074), // same spacing as textfields
    Container(
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xffeceff3),
        borderRadius: BorderRadius.circular(screenWidth * 0.035),
        border: Border.all(
          color: (_submitted && _selectedUniversityId == null)
              ? Colors.red
              : Colors.transparent,
          width: screenWidth * 0.0047,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.01),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            "Select your university",
            style: TextStyle(
              fontFamily: 'Inter',
              color: Color(0xffa4abb8),
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
            ),
          ),
          value: _selectedUniversityId,
          icon: Icon(Icons.keyboard_arrow_down),
          dropdownColor: Colors.white,
          items: _universities.map((uni) {
            return DropdownMenuItem<String>(
              value: uni['id'].toString(),
              child: Text(uni['name'].toString()),
            );
          }).toList(),
          onChanged: (val) {
            setState(() => _selectedUniversityId = val);
          },
        ),
      ),
    ),
    SizedBox(height: screenHeight * 0.021), // same bottom spacing as textfields
  ],
),
            SizedBox(height:screenHeight * 0.01,),
            StandardButton(
              text: _isLoading ? "Creating..." : "Create An Account",
  onPressed: _isLoading ? null : () => _testemail(context),
            ),
            SizedBox(height: screenHeight * 0.026,),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Container(
                  margin: EdgeInsets.only(right:  screenWidth * 0.023),
                color: Color(0xffdfe1e6),
                width: screenWidth * 0.16,
                height:screenHeight * 0.001,
               ),
               Text("Or Sign In with" , 
               style: TextStyle(
                fontSize:  screenWidth * 0.035,
                color: Color(0xffa4abb8),
               ),),
                Container(
                   margin: EdgeInsets.only(left: screenWidth * 0.023),
                color: Color(0xffdfe1e6),
                width: screenWidth * 0.16,
                height: screenHeight * 0.001,
               ),

              ],
            ),
            
          

SizedBox(height: screenHeight * 0.021,),

          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
      color: Color(0xffeceff3),
      borderRadius: BorderRadius.circular(screenWidth * 0.025),
      child: InkWell(
        borderRadius: BorderRadius.circular(screenWidth * 0.025),
        onTap: () {},
        child: SizedBox(
          width: screenWidth * 0.2,
          height: screenHeight * 0.058,
          child: Center(
            child: Image.asset("assets/images/google.png", width: screenWidth * 0.14, height: screenHeight * 0.063),
          ),
        ),
      ),
    ),
    SizedBox(width: screenWidth * 0.035),
              Material(
      color: Color(0xffeceff3),
      borderRadius: BorderRadius.circular(screenWidth * 0.025),
      child: InkWell(
        borderRadius: BorderRadius.circular(screenWidth * 0.025),
        onTap: () {},
        child: SizedBox(
          width: screenWidth * 0.2,
          height:  screenHeight * 0.058,
          child: Center(
            child: Image.asset("assets/images/apple.png",  width: screenWidth * 0.14, height: screenHeight * 0.063),
          ),
        ),
      ),
    ),  
               
              ],
            ),
          SizedBox(height: 40),

            RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Color(0xff666d80) ,  fontSize: screenWidth * 0.04, fontFamily: 'Inter'),
              children: [
                TextSpan(text: "By signing up you agree to our "),
                TextSpan(
                  text: "Terms ", style: TextStyle(color: Colors.black),
                ),
                TextSpan(text: "and "),
                TextSpan(text: "Conditions of Use" , style: TextStyle(color: Colors.black))
              ]
            )
           
           ),
           SizedBox(height: screenHeight * 0.047),


           ],),),],), 
      
    ),
  );
  }

  void _testemail (BuildContext context)async{
   setState(() => _submitted = true);

  if (nameController.text.isEmpty || emailController.text.isEmpty ||
      PasswordController.text.isEmpty || 
      _selectedUniversityId == null) {
    return;
  }

  setState(() => _isLoading = true);

  try {
    await AuthService.register(
      emailController.text,
      PasswordController.text,
      nameController.text,
      _selectedUniversityId!,
        numberController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account created! 🎉')),
    );

   Navigator.push(
  // ignore: use_build_context_synchronously
  context,
  MaterialPageRoute(
    builder: (context) => OTPScreen(
      email: emailController.text,
      source: 'signup',
    ),
  ),
);

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Registration failed. Try again.')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
  
  }

  }
  