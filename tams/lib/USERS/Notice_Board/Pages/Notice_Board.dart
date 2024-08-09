import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Public/MYcustomWidgets/Constant_page.dart';

class NoticeBoard extends StatefulWidget {
  const NoticeBoard({super.key});

  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  List<Map<String, String>> notices = [
    {
      'imageUrl': 'Assets/Images/Python-Intrerview-Q&A-copy.webp',
      'title': 'Notice Title 1',
      'description':
          'This is a brief description of notice 1. It contains important information.',
      'date': 'Aug 5, 2024',
      'link': 'https://www.google.com/search?q=python+interview',
    },
    {
      'imageUrl': 'Assets/Images/sih2024-problem-statement-live.png',
      'title': 'Notice Title 2',
      'description':
          'This is a brief description of notice 2. It contains more details about the notice.',
      'date': 'Aug 6, 2024',
      'link': 'https://www.sih.gov.in/',
    },
    {
      'imageUrl': 'Assets/Images/Python-Intrerview-Q&A-copy.webp',
      'title': 'Notice Title 3',
      'description':
          'This is a brief description of notice 3. Read it for further information.',
      'date': 'Aug 7, 2024',
      'link': 'https://www.google.com',
    },
  ];

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
      body: RefreshIndicator(
        onRefresh: _refreshNotices,
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: notices.length,
          itemBuilder: (context, index) {
            return _buildNoticeCard(
              context,
              imageUrl: notices[index]['imageUrl']!,
              title: notices[index]['title']!,
              description: notices[index]['description']!,
              date: notices[index]['date']!,
              link: notices[index]['link']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildNoticeCard(
    BuildContext context, {
    required String imageUrl,
    required String title,
    required String description,
    required String date,
    required String link,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: FadeIn(
        duration: const Duration(milliseconds: 800),
        child: Card(
          elevation: 12,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10.0)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.grey[200],
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit
                          .cover, // Changed to cover to ensure image fits well
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 15,
                        color: Colors.grey[800],
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: () => _launchUrl(link),
                      child: Text(
                        'Visit Link',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshNotices() async {
    // Simulate a network call or data fetching
    await Future.delayed(const Duration(seconds: 1));
    // Here, you can update the notices list if you fetch new data
    // For now, it just refreshes the same list
    setState(() {
      // In a real app, you might want to fetch updated data from an API or database
      notices = [...notices]; // Simply reassign to trigger UI update
    });
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        // URL launched successfully
      } else {
        // Handle the case where the URL could not be launched
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch the URL.'),
          ),
        );
      }
    } catch (e) {
      // Handle the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch the URL: $e'),
        ),
      );
    }
  }
}
