// lib/services/user_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user information
  Future<User?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return User.fromFirestore(doc.data()!, doc.id);
    }
    return null;
  }

  // For demo purposes, we'll add some mock users
  Future<void> addMockUsersIfNeeded() async {
    final usersRef = _firestore.collection('users');
    final snapshot = await usersRef.limit(1).get();
    
    if (snapshot.docs.isEmpty) {
      // Add some mock users for testing
      await usersRef.doc('user1').set({
        'name': 'Sarah Smith',
        'email': 'sarah@example.com',
        'major': 'CS Major',
        'year': 'Junior',
      });
      
      await usersRef.doc('user2').set({
        'name': 'John Davis',
        'email': 'john@example.com',
        'major': 'Math Major',
        'year': 'Senior',
      });
      
      await usersRef.doc('user3').set({
        'name': 'Emily Johnson',
        'email': 'emily@example.com',
        'major': 'Physics',
        'year': 'Sophomore',
      });
    }
  }

  // Get all users except current user
  Future<List<User>> getAllUsersExcept(String currentUserId) async {
    final snapshot = await _firestore.collection('users').get();
    
    return snapshot.docs
        .where((doc) => doc.id != currentUserId)
        .map((doc) => User.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}