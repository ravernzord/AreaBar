import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/contact_tile.dart';
import 'friend_list_screen.dart'; // Import the friend list screen
import 'private_chat_screen.dart'; // Import the private chat screen

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Contact> phoneContacts = [];
  List<String> registeredContacts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      setState(() => isLoading = true);
      Iterable<Contact> contacts = await ContactsService.getContacts();
      await _fetchRegisteredContacts();
      setState(() {
        phoneContacts = contacts.toList();
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission to access contacts was denied.')),
      );
    }
  }

  Future<void> _fetchRegisteredContacts() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      registeredContacts = snapshot.docs.map((doc) => doc['phoneNumber'] as String).toList();
    });
  }

  bool _isContactRegistered(String? phoneNumber) {
    return registeredContacts.contains(phoneNumber);
  }

  void _startPrivateChat(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivateChatScreen(contact: contact),
      ),
    );
  }

  void _navigateToFriendList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FriendListScreen(), // Navigate to FriendListScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.phone, color: Colors.black), text: 'Phone Contacts'),
            Tab(icon: Icon(Icons.group, color: Colors.black), text: 'App Contacts'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          // Phone Contacts Tab
          ListView.builder(
            itemCount: phoneContacts.length,
            itemBuilder: (context, index) {
              final contact = phoneContacts[index];
              final isRegistered = _isContactRegistered(contact.phones?.first.value);

              return ContactTile(
                contact: contact,
                isRegistered: isRegistered,
                isPhoneContact: true,
                onChatPressed: () => _startPrivateChat(contact),
                onInvitePressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invite sent to ${contact.displayName ?? 'Unknown'}')),
                  );
                },
              );
            },
          ),
          // App Contacts Tab with Navigation Logic
          Center(
            child: ElevatedButton(
              onPressed: _navigateToFriendList,
              child: const Text('View Friend List'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
