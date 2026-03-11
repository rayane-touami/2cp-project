import 'package:flutter/material.dart';
import '../../../widgets/standard_container.dart';
void main() {
 runApp( MyApp());// it should be the widjet name in capital for first letter

}

class MyApp extends StatefulWidget{
  @override
  State<MyApp> createState() => _MyAppState();
  }


class _MyAppState extends State<MyApp>{
  bool Status=false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp( // it had to be material bcs it will manage the first page
    home: Scaffold(
      body:Stack(children: [
        StandardContainer(title: "Let's Sign You In " , pargh: "Lorem ipsum dolor sit amet , consectetur",),
       Positioned(
        top: 270,
        left: 0,
        right: 0,
        child: 
        Container(
          height: 500,
          //color: Colors.red,
          margin: EdgeInsets.only(left: 30 , right: 30,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Text("Email Adress" , style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold , 
            fontSize: 18,
          ),),
          Container(
            margin: EdgeInsets.only(top: 7 , bottom: 20),
            child: TextField(
              decoration:InputDecoration(
                border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
focusedBorder: OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: Colors.blue , width: 2 , ),
),

                hintText: "Enter your email adress ",
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xffa4abb8),
                  fontWeight: FontWeight.bold,
                ),
                fillColor: Color(0xffeceff3),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10)
              ) ,
            ),
          ) , 
           Text("Password" , style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold , 
            fontSize: 18,
          ),),
          Container(
            margin: EdgeInsets.only(top: 7 , bottom: 10),
            child: TextField(
              obscureText: true,
              textAlignVertical: TextAlignVertical.center, 
              decoration:InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: (){
                      
                    },
                   icon:Icon(Icons.visibility_off),
                   ),
                border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                 focusedBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(15),
                 borderSide: BorderSide(color: Colors.blue , width: 2 , ),
                 ),

                hintText: "Enter your password",
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xffa4abb8),
                  fontWeight: FontWeight.bold,
                ),
                fillColor: Color(0xffeceff3),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 10)
              ) ,
            ),
          ),

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

                InkWell(
                  onTap: () {} ,
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

          MaterialButton(
            onPressed: (){},
            color: Color(0xff2853af),
            textColor: Colors.white,
            minWidth: double.infinity,
            height: 60,
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(15)
            ) ,
            child: Text("Sign In", style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
            ),),

          
          ),

          Container(
            margin: EdgeInsets.only(top: 30 , bottom: 20),
            
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
                 
                onTap: () {} ,
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

          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right:5, ),
                  width: 100,
                  height: 100,
                ),
                Container(),

              ],
            ),
          )

 

          
          ]
          )
        )
       )
      ],)
)
    );
  }

}
