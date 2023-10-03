import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedCardScroll extends StatefulWidget {
  @override
  _AnimatedCardScrollState createState() => _AnimatedCardScrollState();
}

class _AnimatedCardScrollState extends State<AnimatedCardScroll> {
  late PageController _pageController;
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 1,
      viewportFraction: 1,
    )..addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500, // Adjust the height as needed
      child: PageView.builder(
        controller: _pageController,
        itemCount: artworkItems.length, // Replace with the actual number of items
        itemBuilder: (context, index) {
          return Transform.scale(
            scale: max(0.85, 1 - (index - currentPage).abs() * 0.15),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(artworkItems[index].imagePath), // Provide the image path
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          artworkItems[index].title, // Title of the artwork
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Replace this with your actual artwork items data
List<ArtworkItem> artworkItems = [
  ArtworkItem(
    imagePath: 'assets/cat.jpeg',
    title: 'Artwork 1',
  ),
  ArtworkItem(
    imagePath: 'assets/cat.jpeg',
    title: 'Artwork 2',
  ),
  ArtworkItem(
    imagePath: 'assets/cat.jpeg',
    title: 'Artwork 2',
  ),
  ArtworkItem(
    imagePath: 'assets/cat.jpeg',
    title: 'Artwork 2',
  ),
  ArtworkItem(
    imagePath: 'assets/cat.jpeg',
    title: 'Artwork 2',
  ),
  ArtworkItem(
    imagePath: 'assets/cat.jpeg',
    title: 'Artwork 2',
  ),
  ArtworkItem(
    imagePath: 'assets/cat.jpeg',
    title: 'Artwork 2',
  ),
  // Add more artwork items
];

class ArtworkItem {
  final String imagePath;
  final String title;

  ArtworkItem({required this.imagePath, required this.title});
}