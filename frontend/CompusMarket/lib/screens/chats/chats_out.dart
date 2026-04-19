import 'package:compusmarket/services/msg_service.dart';
import 'package:compusmarket/services/auth_services.dart';
import 'package:flutter/material.dart';
import '../chats/chat_in.dart';


class ChatsOutScreen extends StatefulWidget{
  const ChatsOutScreen({super.key});

  @override
  State<ChatsOutScreen> createState() => _ChatsOutScreenState();
  }
  class _ChatsOutScreenState extends State<ChatsOutScreen>{
    List conversations =[];
    bool isLoading = true;
    String? error;

     @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      // ignore: unnecessary_nullable_for_final_variable_declarations
      final data = await MsgService.getConversations(AuthService.accessToken);
      setState(() {
        conversations = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load chats';
        isLoading = false;
      });
    }
  }

   Map<String, dynamic> _getOtherUser(Map<String, dynamic> conv) {
    final buyer = conv['buyer'] ?? {};
    final seller = conv['seller'] ?? {};
    if ((buyer['id'] ?? buyer['email']) == MsgService.currentUserId ||
        buyer['email'] == MsgService.currentUserEmail) {
      return seller;
    }
    return buyer;
  }

   String _getDisplayName(Map<String, dynamic> user) {
    return user['username'] ??
        user['first_name'] ??
        user['email'] ??
        'Unknown';
  }

  
    

  
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
       Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(error!,
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadConversations,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : conversations.isEmpty
                        ? const Center(child: Text('No conversations yet'))
                        : RefreshIndicator(
                            onRefresh: _loadConversations,
                            child: ListView.builder(
                              itemCount: conversations.length,
                              itemBuilder: (context, index) {
                                final conv =
                                    conversations[index] as Map<String, dynamic>;
                                final otherUser = _getOtherUser(conv);
                                final name = _getDisplayName(otherUser);
                                final lastMessage =
                                    conv['last_message'] ?? '';
                                final unread = conv['unread_count'] ?? 0;
                                final conversationId = conv['id'];

                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChatsInScreen(
                                              name: name,
                                              image: null,
                                              isNetwork: false,
                                              isOnline: false,
                                              conversationId: conversationId,
                                            ),
                                          ),
                                        );
                                      },
                                      minVerticalPadding: 20,
                                      leading: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 26,
                                            backgroundColor: Colors.grey[300],
                                            child: Icon(Icons.person,
                                                size: 28,
                                                color: Colors.grey[600]),
                                          ),
                                          // Online dot — optionally fetch per user
                                        ],
                                      ),
                                      title: Text(
                                        name,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        lastMessage,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: screenWidth * 0.03,
                                          color: unread > 0
                                              ? Colors.black
                                              : Colors.grey,
                                          fontWeight: unread > 0
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (unread > 0)
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  unread.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
             Divider(
      height: 1,
      indent: 80, // starts after the avatar
      color: Colors.grey[300],
    ),
    ]
    );
            
          },
          
          )
        ),),

        

     ],
     ),
    );
    
  }
  }