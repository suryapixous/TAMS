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

class _BottombarState extends State<Bottombar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // List of pages to display in the bottom bar
  final List<Widget> _pages = [
    const AttendanceReportPage(),
    const NoticeBoard(),
    const AttendancePage(),
    const MultimediaPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(
            icon: _buildAnimatedIcon(Icons.analytics, 0),
            title: _selectedIndex == 0 ? 'Report' : '',
          ),
          TabItem(
            icon: _buildAnimatedImageIcon('Assets/Images/noticeboard.png', 1),
            title: _selectedIndex == 1 ? 'Notice' : '',
          ),
          TabItem(
            icon: _buildAnimatedIcon(Icons.home, 2),
            title: _selectedIndex == 2 ? 'Home' : '',
          ),
          TabItem(
            icon: _buildAnimatedIcon(Icons.perm_media_rounded, 3),
            title: _selectedIndex == 3 ? 'Media' : '',
          ),
          TabItem(
            icon: _buildProfileIcon(
                'Assets/Images/ali-morshedlou-WMD64tMfc4k-unsplash.jpg'),
            title: _selectedIndex == 4 ? 'Profile' : '',
          ),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
        style: TabStyle.react,
        backgroundColor: Colors.white,
        activeColor: Colors.blueAccent,
        color: Colors.grey,
        elevation: 5, // Add some shadow if needed
      ),
    );
  }

  Widget _buildAnimatedIcon(IconData icon, int index) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _selectedIndex == index ? 1.2 + _animation.value * 0.2 : 1.0,
          child: Icon(icon, size: 30),
        );
      },
    );
  }

  Widget _buildAnimatedImageIcon(String imagePath, int index) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _selectedIndex == index ? 1.2 + _animation.value * 0.2 : 1.0,
          child: Image.asset(
            imagePath,
            width: 24,
            height: 24,
          ),
        );
      },
    );
  }

  Widget _buildProfileIcon(String imagePath) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _selectedIndex == 4 ? 1.2 + _animation.value * 0.2 : 1.0,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 2),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
