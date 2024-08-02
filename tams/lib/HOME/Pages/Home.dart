import 'package:flutter/material.dart';
import 'calendar_page.dart'; // Import the CalendarPage class

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

  String? _selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 5,
      ),
      body: _selectedCourse == null
          ? _buildCourseList()
          : CalendarPage(
              selectedCourse: _selectedCourse!,
              onDateSelected: (DateTime date) {
                // Handle attendance submission here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Attendance marked for $_selectedCourse on ${date.toLocal()}'),
                    backgroundColor: Colors.greenAccent,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildCourseList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              _courses[index],
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            onTap: () {
              setState(() {
                _selectedCourse = _courses[index];
              });
            },
          ),
        );
      },
    );
  }
}
