import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventRegistrationsList extends StatelessWidget {
  final String eventDocID;

  EventRegistrationsList({required this.eventDocID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Registrations List'),
        backgroundColor: Color(0xFFB9E5F8),
      ),
      backgroundColor: Color(0xFFB9E5F8),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(eventDocID)
            .snapshots(),
        builder: (context, eventSnapshot) {
          if (eventSnapshot.hasData && eventSnapshot.data != null) {
            var eventData = eventSnapshot.data!.data() as Map<String, dynamic>;
            var eventImageUrl = eventData['imageUrl'];
            var eventName = eventData['title'];

            return Column(
              children: [
                if (eventImageUrl != null && eventImageUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.network(
                      eventImageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    eventName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventDocID)
                        .collection('registrations')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        List<DocumentSnapshot> registrationsList = snapshot.data!.docs;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Name', style: TextStyle(fontSize: 18))),
                              DataColumn(label: Text('ID', style: TextStyle(fontSize: 18))),
                              DataColumn(label: Text('Email', style: TextStyle(fontSize: 18))),
                              DataColumn(label: Text('Department', style: TextStyle(fontSize: 18))),
                            ],
                            rows: registrationsList.map((document) {
                              var registrationData = document.data() as Map<String, dynamic>;
                              var name = registrationData['name'];
                              var id = registrationData['id'];
                              var email = registrationData['email'];
                              var department = registrationData['department'];

                              return DataRow(
                                cells: [
                                  DataCell(Text(name, style: TextStyle(fontSize: 16))),
                                  DataCell(Text(id, style: TextStyle(fontSize: 16))),
                                  DataCell(Text(email, style: TextStyle(fontSize: 16))),
                                  DataCell(Text(department, style: TextStyle(fontSize: 16))),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      } else {
                        return Center(child: Text('No registrations found'));
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No event data found'));
          }
        },
      ),
    );
  }
}
