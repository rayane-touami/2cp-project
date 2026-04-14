import 'package:flutter/material.dart';
import '../chats/chat_in.dart';

void main() {
  runApp(MaterialApp(
    home: ChatsOutScreen(), 
  ));
}

class ChatsOutScreen extends StatefulWidget{
  @override
  State<ChatsOutScreen> createState() => _ChatsOutScreenState();
  }
  class _ChatsOutScreenState extends State<ChatsOutScreen>{
    List<Map<String, dynamic>> conversations =[
      {
        "name":"Rayane Touami",
        "lastMessage":"hey how are you?",
        "time":"10:30",
         "image": null,
         "isOnline": true,
         "unread": 3,
       
      },
       {
        "name":"Nour",
        "lastMessage":"okay thnx",
        "time":"09:43",
         "image": "assets/images/Nour's_pic.jpg",
         "isNetwork": false,
          "isOnline": true,
          "unread": 0,
         
      },
       {
        "name":"Ritadj",
        "lastMessage":"how much",
        "time":"13:11",
         "image": null,
          "isOnline": false,
          "unread": 0,
        
      },
       {
        "name":"Amina",
        "lastMessage":"how can i help u",
        "time":"Mon",
        "image": "assets/images/amina's_pic.jpg",
        "isNetwork": false,
         "isOnline": false,
         "unread": 0,
      },
      {
        "name":"Malak",
        "lastMessage":"your welcome",
        "time":"Sat",
        "image": "assets/images/malak's_pic.jpg",
        "isNetwork": false,
         "isOnline": false,
         "unread": 0,
      },
      {
        "name":"Houssam",
        "lastMessage":"how can i help u",
        "time":"Mon",
        "image": "assets/images/houssam's_pic.jpg",
        "isNetwork": false,
         "isOnline": true,
         "unread": 0,
      },
      {
        "name":"Djiha_ne",
        "lastMessage":"how can i help u",
        "time":"Mon",
        "image": null,
         "isOnline": true,
         "unread": 0,
        
      },
      {
        "name":"Man_el",
        "lastMessage":"how can i help u",
        "time":"Mon",
        "image": null,
         "isOnline": false,
         "unread": 0,
       
      },
      {
        "name":"Wail",
        "lastMessage":"how can i help u",
        "time":"Mon",
        "image": "assets/images/wail's_pic.jpg",
        "isNetwork": false,
         "isOnline": false,
         "unread": 0,
      },
      {
        "name":"Islam",
        "lastMessage":"how can i help u",
        "time":"Mon",
        "image": null,
         "isOnline": false,
         "unread": 0,
       
      },
      {
        "name":"Kh.aled",
        "lastMessage":"how can i help u",
        "time":"Mon",
        "image": null,
        "isOnline": false,
        "unread": 0,
       
      },
      {
        "name":"AHMAD",
        "lastMessage":"how can i help u",
        "time":"Mon",
         "image": null,
         "isOnline": false,
        "unread": 0,
      },
      {
        "name":"Hadjer",
        "lastMessage":"how can i help u",
        "time":"Mon",
         "image": null,
         "isOnline": false,
         "unread": 0,
        
      },
      
    ];
    @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
       backgroundColor: Colors.white,
     appBar: AppBar(
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
      centerTitle: true,
      title: Text("Chats" ,style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: screenWidth*0.07,
        fontFamily: 'Inter',
      ),),
      actions: [
    IconButton(
      icon: Icon(Icons.menu, size: screenWidth*0.065, ),  // or Icons.add, Icons.more_vert
      onPressed: () {},
    ),
  ],
     ),
     body:
      Column(
      
      children: [
      //  SizedBox(height: screenHeight*0.7,),
       Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight*0.02,horizontal: screenWidth*0.03),
       height:screenHeight * 0.065 ,
        child:  TextField(
expands: true, 
 maxLines: null,  
          decoration: InputDecoration(
             border:OutlineInputBorder(
               borderRadius: BorderRadius.circular(screenWidth * 0.08), 
               borderSide: BorderSide.none,
             ),
            hintText: "Search",
            hintStyle: TextStyle(fontSize:screenWidth * 0.045 ,  color: Colors.grey,),

             prefixIcon: Icon(Icons.search, color: Colors.grey, size: screenWidth * 0.06,),
               
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: 0),
                  fillColor: Color(0xffF0F0F0),
                 

                  filled: true,
                  isDense: true,
          ),
          
        )
,
       ),
      // Divider(height: 1, color: Colors.grey[400]),
        Expanded(
          child: ListView.builder( 
          
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
            ListTile(
              onTap: () {
                 Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatsInScreen(
                              name: conversations[index]["name"],
                              image: conversations[index]["image"],
                              isNetwork: conversations[index]["isNetwork"] ?? false,
                              isOnline: conversations[index]["isOnline"] ?? false,
                            ),
                          ),
                        );
              },
               minVerticalPadding: 20,
          leading:Stack(children: [
             CircleAvatar(
  radius: 26,
  backgroundColor: Colors.grey[300],
  backgroundImage: conversations[index]["image"] != null
      ? ((conversations[index]["isNetwork"] ?? false)
          ? NetworkImage(conversations[index]["image"])
          : AssetImage(conversations[index]["image"]) as ImageProvider)
      : null,
  child: conversations[index]["image"] == null
      ? Icon(Icons.person, size: 28, color: Colors.grey[600])
      : null,
),



             if (conversations[index]["isOnline"] == true)
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: screenWidth*0.035,
          height: screenHeight*0.016,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),),)]),
     


       // child: Icon(Icons.person ,  size: 28) ) ,
        title: Text(conversations[index]["name"],
         style :TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
          )),
      subtitle: Text(conversations[index]["lastMessage"],
       maxLines: 1,
  overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: screenWidth*0.03,
        color: (conversations[index]["unread"] ?? 0) > 0 ? Colors.black : Colors.grey,
    fontWeight: (conversations[index]["unread"] ?? 0) > 0 ? FontWeight.w600 : FontWeight.normal, 
      ),
      ),
      trailing: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(conversations[index]["time"],
        style: TextStyle(fontSize: screenWidth * 0.028, color: Color(0xff808897)),
      ),
      if ((conversations[index]["unread"]?? 0)> 0)
        Container(
          margin: EdgeInsets.only(top: 5),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              conversations[index]["unread"].toString(),
              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
            ),]),),
             Divider(
      height: 1,
      indent: 80, // starts after the avatar
      color: Colors.grey[300],
    ),
    ]
    );
            
          },
          
          )
        ),

        

     ],
     ),
    );
    
  }
  }