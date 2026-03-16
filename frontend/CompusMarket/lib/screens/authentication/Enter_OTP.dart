import 'package:compusmarket/widgets/standard_Button.dart';
import 'package:compusmarket/widgets/standard_Title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:compusmarket/screens/authentication/create_new_password.dart';

class OTPScreen extends StatefulWidget {
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}


class _OTPScreenState extends State<OTPScreen>{
  bool _submitted = false;
  BorderSide _getBorderSide(int index) {
    if (_submitted && controllers[index].text.isEmpty) {
      return BorderSide(color: Colors.red, width: 2);
    }
    return BorderSide.none;
  }
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  TextEditingController c3 = TextEditingController();
  TextEditingController c4 = TextEditingController();

  late List<TextEditingController> controllers;
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  @override
  
void initState(){
  super.initState();
  controllers = [c1,c2,c3,c4];
  Future.delayed(Duration.zero, () {
    _focusNodes[0].requestFocus();
  });
}
@override
void dispose() {
  for (var c in controllers) c.dispose();
  for (var f in _focusNodes) f.dispose(); // ✅ Add this
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            StandardTitle(title: "Enter OTP", pargh: "we have just sent you 4 digit code via your email"),
           Positioned(
              top: 250,
              left: 0,
              right: 0,
            child:   Container(
                margin: EdgeInsets.only(left: 30 , right: 30,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                   children: List.generate(4, (index)=> 
                    Container(
                      margin: EdgeInsets.only(left: 9,right: 9),
                      width: 60,
                      height: 60,
                    child:   TextField(
                       controller: controllers[index],
                       focusNode: _focusNodes[index], // ✅ Add this
  onChanged: (value) {   
    if (_submitted) {
    setState(() {}); 
  }       
    if (value.length == 1) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus(); // jump to next
      } else {
        _focusNodes[index].unfocus(); // close keyboard on last field
      }
    } else if (value.isEmpty) {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus(); // go back on delete
      }
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
                borderSide:BorderSide.none
              ),
              enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25),
    borderSide: _getBorderSide(index),
  ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide:  _submitted && controllers[index].text.isEmpty
        ? BorderSide(color: Colors.red, width: 2)  // ✅ red even if focused and empty
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
                  SizedBox(height: 50,),
                  StandardButton(text: "Continue",onPressed: () {
                    _testOTP(context);
                  },),
                  SizedBox(height: 30,),
                  Row(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Didn't receive code? " , style: TextStyle(
                color: Color(0xff808897),
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Inter',
              ),),

              InkWell(
                 
                onTap: () {} ,
                child: Text(" Resend Code" , style: TextStyle(
                  color: Color(0xff2853af),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  fontFamily: 'Inter',
                ),),
              ),
            ],
           ),
                ],
              ),

            )
           ),
          ],
        ),
      );
     
  }
  void _testOTP (BuildContext context) {
     setState(() {
    _submitted = true; // ✅ Add this
  });
    if(c1.text.isEmpty || c2.text.isEmpty || c3.text.isEmpty || c4.text.isEmpty){
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.isEmpty) {
        _focusNodes[i].requestFocus();
        break;
      }
    }
    return;
  } 
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateNewPasswordScreen()),);

  }

  }