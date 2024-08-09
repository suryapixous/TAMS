import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../../Public/MYcustomWidgets/Constant_page.dart';

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
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: appBarColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          flexibleSpace: const Center(
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
                effect: const ExpandingDotsEffect(
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
      ],
    );
  }

  Widget _buildDocumentListPage() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildListTile('Sample Document 1', Icons.description, Colors.green),
        _buildListTile('Sample Document 2', Icons.description, Colors.green),
      ],
    );
  }

  Widget _buildImageListPage() {
    final List<String> imageUrls = [
      'https://image.slidesharecdn.com/what-is-python-presentation-230326123553-7e24f9d9/75/what-is-python-presentation-pptx-1-2048.jpg',
      'https://files.prepinsta.com/2020/07/Ppython-process.webp',
      'https://images.clickittech.com/2020/wp-content/uploads/2022/08/17215849/Python-framework-44-1.jpg',
      'https://www.altamira.ai/wp-content/uploads/2019/10/KIhY-nnA.png',
      'https://files.prepinsta.com/2020/07/Ppython-process.webp',
      // Add more image URLs here
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        String imageUrl = imageUrls[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageDetailView(
                  imageUrl: imageUrl,
                  onDownload: () => _downloadImage(imageUrl), // Fixed this line
                ),
              ),
            );
          },
          child: Card(
            elevation: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
              ),
            ),
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

  Future<void> _downloadImage(String url) async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final status = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;
    final status1 = Permission.photos.request();
    if (status.isGranted) {
      try {
        var response = await Dio().get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );

        // Save the image to the gallery
        final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 60,
          name: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image saved to gallery')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save image')),
          );
        }
      } catch (e) {
        print("Download error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading image: $e')),
        );
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Storage permission is required to save images.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              openAppSettings(); // Open app settings
            },
          ),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enable storage permission in settings.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              openAppSettings(); // Open app settings
            },
          ),
        ),
      );
    }
  }
}

class ImageDetailView extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDownload;

  const ImageDetailView({
    Key? key,
    required this.imageUrl,
    required this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: onDownload,
          ),
        ],
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        heroAttributes: const PhotoViewHeroAttributes(tag: "imageHero"),
      ),
    );
  }
}
