import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../MYcustomWidgets/Constant_page.dart';
import 'qr_scanner_page.dart'; // Import the QR scanner page

class CalendarPage extends StatefulWidget {
  final String selectedCourse;

  const CalendarPage({
    super.key,
    required this.selectedCourse,
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  final DateTime _currentDate = DateTime.now();
  late Map<DateTime, String> _statusMap;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _showTutorial = true; // Flag to control the visibility of the tutorial

  @override
  void initState() {
    super.initState();
    _updateStatusMap();

    // Initialize the AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Start the animation
    if (_showTutorial) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              'Calendar - ${widget.selectedCourse}',
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
        ),
// Set the desired height
      ),
      body: Stack(
        children: [
          RefreshIndicator(
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
                      color: Theme.of(context).colorScheme.primary,
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
          FadeTransition(
            opacity: _fadeAnimation,
            child: _showTutorial ? _buildTutorialOverlay() : SizedBox.shrink(),
          ),
        ],
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
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTutorialOverlay() {
    return Positioned(
      top: 100,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: Material(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Click your today\'s date',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _animationController.reverse().then((_) {
                    setState(() {
                      _showTutorial = false;
                    });
                  });
                },
                child: const Text('Got it'),
              ),
            ],
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
}
