import 'package:flutter/material.dart';

class PrivateChatScreen extends StatefulWidget {
  final dynamic contact; // For phone contacts
  final String? friendId; // For in-app friends
  final dynamic sharedContent; // Optional shared content

  const PrivateChatScreen({
    super.key,
    this.contact,
    this.friendId,
    this.sharedContent,
  });

  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadSharedContent();
  }

  void _loadSharedContent() {
    if (widget.sharedContent != null) {
      _messages.add("Shared Content: ${widget.sharedContent}");
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(_messageController.text);
      _messageController.clear();
    });
  }

  String getChatTitle() {
    if (widget.contact != null) {
      return widget.contact.displayName ?? "Unknown Contact";
    }
    if (widget.friendId != null) {
      return "Friend: ${widget.friendId}";
    }
    return "Private Chat";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getChatTitle()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: "Type a message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
