// models/user_profile_model.dart
class UserProfile {
  final String userId;
  final String displayName;
  final String email;
  final String? profilePictureUrl;
  final List<String> friendIds; // List of user IDs representing friends

  UserProfile({
    required this.userId,
    required this.displayName,
    required this.email,
    this.profilePictureUrl,
    required this.friendIds,
  });

  // Factory method to create a UserProfile from a Firestore document
  factory UserProfile.fromMap(Map<String, dynamic> data, String documentId) {
    return UserProfile(
      userId: documentId,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      profilePictureUrl: data['profilePictureUrl'],
      friendIds: List<String>.from(data['friendIds'] ?? []),
    );
  }

  // Convert UserProfile to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'friendIds': friendIds,
    };
  }
}
