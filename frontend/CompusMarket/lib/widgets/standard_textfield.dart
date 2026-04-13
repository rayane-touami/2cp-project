import 'package:flutter/material.dart';

class StandardTextfield extends StatefulWidget {
  final String title;
  final String hint;
  final bool isPassword;
   final bool isEmail; 
  final TextEditingController ?controller;
  final bool isError;

  const StandardTextfield({
    super.key,
    required this.title,
    required this.hint,
    this.isPassword = false,
      this.isEmail = false, 
    this.controller,
     this.isError = false,

  });

  @override
  _StandardTextfieldState createState() => _StandardTextfieldState();
}

class _StandardTextfieldState extends State<StandardTextfield> {
  bool visibility = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: screenWidth*0.02,
          ),
        ),

        SizedBox(height: screenHeight*0.0074,),
         TextField(
            controller:widget.controller,
            obscureText: widget.isPassword ? visibility : false,
             keyboardType: widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
  autocorrect: widget.isEmail ? false : true,        
  enableSuggestions: widget.isEmail ? false : true, 
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        visibility ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          visibility = !visibility;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth*0.035),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(screenWidth*0.035),
  borderSide: widget.isError
      ? BorderSide(color: Colors.red, width: screenWidth*0.0047,) //  red border when error
      : BorderSide.none,
),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth*0.035),
                borderSide:  widget.isError
      ? BorderSide(color: Colors.red, width: screenWidth*0.0047,) //  stays red even focused
      : BorderSide(color: Colors.blue, width: screenWidth*0.0047,),

              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontFamily: 'Inter',
                color: Color(0xffa4abb8),
                fontWeight: FontWeight.bold,
              ),
              fillColor: Color(0xffeceff3),
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: screenWidth*0.047, horizontal: screenHeight*0.01),
            ),
          ),
        SizedBox(height: screenHeight*0.021,)
      ],
    );
  }
}

