import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_Registrations_Provider.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final registrations = Provider.of<UserRegistrationsProvider>(context).registrations;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFFB9E5F8),
      ),
      backgroundColor: Color(0xFFB9E5F8),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: registrations.length,
          itemBuilder: (context, index) {
            final registration = registrations[index];
            final eventTitle = registration['eventTitle'] ?? 'Unknown event';
            final eventDate = registration['eventDate'] ?? 'Unknown date';
            final eventImage = registration['eventImage'] ?? '';

            return Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  if (eventImage.isNotEmpty)
                    CircleAvatar(
                      backgroundImage: NetworkImage(eventImage),
                      radius: 35,
                    )
                  else
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 35,
                    ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You have registered for $eventTitle',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Event Date: $eventDate',
                          style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
