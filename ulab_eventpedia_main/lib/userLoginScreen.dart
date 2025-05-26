import 'package:flutter/material.dart';
import 'package:ulab_eventpedia_main/user_JoinedEvents.dart';
import 'package:ulab_eventpedia_main/user_Notifications_Page.dart';
import 'package:ulab_eventpedia_main/user_Prev_Events_Page.dart';
import 'package:ulab_eventpedia_main/user_Upcoming_Events_Page.dart';
import 'UserProfilePage.dart';

class UserLoginScreen extends StatefulWidget {

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
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
          UserUpcomingEventsPage(),
          UserPreviousEventsPage(),
          UserJoinedEventsPage(),
          NotificationsPage(),
          UserProfilePage(),
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
              'assets/joined-events.png',
              width: 24,
              height: 24,
            ),
            label: 'Joined Events',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/notif.png',
              width: 24,
              height: 24,
            ),
            label: 'Notifications',
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
