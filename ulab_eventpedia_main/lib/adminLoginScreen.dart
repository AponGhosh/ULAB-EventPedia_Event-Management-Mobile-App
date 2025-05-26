import 'package:flutter/material.dart';
import 'admin_Prev_Events_Page.dart';
import 'CreateEventsPage.dart';
import 'AdminProfilePage.dart';
import 'admin_Upcoming_Events_Page.dart';

class AdminLoginScreen extends StatefulWidget {

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          UpcomingEventsPage(),
          PreviousEventsPage(),
          CreateEventsPage(),
          AdminProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/home_page.png',
              width: 24,
              height: 24,
            ),
            label: 'Upcoming Events',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/previous_events.png',
              width: 24,
              height: 24,
            ),
            label: 'Previous Events',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/create_events.png',
              width: 24,
              height: 24,
            ),
            label: 'Create Events',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/profile.png',
              width: 24,
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        backgroundColor: Color(0xFFB9E5F8),
      ),
    );
  }
}

