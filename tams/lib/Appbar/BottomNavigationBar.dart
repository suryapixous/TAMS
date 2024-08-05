import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:animate_do/animate_do.dart'; // Ensure animate_do package is imported
import '../HOME/Pages/Home.dart';
import '../Holiday_calender/Pages/Holiday_calender_page.dart';
import '../Multimedia_page/Pages/Multimedia_page.dart';
import '../Notice_Board/Pages/Notice_Board.dart';
import '../Profile/Pages/Profile_page.dart';
import '../Report_Page/Pages/Report_page.dart';

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
    const AttendanceReportPage(),
    const NoticeBoard(),
    const MultimediaPage(), // Add the MultimediaPage
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
          TabItem(
            icon: _buildAnimatedIcon(Icons.home, 'Home', 0),
            title: 'Home',
          ),
          TabItem(
            icon: _buildAnimatedIcon(Icons.analytics, 'Report Page', 1),
            title: 'Report',
          ),
          TabItem(
            icon: _buildAnimatedImageIcon(
                'Assets/Images/board.png', 'Notice Board', 2),
            title: 'Notice',
          ),
          TabItem(
            icon: _buildAnimatedIcon(Icons.perm_media_rounded, 'Multimedia',
                3), // Add the multimedia icon
            title: 'Multimedia',
          ),
          TabItem(
            icon: _buildProfileIcon(
                'Assets/Images/ali-morshedlou-WMD64tMfc4k-unsplash.jpg'), // Replace with your image path
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

  Widget _buildAnimatedIcon(IconData icon, String title, int index) {
    return BounceInDown(
      duration: Duration(milliseconds: 500 * (index + 1)),
      child: Icon(icon, size: 30),
    );
  }

  Widget _buildAnimatedImageIcon(String imagePath, String title, int index) {
    return BounceInDown(
      duration: Duration(milliseconds: 500 * (index + 1)),
      child: Image.asset(
        imagePath,
        width: 24, // Adjust size as needed
        height: 24, // Adjust size as needed
      ),
    );
  }

  Widget _buildProfileIcon(String imagePath) {
    return BounceInDown(
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: 30, // Adjust size as needed
        height: 30, // Adjust size as needed
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 2), // Red border
          image: DecorationImage(
            image: AssetImage(imagePath), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
