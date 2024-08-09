import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../Public/MYcustomWidgets/Constant_page.dart';
import '../../Multimedia_page/Pages/Multimedia_page.dart';
import 'qr_scanner_page.dart';

class CalendarPage extends StatefulWidget {
  final String selectedCourse;

  const CalendarPage({
    super.key,
    required this.selectedCourse,
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  final DateTime _currentDate = DateTime.now();
  late Map<DateTime, String> _statusMap;

  @override
  void initState() {
    super.initState();
    _updateStatusMap();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCustomDialog(context); // Show dialog after the widget is built
    });
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

  Future<void> _refreshCalendar() async {
    // Simulate a network request or data fetching
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _updateStatusMap(); // Refresh status map or update it with new data
      _selectedDate = _currentDate; // Set the selected date to current date
    });
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
                color: appBarTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(
                top: 18), // Adjust the top padding value as needed
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                  Icons.photo_library), // Replace with your multimedia icon
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MultimediaPage(), // Navigate to MultimediaPage
                  ),
                );
              },
            ),
            const SizedBox(width: 20), // Optional spacing
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCalendar,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const SizedBox(height: 16.0),
            TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
                if (isSameDay(selectedDay, _currentDate)) {
                  _openQrScanner();
                }
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: const TextStyle(color: Colors.white),
                defaultDecoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  shape: BoxShape.circle,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final status = _statusMap[day] ?? 'none';
                  return _buildCustomDateWidget(day, status);
                },
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).colorScheme.primary,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
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
        color = Colors.transparent;
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
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _openQrScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScannerPage(),
      ),
    );

    if (result == true) {
      // Update the status of the current date to 'present' if QR code is valid
      setState(() {
        _statusMap[_currentDate] = 'present';
      });
    }
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year &&
        day1.month == day2.month &&
        day1.day == day2.day;
  }
}

Future<void> showCustomDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button to close the dialog
    builder: (BuildContext context) {
      return AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 300),
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            'Tap on the current date to scan the QR code.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got It'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
