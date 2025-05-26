import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCreateEvents {
  final CollectionReference events = FirebaseFirestore.instance.collection('events');

  Stream<QuerySnapshot> getUpcomingEvents() {
    DateTime currentDate = DateTime.now();
    String formattedCurrentDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
    return events
        .where('date', isGreaterThanOrEqualTo: formattedCurrentDate)
        .orderBy('date', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getPreviousEvents() {
    DateTime currentDate = DateTime.now();
    String formattedCurrentDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
    return events
        .where('date', isLessThan: formattedCurrentDate)
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> addEvent(String title, String location, DateTime date, String description, String fee, String imageUrl) {
    String formattedDate = '${date.day}-${date.month}-${date.year}';
    return events.add({
      'title': title,
      'location': location,
      'date': formattedDate,
      'description': description,
      'fee': fee,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> updateEvent(String docID, String? newTitle, String? newLocation, String? newDate, String? newDescription, String? newFee, String? newImageUrl) {
    final title = newTitle ?? "";
    final location = newLocation ?? "";
    final date = newDate ?? "";
    final description = newDescription ?? "";
    final fee = newFee ?? "";
    final imageUrl = newImageUrl ?? "";
    return events.doc(docID).update({
      'title': title,
      'location': location,
      'date': date,
      'description': description,
      'fee': fee,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteEvent(String docID) {
    return events.doc(docID).delete();
  }
}
