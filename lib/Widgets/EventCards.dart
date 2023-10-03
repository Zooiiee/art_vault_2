import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final int index;
  final List<String> mediaItems = [
    'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/Reading.jfif', 'assets/Pearl.jfif', 'assets/cat.jpeg',
  ];
  EventCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 250, // Adjust the width as needed
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black26
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                mediaItems[index], // Use your image path
                width: 270,
                height: 350,
                fit: BoxFit.fill,
              ),
            ),
            Text(
              'Artwork ${index + 1}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
