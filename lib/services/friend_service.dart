// lib/services/friend_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a friend request
  Future<void> sendFriendRequest(String fromUserId, String toUserId) async {
    await _firestore.collection('friend_requests').add({
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Accept a friend request
  Future<void> acceptFriendRequest(String requestId, String fromUserId, String toUserId) async {
    // Update request status
    await _firestore.collection('friend_requests').doc(requestId).update({
      'status': 'accepted',
    });

    // Add users to each other's friend lists
    await _firestore.collection('user_profiles').doc(fromUserId).update({
      'friendIds': FieldValue.arrayUnion([toUserId]),
    });

    await _firestore.collection('user_profiles').doc(toUserId).update({
      'friendIds': FieldValue.arrayUnion([fromUserId]),
    });
  }
}
