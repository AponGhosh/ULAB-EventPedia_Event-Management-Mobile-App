import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetails extends StatelessWidget {
  final Map<String, dynamic> eventData;

  EventDetails({Key? key, required this.eventData}) : super(key: key);

  Future<void> _openUrl(BuildContext context, String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventData['title']),
        backgroundColor: Color(0xFFB9E5F8),
      ),
      backgroundColor: Color(0xFFB9E5F8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    eventData['imageUrl'],
                    width: 300,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 25, color: Colors.black38),
                  SizedBox(width: 10),
                  Flexible(
                    child: GestureDetector(
                      onTap: () => _openUrl(context, 'https://maps.app.goo.gl/wEuMwYuSLRwqNMRn9'),
                      child: Text(
                        'Location: ${eventData['location']} (Open in Google Maps)',
                        style: TextStyle(fontSize: 20, color: Colors.blue),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 23, color: Colors.black38),
                  SizedBox(width: 10),
                  Text(
                    'Date: ${eventData['date']}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Icon(Icons.attach_money, size: 25, color: Colors.black38),
                  SizedBox(width: 10),
                  Text(
                    'Fee: ${eventData['fee']}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                eventData['description'],
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
