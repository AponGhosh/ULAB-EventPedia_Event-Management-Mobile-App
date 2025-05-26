import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'CreateEventsFirestore.dart';

class EditEvent extends StatefulWidget {
  final Map<String, dynamic> eventData;

  EditEvent({Key? key, required this.eventData}) : super(key: key);

  @override
  _EditEventState createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  DateTime? _selectedDate;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.eventData['title'] ?? '';
    _locationController.text = widget.eventData['location'] ?? '';
    _descriptionController.text = widget.eventData['description'] ?? '';
    _feeController.text = widget.eventData['fee'] ?? '';
    _selectedDate = DateTime.tryParse(widget.eventData['date'] ?? '');
    _imageUrl = widget.eventData['imageUrl'];
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String imageUrl = await uploadImage(image.path);
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  Future<String> uploadImage(String path) async {
    File file = File(path);
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      TaskSnapshot uploadTask = await storage.ref('event_images/${DateTime.now().toIso8601String()}').putFile(file);
      String downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> _saveEvent() async {
    Map<String, dynamic> updatedData = {
      'title': _titleController.text,
      'location': _locationController.text,
      'date': _selectedDate?.toIso8601String(),
      'description': _descriptionController.text,
      'fee': _feeController.text,
      'imageUrl': _imageUrl,
    };

    try {
      await FirestoreCreateEvents().updateEvent(
        widget.eventData['docID'],
        updatedData['title'] as String?,
        updatedData['location'] as String?,
        updatedData['date'] as String?,
        updatedData['description'] as String?,
        updatedData['fee'] as String?,
        updatedData['imageUrl'] as String?,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event updated successfully')),
      );

      Navigator.pop(context, updatedData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
        backgroundColor: Color(0xFFB9E5F8),
      ),
      backgroundColor: Color(0xFFB9E5F8),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(labelText: 'Location'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextField(
            controller: _feeController,
            decoration: InputDecoration(labelText: 'Fee'),
          ),
          ListTile(
            title: Text(
                _selectedDate != null ? 'Event Date: ${_selectedDate!.toLocal().toIso8601String()}' : 'Event Date'
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: _pickDate,
          ),
          SizedBox(height: 10),
          if (_imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                _imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            )
          else
            Text('No image selected'),
          SizedBox(height: 10),
          SizedBox(
            width: 50,
            height: 50,
            child: TextButton(
              onPressed: _pickImage,
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF53bcd4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Change Image',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
          Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF53bcd4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton(
              onPressed: _saveEvent,
              child: Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
