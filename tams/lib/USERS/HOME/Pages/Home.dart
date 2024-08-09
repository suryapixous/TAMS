import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../Public/MYcustomWidgets/Constant_page.dart';
import '../../../Public/Notification/Pages/Noification_Page.dart';
import 'calendar_page.dart'; // Import the CalendarPage class
import '../../Holiday_calender/Pages/Holiday_calender_page.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final List<String> _courses = [
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science'
  ];

  bool _isGridView = false;
  String _searchQuery = '';
  int _notificationCount = 2; // Example notification count

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    // You can implement actual refresh logic here if needed
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
        backgroundColor: appBarColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        flexibleSpace: Stack(
          children: [
            // Centered Text
            Center(
              child: Text(
                'Attendance',
                style: TextStyle(
                  color: appBarTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Icons Row
            Positioned(
              right: 0,
              left: 20,
              top: 0,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    iconSize: 20, // Decrease icon size
                    color: Colors.black,
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HolidayCalendarPage(),
                        ),
                      );
                    },
                  ),
                  Stack(
                    children: [
                      IconButton(
                        iconSize: 20, // Decrease icon size
                        color: Colors.black,
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
                              color: Colors.red,
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
                      width: 8), // Decreased the width for closer placement
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

    return ReorderableListView(
      padding: const EdgeInsets.all(16.0),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex--;
          }
          final item = _courses.removeAt(oldIndex);
          _courses.insert(newIndex, item);
        });
      },
      children: List.generate(
        filteredCourses.length,
        (index) {
          return BounceInUp(
            key: ValueKey(filteredCourses[index]),
            duration: const Duration(milliseconds: 500),
            child: Card(
              elevation: 8, // Increased elevation for a more pronounced shadow
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // More rounded corners
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white
                          .withOpacity(0.3), // Lighter shade for the card
                      Colors.white.withOpacity(0.2)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: Icon(
                    Icons.local_library_rounded,
                    color: Colors.black54,
                    size: 30, // Larger icon for better visibility
                  ),
                  title: Text(
                    filteredCourses[index],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blueGrey,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarPage(
                          selectedCourse: filteredCourses[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
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
        return BounceInUp(
          duration: const Duration(milliseconds: 500),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.2)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarPage(
                        selectedCourse: filteredCourses[index],
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
                          filteredCourses[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2, // Allow text to wrap to a second line
                          overflow: TextOverflow
                              .ellipsis, // Truncate with ellipsis if text exceeds two lines
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
