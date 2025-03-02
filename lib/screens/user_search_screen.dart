// lib/screens/user_search_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/friend_service.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FriendService _friendService = FriendService();
  List<DocumentSnapshot> _searchResults = [];

  Future<void> _searchUsers(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('displayName', isGreaterThanOrEqualTo: query)
        .get();

    setState(() {
      _searchResults = snapshot.docs;
    });
  }

  void _sendRequest(String toUserId) async {
    final currentUserId = 'currentUserId'; // Replace with actual current user ID logic
    await _friendService.sendFriendRequest(currentUserId, toUserId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Friend request sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Enter a name to search',
                suffixIcon: Icon(Icons.search),
              ),
              onSubmitted: (query) => _searchUsers(query),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                final displayName = user['displayName'];
                final userId = user.id;

                return ListTile(
                  title: Text(displayName),
                  trailing: IconButton(
                    icon: Icon(Icons.person_add, color: Colors.green),
                    onPressed: () => _sendRequest(userId),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
