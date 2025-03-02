import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactSelector extends StatelessWidget {
  final List<Contact> contacts;
  final Function(Contact) onSelect;

  const ContactSelector({
    Key? key,
    required this.contacts,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          title: Text(contact.displayName ?? 'Unknown'),
          subtitle: Text(
            contact.phones?.isNotEmpty == true ? contact.phones!.first.value ?? '' : 'No phone number',
          ),
          trailing: IconButton(
            icon: Icon(Icons.send, color: Colors.black),
            onPressed: () => onSelect(contact),
          ),
        );
      },
    );
  }
}
