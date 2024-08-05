import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../MYcustomWidgets/Constant_page.dart'; // Ensure animate_do package is imported

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  _AttendanceReportPageState createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _attendanceRecords = [
    {'date': DateTime(2024, 8, 1), 'status': 'present'},
    {'date': DateTime(2024, 8, 2), 'status': 'absent'},
    {'date': DateTime(2024, 8, 3), 'status': 'late'},
  ];
  List<Map<String, dynamic>> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _filteredRecords = _attendanceRecords;
  }

  void _filterRecords(String query) {
    setState(() {
      _filteredRecords = _attendanceRecords.where((record) {
        final date = record['date'] as DateTime;
        return date.toString().contains(query) || query.isEmpty;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    int presentCount = _filteredRecords
        .where((record) => record['status'] == 'present')
        .length;
    int absentCount =
        _filteredRecords.where((record) => record['status'] == 'absent').length;
    int lateCount =
        _filteredRecords.where((record) => record['status'] == 'late').length;
    int totalCount = _filteredRecords.length;

    double percentage = totalCount > 0 ? (presentCount / totalCount) * 100 : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: _filterRecords,
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildCountCard('Present', presentCount,
                        Colors.green, Icons.check_circle),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCountCard(
                        'Absent', absentCount, Colors.red, Icons.cancel),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              duration: const Duration(milliseconds: 700),
              child: Center(
                child: _buildCountCard(
                    'Late', lateCount, Colors.orange, Icons.access_time),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Text(
                'Attendance Percentage: ${percentage.toStringAsFixed(2)}%',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredRecords.length,
                itemBuilder: (context, index) {
                  final record = _filteredRecords[index];
                  final date = record['date'] as DateTime;
                  final status = record['status'] as String;

                  return BounceInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text('${date.toLocal()}'),
                        subtitle: Text('Status: $status'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountCard(String title, int count, Color color, IconData icon) {
    return BounceInUp(
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: color, size: 30),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color),
                    ),
                    Text(
                      count.toString(),
                      style: TextStyle(fontSize: 22, color: color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
