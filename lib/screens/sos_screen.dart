import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/firebase_query.dart'; // Import for backend helpers

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  List<Contact> phoneContacts = [];
  List<String> selectedNumbers = [];
  bool isLoading = false;
  String message = "SOS! I need your help. Download the Areabaa app to stay connected:";

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
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission to access contacts was denied.')),
      );
    }
  }

  Future<void> _sendSOS() async {
    String androidLink = "https://play.google.com/store/apps/details?id=com.example.areabaa";
    String iosLink = "https://apps.apple.com/app/id1234567890";

    if (selectedNumbers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No contacts selected.')),
      );
      return;
    }

    for (String phone in selectedNumbers) {
      String? deviceType = await getDeviceType(phone); // Fetch device type from Firebase
      String link = deviceType == 'ios' ? iosLink : androidLink;
      String personalizedMessage = "$message\n$link";

      Uri smsUri = Uri(
        scheme: 'sms',
        path: phone,
        queryParameters: {'body': personalizedMessage},
      );

      try {
        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send SMS to $phone')),
          );
        }
      } catch (e) {
        print('Error sending SMS to $phone: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending SMS to $phone')),
        );
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SOS messages sent to ${selectedNumbers.length} contacts.')),
    );
  }

  Widget _buildContactTile(Contact contact) {
    return ListTile(
      title: Text(contact.displayName ?? 'Unknown'),
      subtitle: Text(
        contact.phones?.isNotEmpty == true ? contact.phones!.first.value ?? '' : 'No phone number',
      ),
      trailing: Checkbox(
        value: selectedNumbers.contains(contact.phones?.first.value),
        onChanged: (bool? selected) {
          setState(() {
            String? phoneNumber = contact.phones?.first.value;
            if (selected == true && phoneNumber != null) {
              selectedNumbers.add(phoneNumber);
            } else if (selected == false && phoneNumber != null) {
              selectedNumbers.remove(phoneNumber);
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send SOS Message'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendSOS,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: phoneContacts.length,
        itemBuilder: (context, index) {
          return _buildContactTile(phoneContacts[index]);
        },
      ),
    );
  }
}
