import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ulab_eventpedia_main/user_Edit_Profile.dart';
import 'user_SignIn_page.dart';

class UserProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _fetchUserData(String uid) async {
    DocumentSnapshot userDoc = await _firestore.collection('general_users').doc(uid).get();
    return userDoc.data() as Map<String, dynamic>?;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFFB9E5F8),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: user != null ? _fetchUserData(user.uid) : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data available'));
          }

          final userData = snapshot.data!;
          String? imageUrl = userData['imageUrl'];

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF409DAA), width: 3.0),
                        ),
                        child: ClipOval(
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF409DAA), width: 3.0),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(imageUrl ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        right: -10,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          color: Color(0xFF409DAA),
                          iconSize: 30,
                          onPressed: () async {
                            final bool isUpdated = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditProfilePage())
                            );
                            if (isUpdated == true) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => UserProfilePage()),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Color(0xFF409DAA), width: 3.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Name: ${userData['name']}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'ID: ${userData['id']}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Department: ${userData['department']}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Contact: ${userData['contact']}',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Email: ${user?.email ?? 'N/A'}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF53bcd4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _auth.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JoinAsUserPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
