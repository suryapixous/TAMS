import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import '../HOME/Pages/Home.dart';
import '../Profile/Pages/Profile_page.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  _BottombarState createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int _selectedIndex = 0;

  // List of pages to display in the bottom bar
  final List<Widget> _pages = [
    const AttendancePage(),
    const ProfilePage(), // Ensure these pages are defined and imported correctly
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: ConvexAppBar(
        items: [
          const TabItem(icon: Icons.home, title: 'Home'),
          const TabItem(icon: Icons.widgets, title: 'Icon 3'),
          TabItem(
            icon: Container(
              width: 30, // Adjust size as needed
              height: 30, // Adjust size as needed
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red, width: 2), // Red border
                image: DecorationImage(
                  image: AssetImage(
                      'Assets/Images/ali-morshedlou-WMD64tMfc4k-unsplash.jpg'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: 'Profile',
          ),
        ],
        initialActiveIndex: _selectedIndex, // optional, default as 0
        onTap: _onItemTapped,
        style: TabStyle.react, // style that gives zoom effect
        backgroundColor: Colors.white,
        activeColor: Colors.blueAccent,
        color: Colors.grey,
      ),
    );
  }
}
