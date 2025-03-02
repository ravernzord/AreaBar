import 'package:flutter/material.dart';

class SOSService {
  Future<void> sendSOSInvite({
    required String contactName,
    required String contactNumber,
    required BuildContext context,
  }) async {
    // Detect the device type and generate the appropriate download link
    String downloadLink = _getDownloadLink();

    // Create the message content
    String message = 'Hey $contactName! I need your help. Join me on Areabaa using this link: $downloadLink';

    // Simulate sending the message (this should be replaced with actual SMS or notification service)
    print('Sending message to $contactNumber: $message');

    // Show confirmation in the app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SOS invite sent to $contactName')),
    );
  }

  String _getDownloadLink() {
    // Placeholder logic to determine the platform
    bool isAndroid = true;  // You can use Platform.isAndroid for real implementation

    return isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.example.areabaa'
        : 'https://apps.apple.com/app/example-id';
  }
}
