import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'private_chat_screen.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key});

  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  List<Map<String, dynamic>> friendList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFriendList();
  }

  Future<void> _fetchFriendList() async {
    // Replace with the current user's ID from authentication
    String currentUserId = 'user_id_placeholder'; // Example: FirebaseAuth.instance.currentUser?.uid ?? '';

    try {
      // Fetch the user's friend list from Firestore
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .get();

      setState(() {
        friendList = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching friend list: $e');
      setState(() => isLoading = false);
    }
  }

  void _startPrivateChat(String friendId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivateChatScreen(friendId: friendId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Friends'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : friendList.isEmpty
          ? const Center(child: Text('No friends added yet.'))
          : ListView.builder(
        itemCount: friendList.length,
        itemBuilder: (context, index) {
          final friend = friendList[index];
          return ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: Text(
              friend['displayName'] ?? 'Unknown',
              style: const TextStyle(color: Colors.black),
            ),
            onTap: () => _startPrivateChat(friend['id']),
          );
        },
      ),
    );
  }
}
