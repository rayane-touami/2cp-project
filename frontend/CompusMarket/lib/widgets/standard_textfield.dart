import 'package:flutter/material.dart';

class StandardTextfield extends StatefulWidget {
  final String title;
  final String hint;
  final bool isPassword;

  const StandardTextfield({
    super.key,
    required this.title,
    required this.hint,
    this.isPassword = false,
  });

  @override
  _StandardTextfieldState createState() => _StandardTextfieldState();
}

class _StandardTextfieldState extends State<StandardTextfield> {
  bool visibility = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 7, bottom: 20),
          child: TextField(
            obscureText: widget.isPassword ? visibility : false,
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
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.blue, width: 2),
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
                  EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }
}

