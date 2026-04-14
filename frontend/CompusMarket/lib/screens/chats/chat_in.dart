import 'package:flutter/material.dart';

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}


class ChatsInScreen extends StatefulWidget{
  
   final String name;
  final String? image;
  final bool isNetwork;
  final bool isOnline;

const ChatsInScreen({
    required this.name,
    this.image,
    required this.isNetwork,
    required this.isOnline,
  });

  @override
  State<ChatsInScreen> createState() => _ChatsInScreenState();
  }

  class _ChatsInScreenState extends State<ChatsInScreen>{

      List<Message> messages = [
  Message(text: "hey how are u ", isMe: false),
  Message(text: "Hi 👋", isMe: true),
  Message(text: "good nd u ?", isMe: true),
  Message(text: "good too ", isMe: false),
  Message(text: "hey how are u ", isMe: false),
  Message(text: "Hi 👋", isMe: true),
  Message(text: "good nd u ?", isMe: true),
  Message(text: "good too ", isMe: false), Message(text: "hey how are u ", isMe: false),
  Message(text: "Hi 👋", isMe: true),
  Message(text: "good nd u ?", isMe: true),
  Message(text: "good too ", isMe: false), Message(text: "hey how are u ", isMe: false),
  Message(text: "Hi 👋", isMe: true),
  Message(text: "good nd u ?", isMe: true),
  Message(text: "good too ", isMe: false), Message(text: "hey how are u ", isMe: false),
  Message(text: "Hi 👋", isMe: true),
  Message(text: "good nd u ?", isMe: true),
  Message(text: "good too ", isMe: false), Message(text: "hey how are u ", isMe: false),
  Message(text: "Hi 👋", isMe: true),
  Message(text: "good nd u ?", isMe: true),
  Message(text: "good too ", isMe: false),
  Message(text: "thnx for asking ", isMe: true),
  Message(text: "thnx for asking ", isMe: false),
  Message(text: "thnx for asking ", isMe: false),

];

      @override
  Widget build(BuildContext context) {
     final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;


    return 
      Scaffold(
       // extendBody: true,
         backgroundColor: Colors.white,
     appBar: AppBar(
       backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
       bottom: PreferredSize(
    preferredSize: Size.fromHeight(1),
    child: Divider(height: 1, color: Colors.grey[400]), 
  ),
       actions: [
    IconButton(
      icon: Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xff808897), width: 1.5), // ✅
      ),
      child: Icon(Icons.more_horiz, size: screenWidth * 0.065),
    ),
      onPressed: () {},
    ),
  ],
      leading: IconButton(
        onPressed: ()=> Navigator.pop(context),
         iconSize: screenWidth * 0.065,
         icon:  Icon(Icons.arrow_back , color: Colors.black,)),

         title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: widget.image != null
                      ? (widget.isNetwork
                          ? NetworkImage(widget.image!)
                          : AssetImage(widget.image!) )
                      : null,
                  child: widget.image == null
                      ? Icon(Icons.person, size: 22, color: Colors.grey[600])
                      : null,
                ),
                  if (widget.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: screenWidth * 0.028,
                      height: screenWidth * 0.028,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    ),
         ],),
          SizedBox(width: screenWidth * 0.03),
            Text(
              widget.name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045,
              ),
            ),
         ],),
                  

     ),

     


     body:
     ListView.builder(
  padding: EdgeInsets.only(top:50 ,  left: 15 , right: 15 , bottom: 15,),
  itemCount: messages.length,
  itemBuilder: (context, index) {
    final msg = messages[index];

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: msg.isMe ? Color(0xff2853af) : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: msg.isMe ? Radius.circular(15) : Radius.zero,
            bottomRight: msg.isMe ? Radius.zero : Radius.circular(15),
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            fontSize: screenWidth*0.04,
            color: msg.isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  },
),


      bottomNavigationBar: Container(
        color: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal:screenWidth* 0.035, vertical: screenHeight*0.0084),
    margin: EdgeInsets.only(bottom: screenHeight*0.05),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            
            decoration: InputDecoration(
               prefixIcon: IconButton(onPressed: (){},icon:Icon(Icons.add), iconSize: screenWidth*0.06,),
              hintText: "Write a message...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              fillColor: Color(0xffF0F0F0),
              filled: true,
            ),
          ),
        ),
        SizedBox(width: screenWidth*0.04),
        CircleAvatar(
          backgroundColor: Colors.black,
          radius: 25, 
          child: IconButton(
            icon: Icon(Icons.send, color: Colors.white ,),
            onPressed: () {},
          ),
        ),
      ],
    ),
  ),



     );
      
    
  }
  }