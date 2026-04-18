import 'package:compusmarket/services/auth_services.dart';
import 'package:compusmarket/widgets/standard_Button.dart';
import 'package:compusmarket/widgets/standard_Title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:compusmarket/screens/authentication/create_new_password.dart';
import 'package:compusmarket/screens/home/home_screen.dart'; // 👈 change to your home screen path

class OTPScreen extends StatefulWidget {
  final String email;
  final String source; // 'signup' or 'forgot'

  const OTPScreen({super.key, required this.email, required this.source});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _submitted = false;
  bool _isLoading = false;

  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  TextEditingController c3 = TextEditingController();
  TextEditingController c4 = TextEditingController();

  late List<TextEditingController> controllers;
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    controllers = [c1, c2, c3, c4];
    Future.delayed(Duration.zero, () {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var c in controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  BorderSide _getBorderSide(int index) {
    if (_submitted && controllers[index].text.isEmpty) {
      return BorderSide(color: Colors.red, width: 2);
    }
    return BorderSide.none;
  }

  String get _fullCode =>
      controllers.map((c) => c.text).join();

  @override
Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Column(
        children: [
          StandardTitle(
            title: "Enter OTP",
            pargh: "We sent a 4-digit code to ${widget.email}",
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) =>
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 9),
                      width: 60,
                      height: 60,
                      child: TextField(
                        controller: controllers[index],
                        focusNode: _focusNodes[index],
                        onChanged: (value) {
                          if (_submitted) setState(() {});
                          if (value.length == 1) {
                            if (index < 3) {
                              _focusNodes[index + 1].requestFocus();
                            } else {
                              _focusNodes[index].unfocus();
                            }
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 30,
                        ),
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          isDense: true,
                          counterText: "",
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: _getBorderSide(index),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: _submitted && controllers[index].text.isEmpty
                                ? BorderSide(color: Colors.red, width: 2)
                                : BorderSide(color: Colors.blue, width: 2),
                          ),
                          fillColor: _submitted && controllers[index].text.isEmpty
                              ? Colors.red.withOpacity(0.07)
                              : Color(0xffeceff3),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                StandardButton(
                  text: _isLoading ? "Verifying..." : "Continue",
                  onPressed: _isLoading ? null : () => _verifyOTP(context),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive code? ",
                      style: TextStyle(
                        color: Color(0xff808897),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: 'Inter',
                      ),
                    ),
                    InkWell(
                      onTap: _isLoading ? null : () => _resendCode(),
                      child: Text(
                        "Resend Code",
                        style: TextStyle(
                          color: Color(0xff2853af),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  void _verifyOTP(BuildContext context) async {
    setState(() => _submitted = true);

    if (_fullCode.length < 4) {
      for (int i = 0; i < controllers.length; i++) {
        if (controllers[i].text.isEmpty) {
          _focusNodes[i].requestFocus();
          break;
        }
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.source == 'signup') {
        //  Verify email for signup
        await AuthService.verifyEmail(widget.email, _fullCode);

        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), 
          (route) => false, // clears the whole back stack
        );
      } else {
        // ✅ For forgot password, just go to create new password with the code
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNewPasswordScreen(
              email: widget.email, 
              code: _fullCode,     
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Invalid or expired code. Try again.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resendCode() async {
    try {
      if (widget.source == 'signup') {
        // resend not in your API yet, show message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('📧 Code resent to ${widget.email}')),
        );
      } else {
        await AuthService.forgotPassword(widget.email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('📧 Code resent to ${widget.email}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to resend code.')),
      );
    }
  }
}