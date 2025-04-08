// lib/screens/chat_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/chat_service.dart';
import '../models/message.dart';

class ChatDetailScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;

  ChatDetailScreen({
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mark messages as read when opening the chat
    _chatService.markMessagesAsRead(widget.currentUserId, widget.otherUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              // Show user profile or chat options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatService.getMessages(
                widget.currentUserId,
                widget.otherUserId,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet. Say hello!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == widget.currentUserId;

                    return _buildMessageBubble(message, isMe);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isMe) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) CircleAvatar(radius: 16, child: Icon(Icons.person, size: 16)),
          if (!isMe) SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) SizedBox(width: 8),
          if (isMe) 
            Container(
              width: 16,
              height: 16,
              child: Icon(
                message.isRead ? Icons.done_all : Icons.done,
                size: 16, 
                color: message.isRead ? Colors.blue : Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: () {
              // Implement file attachment
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    
    if (message.isNotEmpty) {
      _chatService.sendMessage(
        widget.currentUserId,
        widget.otherUserId,
        message,
      );
      
      _messageController.clear();
      
      // Scroll to bottom
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }
}