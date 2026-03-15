import 'package:compusmarket/widgets/standard_Button.dart';
import 'package:compusmarket/widgets/standard_Title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
void main (){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              fillColor: Color(0xffeceff3),
              filled: true,
                       ),
                    ),
                    ),
                   ),  
                   
                  ),
                  SizedBox(height: 50,),
                  StandardButton(text: "Continue",onPressed: () {},),
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
      ),
    );
  }
}