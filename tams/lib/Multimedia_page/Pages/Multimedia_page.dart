import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../MYcustomWidgets/Constant_page.dart';

class MultimediaPage extends StatefulWidget {
  const MultimediaPage({super.key});

  @override
  _MultimediaPageState createState() => _MultimediaPageState();
}

class _MultimediaPageState extends State<MultimediaPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
              'Multimedia',
              style: TextStyle(
                color: appBarTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              _buildPdfListPage(),
              _buildDocumentListPage(),
              _buildImageListPage(),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfListPage() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildListTile(
            'Sample PDF Document 1', Icons.picture_as_pdf, Colors.red),
        _buildListTile(
            'Sample PDF Document 2', Icons.picture_as_pdf, Colors.red),
        // Add more items here
      ],
    );
  }

  Widget _buildDocumentListPage() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildListTile('Sample Document 1', Icons.description, Colors.green),
        _buildListTile('Sample Document 2', Icons.description, Colors.green),
        // Add more items here
      ],
    );
  }

  Widget _buildImageListPage() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 10, // Number of images
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          child: Image.asset(
            'assets/images/sample_image_${index + 1}.png', // Replace with your image paths
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Widget _buildListTile(String title, IconData icon, Color iconColor) {
    return BounceInDown(
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          leading: Icon(icon, color: iconColor),
          title: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Implement navigation or functionality
          },
        ),
      ),
    );
  }
}
