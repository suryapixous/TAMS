import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../MYcustomWidgets/Constant_page.dart';
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
    final Color appBarColor = Theme.of(context)
        .colorScheme
        .primary; // Define app bar color using theme
    const Color appBarTextColor = Colors.white; // Define app bar text color

    return Scaffold(
      appBar: _buildAppBar(),
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
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                    child: Icon(
                      _isGridView ? Icons.list : Icons.grid_view,
                      color: Colors.white,
                    ),
                    backgroundColor: appBarColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100.0), // Set the desired height
      child: AppBar(
        backgroundColor: appBarColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        flexibleSpace: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Empty space to push the title to the center
                  SizedBox(width: 100), // Adjust width as needed

                  // Title in the center
                  Text(
                    'Attendance',
                    style: TextStyle(
                      color: appBarTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Action icons on the right
                  Row(
                    children: [
                      IconButton(
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
                            color: Colors.black,
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Notifications'),
                                  content: const Text('No new notifications.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          if (_notificationCount > 0)
                            Positioned(
                              right: 6,
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
                      const SizedBox(width: 16),
                    ],
                  ),
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
            key: ValueKey(
                filteredCourses[index]), // Key required for ReorderableListView
            duration: const Duration(milliseconds: 500),
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appBarColor.withOpacity(0.2),
                      Colors.purpleAccent.withOpacity(0.1)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: Icon(
                    Icons.book,
                    color: appBarColor,
                  ),
                  title: Text(
                    filteredCourses[index],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: appBarColor,
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
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.7, // Adjusted aspect ratio for larger boxes
      ),
      itemCount: filteredCourses.length,
      itemBuilder: (context, index) {
        return BounceInUp(
          duration: const Duration(milliseconds: 500),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    appBarColor.withOpacity(0.2),
                    Colors.purpleAccent.withOpacity(0.1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book,
                        color: appBarColor,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        filteredCourses[index],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
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
