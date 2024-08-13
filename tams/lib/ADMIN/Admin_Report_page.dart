import 'package:flutter/material.dart';
import '../Public/MYcustomWidgets/Constant_page.dart';
import 'AbsentPage.dart';
import 'PresentPage.dart';
import 'LatePage.dart';

class AttendanceAdminReportPage extends StatefulWidget {
  final String selectedCourse;

  const AttendanceAdminReportPage({super.key, required this.selectedCourse});

  @override
  _AttendanceAdminReportPageState createState() =>
      _AttendanceAdminReportPageState();
}

class _AttendanceAdminReportPageState extends State<AttendanceAdminReportPage> {
  int presentCount = 0;
  int absentCount = 0;
  int lateCount = 0;

  @override
  void initState() {
    super.initState();
    // Initialize counts
    // You can replace these with actual logic to get the counts
    presentCount = 10; // Example count
    absentCount = 5; // Example count
    lateCount = 3; // Example count
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: appBarColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          flexibleSpace: Center(
            child: Text(
              '${widget.selectedCourse}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: PageView(
        children: [
          AbsentPage(absentCount: absentCount),
          PresentPage(presentCount: presentCount),
          LatePage(lateCount: lateCount),
        ],
      ),
    );
  }
}
