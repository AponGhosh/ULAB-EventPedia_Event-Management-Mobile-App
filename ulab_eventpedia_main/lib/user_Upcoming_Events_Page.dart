import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CreateEventsFirestore.dart';
import 'Event_Details_Page.dart';
import 'Event_Registration.dart';


class UserUpcomingEventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
        backgroundColor: Color(0xFFB9E5F8),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFFB9E5F8),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreCreateEvents().getUpcomingEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List<DocumentSnapshot> eventsList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: eventsList.length,
              itemBuilder: (context, index) {
                var eventData = eventsList[index].data() as Map<String, dynamic>;
                eventData['docID'] = eventsList[index].id;
                var title = eventData['title'];
                var imageUrl = eventData['imageUrl'];
                return Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
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
                            imageUrl,
                            width: 310,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // View Details button
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
                            // Register button
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
                                      builder: (context) => RegistrationFormPage(eventData: eventData),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No upcoming events found'));
          }
        },
      ),
    );
  }
}
