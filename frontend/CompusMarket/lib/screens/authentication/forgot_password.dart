import 'package:compusmarket/services/auth_services.dart';
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
     bool _isLoading = false;
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
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    backgroundColor: Colors.white,
    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StandardTitle(
            title: "Forgot Password",
            pargh: "Recover your account password",
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StandardTextfield(
                  title: "E-mail",
                  hint: "Enter your email",
                  isEmail: true,
                  controller: emailController,
                  isError: _submitted && emailController.text.isEmpty,
                ),
                SizedBox(height: 30),
                StandardButton(
                  text: _isLoading ? "Sending..." : "Next",
                  onPressed: _isLoading ? null : () => _test(context),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  void _test(BuildContext context) async {
  setState(() => _submitted = true);

  if (emailController.text.isEmpty) return;

  setState(() => _isLoading = true);

  try {
    await AuthService.forgotPassword(emailController.text);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPScreen(
          email: emailController.text, 
          source: 'forgot',            
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ Email not found. Try again.')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
  }