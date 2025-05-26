import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'CreateEventsFirestore.dart';
import 'admin_Upcoming_Events_Page.dart';

class CreateEventsPage extends StatefulWidget {
  @override
  State<CreateEventsPage> createState() => _CreateEventsPageState();
}

class _CreateEventsPageState extends State<CreateEventsPage> {
  final FirestoreCreateEvents firestoreCreateEvents = FirestoreCreateEvents();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  DateTime eventDate = DateTime.now();
  File? _image;

  Future<void> _eventDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: eventDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != eventDate) {
      setState(() {
        eventDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _ClearRecords() async {
    if (_image == null ||
        titleController.text.isEmpty ||
        locationController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        feeController.text.isEmpty) {
      return;
    }

    try {
      Reference storageReference =
      FirebaseStorage.instance.ref().child('events/${DateTime.now().toString()}');
      UploadTask uploadTask = storageReference.putFile(_image!);
      await uploadTask.whenComplete(() => null);
      String imageUrl = await storageReference.getDownloadURL();

      String eventTitle = titleController.text;
      String eventLocation = locationController.text;
      String eventDescription = descriptionController.text;
      String eventFee = feeController.text;

      await firestoreCreateEvents.addEvent(
        eventTitle,
        eventLocation,
        eventDate,
        eventDescription,
        eventFee,
        imageUrl,
      );

      titleController.clear();
      locationController.clear();
      setState(() {
        eventDate = DateTime.now();
        _image = null;
      });
      descriptionController.clear();
      feeController.clear();
    } catch (e) {
      print('Failed to create event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFB9E5F8),
        appBar: AppBar(
          title: Text('Create Events'),
          backgroundColor: Color(0xFFB9E5F8),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Event Title',
                      fillColor: Color(0xFFdcf6fc),
                      filled: true,
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Event Location',
                      fillColor: Color(0xFFdcf6fc),
                      filled: true,
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    readOnly: true,
                    onTap: () => _eventDate(context),
                    decoration: InputDecoration(
                      labelText: 'Select Date: ${_formatDate(eventDate)}',
                      fillColor: Color(0xFFdcf6fc),
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: TextField(
                    controller: feeController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      fillColor: Color(0xFFdcf6fc),
                      filled: true,
                      prefixIcon: Icon(Icons.attach_money),
                      contentPadding: EdgeInsets.only(left: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: TextField(
                    controller: descriptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Event Description',
                      fillColor: Color(0xFFdcf6fc),
                      filled: true,
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 100,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: _getImage,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Color(0xFFdcf6fc),
                    ),
                    child: Text(
                      'Upload Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff274560),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _image != null
                    ? Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: Container(
                    width: 170,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFF78D2E6),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: _ClearRecords,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Text(
                        "Create Event",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff274560),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
