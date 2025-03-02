import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to add data to Firestore
  Future<void> addFeedItem(Map<String, dynamic> feedData) async {
    try {
      await _firestore.collection('feed').add(feedData);
      print('Data successfully added to Firestore!');
    } catch (e) {
      print('Error adding data: $e');
    }
  }

  // Function to get data from Firestore
  Stream<QuerySnapshot> getFeedItems() {
    return _firestore.collection('feed').snapshots();
  }
}
