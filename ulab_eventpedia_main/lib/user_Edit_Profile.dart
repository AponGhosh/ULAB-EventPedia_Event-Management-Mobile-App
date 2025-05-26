import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:ulab_eventpedia_main/userLoginScreen.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String? _imageUrl;

  Future<void> _fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('general_users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        _nameController.text = userData['name'] ?? '';
        _idController.text = userData['id'] ?? '';
        _departmentController.text = userData['department'] ?? '';
        _contactController.text = userData['contact'] ?? '';
        _imageUrl = userData['imageUrl'];
      }
    }
  }

  Future<void> _updateUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('general_users').doc(user.uid).update({
        'name': _nameController.text,
        'id': _idController.text,
        'department': _departmentController.text,
        'contact': _contactController.text,
        'imageUrl': _imageUrl,
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserLoginScreen()),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final User? user = _auth.currentUser;
      if (user != null) {
        final fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference storageRef = _firebaseStorage.ref().child('profile_images/$fileName');
        final UploadTask uploadTask = storageRef.putFile(File(pickedFile.path));
        final TaskSnapshot taskSnapshot = await uploadTask;
        _imageUrl = await taskSnapshot.ref.getDownloadURL();
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color(0xFFB9E5F8),
      ),
      backgroundColor: Color(0xFFB9E5F8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (_imageUrl != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_imageUrl!),
                ),
              SizedBox(height: 10),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: _pickImage,
                iconSize: 30,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                ),
              ),
              TextField(
                controller: _departmentController,
                decoration: InputDecoration(
                  labelText: 'Department',
                ),
              ),
              TextField(
                controller: _contactController,
                decoration: InputDecoration(
                  labelText: 'Contact',
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: 160,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF53bcd4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: _updateUserData,
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
