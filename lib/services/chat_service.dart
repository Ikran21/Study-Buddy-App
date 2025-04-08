// lib/services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get chat ID for two users
  String getChatId(String userId1, String userId2) {
    // Ensure consistent chat ID regardless of who initiates
    List<String> ids = [userId1, userId2];
    ids.sort(); // Sort to ensure consistency
    return '${ids[0]}_${ids[1]}';
  }

  // Send a message
  Future<void> sendMessage(String senderId, String receiverId, String content) async {
    final chatId = getChatId(senderId, receiverId);
    final timestamp = DateTime.now();
    
    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
      'isRead': false,
    });

    // Update the last message for both users
    await _updateChatMetadata(chatId, senderId, receiverId, content, timestamp);
  }

  // Update chat metadata for both users
  Future<void> _updateChatMetadata(
    String chatId, String senderId, String receiverId, String lastMessage, DateTime timestamp) async {
    
    // Update sender's chat list
    await _firestore.collection('users').doc(senderId).collection('chats').doc(receiverId).set({
      'chatId': chatId,
      'userId': receiverId,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
      'unreadCount': 0,
    }, SetOptions(merge: true));
    
    // Update receiver's chat list with unread count increment
    final receiverChatRef = _firestore.collection('users').doc(receiverId).collection('chats').doc(senderId);
    final receiverChatDoc = await receiverChatRef.get();
    
    int unreadCount = 0;
    if (receiverChatDoc.exists) {
      unreadCount = (receiverChatDoc.data()?['unreadCount'] ?? 0) + 1;
    } else {
      unreadCount = 1;
    }
    
    await receiverChatRef.set({
      'chatId': chatId,
      'userId': senderId,
      'lastMessage': lastMessage,
      'timestamp': timestamp,
      'unreadCount': unreadCount,
    }, SetOptions(merge: true));
  }

  // Get messages for a chat
  Stream<List<Message>> getMessages(String userId1, String userId2) {
    final chatId = getChatId(userId1, userId2);
    
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String currentUserId, String otherUserId) async {
    final chatId = getChatId(currentUserId, otherUserId);
    
    // Get unread messages
    final unreadMessages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();
    
    // Mark each message as read
    final batch = _firestore.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
    
    // Reset unread count in the chat metadata
    await _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(otherUserId)
        .update({'unreadCount': 0});
  }

  // Get user's chat list
  Stream<QuerySnapshot> getChatList(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}