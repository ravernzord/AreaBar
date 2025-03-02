import 'package:cloud_firestore/cloud_firestore.dart';

/// Function to get the device type (iOS or Android) for a given phone number
Future<String?> getDeviceType(String phoneNumber) async {
  try {
    // Reference the Firestore collection where user data is stored
    final collection = FirebaseFirestore.instance.collection('users');

    // Query the database to find the user's device type
    final querySnapshot = await collection.where('phoneNumber', isEqualTo: phoneNumber).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assume 'deviceType' is a field in the user's Firestore document
      return querySnapshot.docs.first.data()['deviceType'] as String?;
    } else {
      // Phone number not found
      return null;
    }
  } catch (e) {
    print('Error fetching device type for $phoneNumber: $e');
    return null;
  }
}
