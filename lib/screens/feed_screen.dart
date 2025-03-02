import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isLoading = true;
  bool _hasError = false;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _setupFirebaseMessagingListener();
  }

  // Initialize Local Notifications
  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    _notificationsPlugin.initialize(initializationSettings);
  }

  // Firebase Messaging Listener
  void _setupFirebaseMessagingListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received notification: ${message.notification?.title}");
      _showNotification(message.notification?.title, message.notification?.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked: ${message.notification?.title}");
    });
  }

  // Show Notification
  void _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'This channel is used for important notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      title ?? 'New Notification',
      body ?? '',
      platformChannelSpecifics,
    );
  }

  // Build Feed Content from Firestore
  Widget _buildFeed() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('feed') // Ensure your collection is named 'feed'
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorWidget();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final feedItems = snapshot.data?.docs ?? [];

        if (feedItems.isEmpty) {
          return _buildNoContentWidget();
        }

        return RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: ListView.builder(
            itemCount: feedItems.length,
            itemBuilder: (context, index) {
              final data = feedItems[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.article, color: Colors.black54),
                  title: Text(
                    data['title'] ?? 'No Title',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(data['excerpt'] ?? 'No Excerpt'),
                  onTap: () {
                    print("Tapped on: ${data['title']}");
                    // TODO: Open full content or external link
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Error Widget
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 50, color: Colors.red),
          const SizedBox(height: 10),
          const Text('Failed to load feed. Please try again.'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  // No Content Widget
  Widget _buildNoContentWidget() {
    return const Center(
      child: Text('No content available at the moment.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
            tooltip: "Refresh Feed",
          ),
        ],
      ),
      body: _buildFeed(),
    );
  }
}
