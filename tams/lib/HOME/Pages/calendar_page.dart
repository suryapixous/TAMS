import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Example QR scanner package

class CalendarPage extends StatefulWidget {
  final String selectedCourse;
  final void Function(DateTime) onDateSelected; // Add this line

  const CalendarPage({
    super.key,
    required this.selectedCourse,
    required this.onDateSelected, // Add this line
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  final DateTime _currentDate = DateTime.now();

  // Define the status of the last 3 days dynamically
  late final Map<DateTime, String> _statusMap;

  @override
  void initState() {
    super.initState();
    _updateStatusMap();
  }

  void _updateStatusMap() {
    final today =
        DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
    final threeDaysAgo = today.subtract(const Duration(days: 3));

    _statusMap = {
      threeDaysAgo: 'late',
      threeDaysAgo.add(const Duration(days: 1)): 'absent',
      threeDaysAgo.add(const Duration(days: 2)): 'present',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Select a date to mark attendance for ${widget.selectedCourse}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TableCalendar(
                focusedDay: _selectedDate,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(color: Colors.white),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final status = _statusMap[day] ?? 'none';
                    return GestureDetector(
                      onTap: () {
                        if (isSameDay(day, _currentDate)) {
                          // Open QR scanner when current date is clicked
                          _openQrScanner();
                        } else {
                          // Call the onDateSelected callback for other dates
                          widget.onDateSelected(day);
                        }
                      },
                      child: _buildCustomDateWidget(day, status),
                    );
                  },
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurpleAccent,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.deepPurpleAccent,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomDateWidget(DateTime date, String status) {
    Color color;

    switch (status) {
      case 'present':
        color = Colors.green;
        break;
      case 'absent':
        color = Colors.red;
        break;
      case 'late':
        color = Colors.orange;
        break;
      default:
        color = Colors.transparent; // Default color if no status
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _openQrScanner() {
    // Replace this with actual QR scanner logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Scanner'),
        content: const Text('QR Scanner functionality goes here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
