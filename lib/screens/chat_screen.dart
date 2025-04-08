// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/chat_service.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final UserService _userService = UserService();
  
  // For demo purposes, we'll use a current user ID
  final String currentUserId = 'user1';
  
  @override
  void initState() {
    super.initState();
    _userService.addMockUsersIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showNewChatDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search chats",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getChatList(currentUserId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No chats yet. Start a conversation!'));
                }

                return ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    final chatData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    final otherUserId = chatData['userId'];
                    final lastMessage = chatData['lastMessage'] ?? '';
                    final timestamp = chatData['timestamp']?.toDate() ?? DateTime.now();
                    final unreadCount = chatData['unreadCount'] ?? 0;

                    return FutureBuilder<User?>(
                      future: _userService.getUser(otherUserId),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return ListTile(
                            leading: CircleAvatar(child: Icon(Icons.person)),
                            title: Text('Loading...'),
                          );
                        }

                        final user = userSnapshot.data!;

                        return ListTile(
                          leading: CircleAvatar(
                            child: user.photoUrl != null
                                ? Image.network(user.photoUrl!)
                                : Icon(Icons.person),
                          ),
                          title: Text(
                            user.name,
                            style: TextStyle(
                              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat('h:mm a').format(timestamp),
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              SizedBox(height: 4),
                              if (unreadCount > 0)
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    unreadCount.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailScreen(
                                  currentUserId: currentUserId,
                                  otherUserId: otherUserId,
                                  otherUserName: user.name,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showNewChatDialog(BuildContext context) async {
    final users = await _userService.getAllUsersExcept(currentUserId);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Start a new chat'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user.name),
                  subtitle: Text('${user.major ?? ''} ${user.year ?? ''}'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatDetailScreen(
                          currentUserId: currentUserId,
                          otherUserId: user.id,
                          otherUserName: user.name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}