import 'package:flutter/material.dart';
import 'package:tams/Public/MYcustomWidgets/Constant_page.dart';
import '../../Message_Page/Pages/Message_page.dart';

class PeopleListPage extends StatelessWidget {
  final List<String> people = [
    'Alice',
    'Bob',
    'Charlie',
    'Dave',
    'Eve',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: appBarColor, // WhatsApp color
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          flexibleSpace: Center(
            child: Text(
              'People',
              style: TextStyle(
                color: appBarTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          return _buildPersonTile(context, people[index]);
        },
      ),
    );
  }

  Widget _buildPersonTile(BuildContext context, String personName) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      leading: CircleAvatar(
        radius: 30.0, // Profile picture size
        backgroundColor: Colors.grey[300],
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      title: Text(
        personName,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: IconButton(
        icon: Image.asset(
          'Assets/Images/messenger.png', // Replace with the path to your image
          width: 24.0,
          height: 24.0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            _createPageTransition(
              page: MessagingPage(personName: personName),
            ),
          );
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          _createPageTransition(
            page: MessagingPage(personName: personName),
          ),
        );
      },
    );
  }

  PageRouteBuilder _createPageTransition({required Widget page}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
