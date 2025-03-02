import 'package:flutter/material.dart';

class GroupChatScreen extends StatelessWidget {
  final dynamic sharedContent;

  const GroupChatScreen({super.key, this.sharedContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Chat'),
      ),
      body: sharedContent != null
          ? Column(
        children: [
          // Display shared content (adjust UI as needed)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              sharedContent['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              sharedContent['description'] ?? 'No Description',
            ),
          ),
        ],
      )
          : const Center(
        child: Text('Start a conversation'),
      ),
    );
  }
}
