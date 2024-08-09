import 'package:flutter/material.dart';

import '../Model/Notification_model.dart';

class NotificationPage extends StatelessWidget {
  // Sample data
  final List<NotificationItem> notifications = [
    NotificationItem(
      imageUrl: 'https://via.placeholder.com/50',
      dateTime: '2024-08-06 10:00 AM',
      text: 'Interview scheduled with XYZ Company.',
    ),
    NotificationItem(
      imageUrl: 'https://via.placeholder.com/50',
      dateTime: '2024-08-07 2:00 PM',
      text: 'Hackathon event at ABC Institute.',
    ),
    // Add more notifications as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(notification.imageUrl),
            ),
            title: Text(notification.text),
            subtitle: Text(notification.dateTime),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}
