import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'online_indicator.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const ContactTile({
    super.key,
    required this.contact,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOnline = true; // Replace with real online status logic

    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            child: Text(
              contact.initials(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          if (isOnline) const OnlineIndicator(),
        ],
      ),
      title: Text(contact.displayName ?? 'Unknown'),
      subtitle: Text(
        contact.phones?.isNotEmpty == true ? contact.phones!.first.value ?? '' : 'No phone number',
      ),
      trailing: Checkbox(
        value: isSelected,
        onChanged: onChanged,
      ),
    );
  }
}
