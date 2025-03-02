// lib/widgets/contact_tile.dart
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isRegistered;
  final bool isPhoneContact;
  final VoidCallback? onChatPressed;
  final VoidCallback? onInvitePressed;

  const ContactTile({
    Key? key,
    required this.contact,
    required this.isRegistered,
    required this.isPhoneContact,
    this.onChatPressed,
    this.onInvitePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.person,
        color: isRegistered ? Colors.green : Colors.black,
      ),
      title: Text(
        contact.displayName ?? 'Unknown',
        style: const TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        contact.phones?.isNotEmpty == true ? contact.phones!.first.value ?? '' : 'No phone number',
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.chat, color: Colors.black),
        onPressed: isRegistered ? onChatPressed : null,
      ),
      onTap: isPhoneContact && !isRegistered ? onInvitePressed : null,
    );
  }
}
