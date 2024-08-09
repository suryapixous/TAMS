import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animate_do/animate_do.dart';

import '../../../Public/MYcustomWidgets/Constant_page.dart';

class HolidayCalendarPage extends StatefulWidget {
  const HolidayCalendarPage({super.key});

  @override
  _HolidayCalendarPageState createState() => _HolidayCalendarPageState();
}

class _HolidayCalendarPageState extends State<HolidayCalendarPage> {
  late Map<DateTime, List<String>> _holidays;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  bool _showHolidayList = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _holidays = {
      DateTime(2024, 1, 1): ['New Year\'s Day'],
      DateTime(2024, 1, 15): ['Pongal'],
      DateTime(2024, 1, 16): ['Thiruvalluvar Day'],
      DateTime(2024, 1, 17): ['Uzhavar Thirunal'],
      DateTime(2024, 1, 25): ['Thai Poosam'],
      DateTime(2024, 1, 26): ['Republic Day'],
      DateTime(2024, 3, 29): ['Good Friday'],
      DateTime(2024, 4, 1): [
        'Annual closing of Accounts for Commercial Banks and Co-operative Banks'
      ],
      DateTime(2024, 4, 9): ['Telugu New Year Day'],
      DateTime(2024, 4, 11): ['Ramzan (Idul Fitr)'],
      DateTime(2024, 4, 14): [
        'Tamil New Year\'s Day and Dr. B.R. Ambedkar\'s Birthday'
      ],
      DateTime(2024, 4, 21): ['Mahaveer Jayanthi'],
      DateTime(2024, 5, 1): ['May Day'],
      DateTime(2024, 6, 17): ['Bakrid (Idul Azha)'],
      DateTime(2024, 7, 17): ['Muharram'],
      DateTime(2024, 8, 15): ['Independence Day'],
      DateTime(2024, 8, 26): ['Krishna Jayanthi'],
      DateTime(2024, 9, 7): ['Vinayakar Chathurthi'],
      DateTime(2024, 9, 16): ['Milad-un-Nabi'],
      DateTime(2024, 10, 2): ['Gandhi Jayanthi'],
      DateTime(2024, 10, 11): ['Ayutha Pooja'],
      DateTime(2024, 10, 12): ['Vijaya Dasami'],
      DateTime(2024, 10, 31): ['Deepavali'],
      DateTime(2024, 12, 25): ['Christmas'],
    };
  }

  Future<void> _refreshCalendar() async {
    setState(() {
      _selectedDay = DateTime.now();
      _focusedDay = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple; // Use the color you prefer

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
          flexibleSpace: Center(
            child: Text(
              'Holiday Calendar',
              style: TextStyle(
                color: appBarTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCalendar,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    eventLoader: (day) {
                      return _holidays[
                              DateTime(day.year, day.month, day.day)] ??
                          [];
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isNotEmpty) {
                          return _buildHolidayMarker(
                              date); // Pass the date to the method
                        }
                        return null;
                      },
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      holidayTextStyle: TextStyle(color: Colors.green),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle:
                          const TextStyle(color: Colors.black, fontSize: 20.0),
                      leftChevronIcon:
                          const Icon(Icons.chevron_left, color: Colors.black),
                      rightChevronIcon:
                          const Icon(Icons.chevron_right, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _showHolidayList,
                child: FadeInUp(
                  duration: Duration(milliseconds: 500),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    children: _holidays.entries.map((entry) {
                      return _buildHolidayTile(entry.key, entry.value.first);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showHolidayList = !_showHolidayList;
          });
        },
        child: Icon(_showHolidayList ? Icons.close : Icons.list),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHolidayMarker(DateTime date) {
    final day = date.day;

    return Container(
      margin: const EdgeInsets.all(4.0),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: Center(
        child: Text(
          '$day',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidayTile(DateTime date, String holiday) {
    final String day = _formatDay(date);
    final String dateString = '${_formatDate(date)}, $day';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        title: Text(
          dateString,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(holiday),
        leading: Icon(Icons.calendar_today, color: Colors.black54),
      ),
    );
  }

  String _formatDay(DateTime date) {
    return [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ][date.weekday % 7];
  }

  String _formatDate(DateTime date) {
    return '${date.day < 10 ? '0' : ''}${date.day} ${_formatMonth(date.month)}';
  }

  String _formatMonth(int month) {
    return [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][month - 1];
  }
}
