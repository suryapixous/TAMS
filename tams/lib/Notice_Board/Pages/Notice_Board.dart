import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../../MYcustomWidgets/Constant_page.dart'; // Ensure animate_do package is imported

class NoticeBoard extends StatelessWidget {
  const NoticeBoard({super.key});

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
              'Notice Board',
              style: TextStyle(
                color: appBarTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildNoticeCard(
            context,
            imageUrl: 'Assets/Images/Python-Intrerview-Q&A-copy.webp',
            title: 'Notice Title 1',
            description:
                'This is a brief description of notice 1. It contains important information.',
            date: 'Aug 5, 2024', // Example date
          ),
          _buildNoticeCard(
            context,
            imageUrl: 'Assets/Images/logo-search-grid-2x.png',
            title: 'Notice Title 2',
            description:
                'This is a brief description of notice 2. It contains more details about the notice.',
            date: 'Aug 6, 2024', // Example date
          ),
          _buildNoticeCard(
            context,
            imageUrl: 'Assets/Images/Python-Intrerview-Q&A-copy.webp',
            title: 'Notice Title 3',
            description:
                'This is a brief description of notice 3. Read it for further information.',
            date: 'Aug 7, 2024', // Example date
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeCard(
    BuildContext context, {
    required String imageUrl,
    required String title,
    required String description,
    required String date, // Added date parameter
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      child: SlideInUp(
        duration: const Duration(milliseconds: 500),
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title above the image
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15.0)),
                    child: Image.asset(
                      imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover, // Adjusts image size to cover the area
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black54, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        date,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
