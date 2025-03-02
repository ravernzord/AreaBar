import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'contact_tile.dart';

class ContactList extends StatefulWidget {
  final bool isPhoneContacts;

  const ContactList({super.key, required this.isPhoneContacts});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> phoneContacts = [];
  List<bool> isSelected = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      setState(() => isLoading = true);
      Iterable<Contact> contacts = await ContactsService.getContacts();
      setState(() {
        phoneContacts = contacts.toList();
        isSelected = List<bool>.filled(phoneContacts.length, false);
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission to access contacts was denied.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: phoneContacts.length,
      itemBuilder: (context, index) {
        final contact = phoneContacts[index];
        return ContactTile(
          contact: contact,
          isSelected: isSelected[index],
          onChanged: (bool? value) {
            setState(() {
              isSelected[index] = value ?? false;
            });
          },
        );
      },
    );
  }
}
