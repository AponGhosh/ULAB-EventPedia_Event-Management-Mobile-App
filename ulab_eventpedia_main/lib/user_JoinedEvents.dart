import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_Registrations_Provider.dart';
import 'Event_Details_Page.dart';

class UserJoinedEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the user registrations from the provider
    final registrationsProvider = Provider.of<UserRegistrationsProvider>(context);
    final userRegistrations = registrationsProvider.registrations;

    return Scaffold(
      appBar: AppBar(
        title: Text('Joined Events'),
        backgroundColor: Color(0xFFB9E5F8),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFFB9E5F8),
      body: userRegistrations.isNotEmpty
          ? ListView.builder(
        itemCount: userRegistrations.length,
        itemBuilder: (context, index) {
          final registration = userRegistrations[index];
          final eventData = {
            'docID': registration['eventID'],
            'title': registration['eventTitle'],
            'date': registration['eventDate'],
            'imageUrl': registration['eventImage'],
            'location': registration['eventLocation'],
            'fee': registration['eventFee'],
            'description': registration['eventDescription'],
          };

          return Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              padding: EdgeInsets.fromLTRB(25, 15, 25, 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      eventData['imageUrl'],
                      width: 310,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    eventData['title'],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 130,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF53bcd4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetails(eventData: eventData),
                          ),
                        );
                      },
                      child: Text(
                        "View Details",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : Center(child: Text('You have not registered for any events')),
    );
  }
}
