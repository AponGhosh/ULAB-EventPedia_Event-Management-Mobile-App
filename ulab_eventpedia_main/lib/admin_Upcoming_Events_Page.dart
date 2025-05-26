import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CreateEventsFirestore.dart';
import 'EventRegistrationList.dart';
import 'Event_Details_Page.dart';
import 'admin_EditEvent.dart';


class UpcomingEventsPage extends StatelessWidget {
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () async {
                                    final updatedData = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditEvent(eventData: eventData)),
                                    );
                                    if (updatedData != null) {
                                      try {
                                        await FirestoreCreateEvents().updateEvent(
                                          eventData['docID'],
                                          updatedData['title'] ?? eventData['title'],
                                          updatedData['location'] ?? eventData['location'],
                                          updatedData['date'] ?? eventData['date'],
                                          updatedData['description'] ?? eventData['description'],
                                          updatedData['fee'] ?? eventData['fee'],
                                          updatedData['imageUrl'] ?? eventData['imageUrl'],
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Event updated successfully')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to update event: $e')),
                                        );
                                      }
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    bool confirmDelete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Delete'),
                                          content: Text('Are you sure you want to delete this event?'),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () => Navigator.of(context).pop(false),
                                            ),
                                            TextButton(
                                              child: Text('Yes'),
                                              onPressed: () => Navigator.of(context).pop(true),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirmDelete) {
                                      try {
                                        await FirestoreCreateEvents().deleteEvent(eventData['docID']);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Event deleted successfully')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to delete event')),
                                        );
                                      }
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.people, color: Colors.purple),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventRegistrationsList(
                                          eventDocID: eventData['docID'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
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
