import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tams/ADMIN/Admin_Report_page.dart';
import '../../../Public/MYcustomWidgets/Constant_page.dart';

class AttendanceReportPageAdmin extends StatefulWidget {
  const AttendanceReportPageAdmin({super.key});

  @override
  _AttendanceReportPageAdminState createState() =>
      _AttendanceReportPageAdminState();
}

class _AttendanceReportPageAdminState extends State<AttendanceReportPageAdmin> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Set the desired height
        child: AppBar(
          backgroundColor: appBarColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          flexibleSpace: Center(
            child: Text(
              'Course List',
              style: TextStyle(
                color: appBarTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _courses.length,
          itemBuilder: (context, index) {
            final course = _courses[index];
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
                        builder: (context) => AttendanceAdminReportPage(
                          selectedCourse: course,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
