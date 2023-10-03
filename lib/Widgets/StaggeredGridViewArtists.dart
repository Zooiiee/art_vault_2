import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart'; // Import your theme provider


class StaggeredArtists extends StatelessWidget {
  final imageAssets = <String>[
    'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg', // Add your image asset paths here
  ];

  final bool isLoading = false; // Set to true to display loading animation

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    return Container(
      height: MediaQuery.sizeOf(context).height,
      color: backgroundColor,
      child: StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(15),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        crossAxisCount: 2,
        itemCount: imageAssets.length,
        staggeredTileBuilder: (int index) => index % 2 == 0
            ? StaggeredTile.count(1, 2)
            : StaggeredTile.count(1, 1.5),
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImagePage1(
                  imageUrl: imageAssets[index],
                  index: index,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                imageAssets[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePage1 extends StatelessWidget {
  final String imageUrl;
  final int index;

  ImagePage1({required this.imageUrl, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Detail'),
      ),
      body: Center(
        child: Image.asset(imageUrl),
      ),
    );
  }
}
