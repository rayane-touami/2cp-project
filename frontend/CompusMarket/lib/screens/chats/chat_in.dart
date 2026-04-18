import 'package:flutter/material.dart';
import '../../services/auth_services.dart'; 
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../services/msg_service.dart';

// class Message {
//   final String text;
//   final bool isMe;

//   Message({required this.text, required this.isMe});
// }


class ChatsInScreen extends StatefulWidget{
  
   final String name;
  final String? image;
  final bool isNetwork;
  final bool isOnline;
   final int conversationId;

const ChatsInScreen({super.key, 
    required this.name,
    this.image,
    required this.isNetwork,
    required this.isOnline,
    required this.conversationId,
  });

  @override
  State<ChatsInScreen> createState() => _ChatsInScreenState();
  }

  class _ChatsInScreenState extends State<ChatsInScreen>{

      List<dynamic> messages = [];
        bool isLoading = true;
         final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  WebSocketChannel? _channel;

     @override
  void initState() {
    super.initState();
    _loadMessages();
    _markAsRead();
    _connectWebSocket();
  }

   @override
  void dispose() {
    _channel?.sink.close();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

   Future<void> _loadMessages() async {
    try {
      final data = await MsgService.getMessages(AuthService.accessToken,widget.conversationId);
      setState(() {
        messages = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

   Future<void> _markAsRead() async {
    try {
      await MsgService.markAsRead(AuthService.accessToken,widget.conversationId);
    } catch (_) {}
  }

   void _connectWebSocket() {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(MsgService.wsUrl(widget.conversationId,AuthService.accessToken)),
      );

      _channel!.stream.listen(
        (data) {
          final newMessage = jsonDecode(data);
          setState(() => messages.add(newMessage));
          _scrollToBottom();
        },
        onError: (e) => debugPrint('WebSocket error: $e'),
        onDone: () => debugPrint('WebSocket closed'),
      );
    } catch (e) {
      debugPrint('WebSocket connection failed: $e');
    }
  }

   void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || _channel == null) return;

    _channel!.sink.add(jsonEncode({'message': text}));
    _controller.clear();
  }

   void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

   bool _isMe(dynamic message) {
    final senderEmail = message['sender']?['email'] ?? '';
    return senderEmail == MsgService.currentUserEmail;
  }

   String _formatTime(String? timestamp) {
    if (timestamp == null) return '';
    final dt = DateTime.tryParse(timestamp)?.toLocal();
    if (dt == null) return '';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }




      @override
  Widget build(BuildContext context) {
     final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;


    return 
      Scaffold(
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
        border: Border.all(color: Color(0xff808897), width: 1.5), 
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
                          : AssetImage(widget.image!) as ImageProvider )
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
     isLoading
          ? const Center(child: CircularProgressIndicator())
          : messages.isEmpty
              ? const Center(
                  child: Text('No messages yet',
                      style: TextStyle(color: Colors.grey)),
                )
              : ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.only(
                      top: 15, left: 15, right: 15, bottom: 15),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    final isMe = _isMe(msg);
                    final time = _formatTime(msg['timestamp']);
                    final isRead = msg['is_read'] ?? false;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isMe
                              ? const Color(0xff2853af)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                            bottomLeft: isMe
                                ? const Radius.circular(15)
                                : Radius.zero,
                            bottomRight: isMe
                                ? Radius.zero
                                : const Radius.circular(15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['content'] ?? '',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: isMe ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.027,
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.grey[600],
                                  ),
                                ),
                                // Checkmarks for sent messages
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    isRead
                                        ? Icons.done_all
                                        : Icons.done,
                                    size: screenWidth * 0.035,
                                    color: isRead
                                        ? Colors.lightBlueAccent
                                        : Colors.white70,
                                  ),
                                ],
                              ],
                            ),
                          ],
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
            controller: _controller,
            onSubmitted: (_) => _sendMessage(),
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
            onPressed: _sendMessage,
          ),
        ),
      ],
    ),
  ),



     );
      
    
  }
  }