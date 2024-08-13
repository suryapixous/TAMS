import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../Public/MYcustomWidgets/Constant_page.dart';
import '../../../Public/Notification/Pages/Noification_Page.dart';
import '../../Holiday_calender/Pages/Holiday_calender_page.dart';
import '../../Message_Page/Pages/Chat_list_page.dart';
import '../../Notice_Board/Pages/Notice_Board.dart';
import '../../Report_Page/Pages/Report_page.dart';
import 'calendar_page.dart'; // Import the CalendarPage class

class AttendancePage extends StatefulWidget {
  final bool isAdmin; // Add a flag to determine if the user is an admin

  const AttendancePage({super.key, required this.isAdmin});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<String> _courses = [
    'Python',
    'JavaScript',
    'Java',
    'C++',
    'Dart',
    'C#',
    'Ruby',
    'Swift',
    'Go',
    'Kotlin',
  ];

  bool _isGridView = false;
  String _searchQuery = '';
  int _notificationCount = 2; // Example notification count

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    // You can implement actual refresh logic here if needed
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: const Text('This is a message dialog.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SlideInUp(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context); // Closes the current page (optional)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const AttendanceReportPage()), // Replace with actual `NoticeBoard` page
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.grade),
                title: const Text('Grades'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement navigation to Grades page
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('People'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement navigation to People page
                },
              ),
              ListTile(
                leading: const Icon(Icons.support),
                title: const Text('Support'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement navigation to Support page
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_membership),
                title: const Text('Certificate'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement navigation to Certificate page
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_call),
                title: const Text('Live Session'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement navigation to Live Session page
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = Theme.of(context).colorScheme.primary;
    const Color appBarTextColor = Colors.white;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildAppBar(screenWidth),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: appBarColor),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Optional: Add logic for when search button is pressed
                  },
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _refresh,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isGridView
                        ? _buildGridView(appBarColor)
                        : _buildListView(appBarColor),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 19,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                    child: Icon(
                      _isGridView ? Icons.list : Icons.grid_view,
                      color: Colors.black,
                    ),
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar(double screenWidth) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0),
      child: AppBar(
        backgroundColor: appBarColor, // Set AppBar color
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        leading: !widget.isAdmin
            ? IconButton(
                color: appBarTextColor,
                icon: const Icon(Icons.menu),
                onPressed: _showMenu,
              )
            : null,
        flexibleSpace: Stack(
          children: [
            Center(
              child: Text(
                'Attendance',
                style: TextStyle(
                  color: appBarTextColor, // Ensure text color is readable
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!widget.isAdmin) // Only show message icon if not admin
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatListPage(),
                          ),
                        );
                      },
                      child: Image.asset(
                        color: appBarTextColor,
                        'Assets/Images/messenger.png', // Replace with your image path
                        width: 20,
                        height: 20,
                      ),
                    ),
                  const SizedBox(width: 1), // Adjust spacing between icons
                  Stack(
                    children: [
                      IconButton(
                        iconSize: 20, // Decrease icon size
                        color:
                            appBarTextColor, // Match icon color to AppBar text color
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationPage(),
                            ),
                          );
                        },
                      ),
                      if (_notificationCount > 0)
                        Positioned(
                          right: 0,
                          top: 6,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            decoration: BoxDecoration(
                              color:
                                  Colors.redAccent, // Notification badge color
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                '$_notificationCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                      width: 16), // Additional spacing from right edge
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(Color appBarColor) {
    final filteredCourses = _courses
        .where((course) =>
            course.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredCourses.length,
      itemBuilder: (context, index) {
        final course = filteredCourses[index];
        return FadeInUp(
          duration: Duration(milliseconds: 500 + (index * 100)),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(course),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarPage(
                      selectedCourse: course,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(Color appBarColor) {
    final filteredCourses = _courses
        .where((course) =>
            course.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: MediaQuery.of(context).size.width > 600 ? 0.8 : 1.0,
      ),
      itemCount: filteredCourses.length,
      itemBuilder: (context, index) {
        final course = filteredCourses[index];
        return BounceInUp(
          duration: const Duration(milliseconds: 500),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarPage(
                      selectedCourse: course,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Icon(
                        Icons.local_library_rounded,
                        color: Colors.black54,
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      flex: 2,
                      child: Text(
                        course,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
