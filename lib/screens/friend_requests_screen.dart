// lib/screens/friend_requests_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/friend_service.dart';

class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  _FriendRequestsScreenState createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _acceptFriendRequest(String requestId, String fromUserId, String currentUserId) async {
    await FriendService().acceptFriendRequest(requestId, fromUserId, currentUserId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request accepted')),
    );
  }

  Future<void> _declineFriendRequest(String requestId) async {
    await _firestore.collection('friend_requests').doc(requestId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request declined')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = 'currentUserId';  // Replace with logic to get the logged-in user's ID

    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('friend_requests')
            .where('toUserId', isEqualTo: currentUserId)
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return Center(child: Text('No pending friend requests.'));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final fromUserId = request['fromUserId'];
              final requestId = request.id;

              return ListTile(
                title: Text('Friend request from $fromUserId'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _acceptFriendRequest(requestId, fromUserId, currentUserId),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _declineFriendRequest(requestId),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
