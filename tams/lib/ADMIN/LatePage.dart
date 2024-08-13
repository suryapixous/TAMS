import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LatePage extends StatefulWidget {
  final int lateCount;

  const LatePage({super.key, required this.lateCount});

  @override
  _LatePageState createState() => _LatePageState();
}

class _LatePageState extends State<LatePage> {
  String searchQuery = '';
  DateTimeRange? selectedDateRange;

  List<Map<String, dynamic>> students = [
    {'name': 'John Doe', 'date': DateTime(2024, 8, 10)},
    {'name': 'Jane Smith', 'date': DateTime(2024, 8, 11)},
    {'name': 'Alice Johnson', 'date': DateTime(2024, 8, 12)},
  ];

  List<Map<String, dynamic>> get filteredStudents {
    return students.where((student) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(student['date']);

      bool matchesQuery =
          student['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
              formattedDate.contains(searchQuery);

      bool matchesDateRange = selectedDateRange == null ||
          (student['date'].isAfter(selectedDateRange!.start) &&
              student['date'].isBefore(selectedDateRange!.end));

      return matchesQuery && matchesDateRange;
    }).toList();
  }

  Future<void> pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2040, 12, 31),
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Late Students',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name or date',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: pickDateRange,
                    child: Text(selectedDateRange == null
                        ? 'Select Date Range'
                        : '${DateFormat('dd/MM/yyyy').format(selectedDateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(selectedDateRange!.end)}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Filtered Count: ${filteredStudents.length}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  return ListTile(
                    title: Text(student['name']),
                    trailing: Text(
                        '${student['date'].day}/${student['date'].month}/${student['date'].year}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
