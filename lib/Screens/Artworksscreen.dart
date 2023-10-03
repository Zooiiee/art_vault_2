import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'ArtworkDetailScreen.dart';
import 'SearchScreen.dart';
import 'api_config.dart';

class ArtworksScreen extends StatefulWidget {
  @override
  State<ArtworksScreen> createState() => _ArtworksScreenState();
}

class _ArtworksScreenState extends State<ArtworksScreen> {
  String selectedDropdownValue = 'All'; // Added the selectedDropdownValue variable
  bool isGridSelected = true;
  bool isSecondIconSelected = false;
  bool isThirdIconSelected = false;
  List<dynamic> artworks = [];



  @override
  void initState() {
    super.initState();
    fetchArtworks();
  }

  Future<void> fetchArtworks() async {
    final apiUrl = Uri.parse('${ApiConfig.baseUrl}/allartworks'); // Replace with your server URL

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          artworks = data;
        });
      } else {
        // Handle error cases
        print('Failed to fetch artworks: ${response.statusCode}');
      }
    } catch (error) {
      print('HTTP request error: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);

    final contentColor = themeProvider.isDarkModeEnabled
        ?  Color(0xFF52412E)// Very Very Dark Brown
        : Color(0xFFF5F5DC);

    final cc2 = themeProvider.isDarkModeEnabled
        ? Color(0xFFEbd2a9) // Very Very Dark Brown
        : Color(0xFF2F1602);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkModeEnabled
            ? Color(0xFF231A12) // Very Very Dark Brown
            : Color(0xFFEbd2a9),
        elevation: 0,

        title: Text(
          'Gallery',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGridSelected = true;
                isSecondIconSelected = false;
                isThirdIconSelected = false;
              });
            },
            icon: Container(
              decoration: BoxDecoration(
                border: isGridSelected
                    ? Border.all(
                  color: Colors.orangeAccent, // Choose the color for the selected icon
                  width: 2.0, // Adjust the border width as needed
                )
                    : null, // No border for unselected icons
                borderRadius: BorderRadius.circular(0), // Adjust the border radius as needed
              ),
              child: Image.asset(
                'assets/icons/grid1.png',
                width: 22,
                height: 22,
                color: cc2,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isGridSelected = false;
                isSecondIconSelected = true;
                isThirdIconSelected = false;
              });
            },
            icon: Container(
              decoration: BoxDecoration(
                border: isSecondIconSelected
                    ? Border.all(
                  color: Colors.green, // Choose the color for the selected icon
                  width: 2.0, // Adjust the border width as needed
                )
                    : null, // No border for unselected icons
                borderRadius: BorderRadius.circular(5), // Adjust the border radius as needed
              ),
              child: Image.asset(
                'assets/icons/grid2.png',
                width: 22,
                height: 22,
                color: cc2,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isGridSelected = false;
                isSecondIconSelected = false;
                isThirdIconSelected = true;
              });
            },
            icon: Container(
              decoration: BoxDecoration(
                border: isThirdIconSelected
                    ? Border.all(
                  color: Colors.redAccent, // Choose the color for the selected icon
                  width: 2.0, // Adjust the border width as needed
                )
                    : null, // No border for unselected icons
                borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
              ),
              child: Image.asset(
                'assets/icons/grid3.png',
                width: 28,
                height: 28,
                color: cc2,
              ),
            ),
          ),
        ],
        iconTheme: IconThemeData(
            color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12)
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2,right: 2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset(
                          'assets/icons/search_ani.gif', // Replace with the actual path to your vault.png image
                          width: 35, // Adjust the width as needed
                          height: 55, // Adjust the height as needed


                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Search for Artworks eg. Irisis',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButton<String>(

                  dropdownColor: contentColor,
                  value: selectedDropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDropdownValue = newValue!;
                    });
                  },

                  items: <String>['All', 'Art Movements 1', 'Art Movements 2', 'Art Movements 3', 'Art Movements 4', 'Art Movements 5', 'Art Movements 6']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(

                        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Text(
                          value,
                          style: GoogleFonts.philosopher(
                            textStyle: TextStyle(
                              color: cc2, // Adjust text color as needed
                              fontSize: 18, // Adjust text size as needed
                              fontWeight: FontWeight.bold, // Adjust text style as needed
                              decoration: TextDecoration.none, // Remove the underline
                              fontStyle: FontStyle.italic, // Apply italic font style
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  style: TextStyle(
                    color: cc2, // Customize the text color
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down, // Customize the dropdown icon
                    color: contentColor, // Customize the icon color
                  ),
                  iconSize: 36, // Customize the icon size
                  underline: Container(
                    height: 1,
                    color: cc2, // Customize the underline color
                  ),
                  elevation: 60, // Remove the shadow
                  isDense: false, // Add padding around the dropdown
                  borderRadius: BorderRadius.circular(10), // Customize the border radius
                ),
              ],
            ),
          ),

          Expanded(

            child: isThirdIconSelected
                ? ListView.builder(
              itemCount: artworks.length, // Customize the number of items
              itemBuilder: (context, index) {
                final artworkUrl = artworks[index]['artworkUrl']; // Assuming artworkUrl is a key in the artwork object
                final title = artworks[index]['title']; // Assuming artworkUrl is a key in the artwork object
                final artist = artworks[index]['artist'];
                final artworkId = artworks[index]['artworkId'];


                return CustomCard(
                  imagePath: artworkUrl,
                  title: title,
                  subtitle: artist,
                  artworkId: artworkId,
                );
              },
            )
                : isSecondIconSelected
                ? GlowingContainer(artworkUrls: artworks )
                : isGridSelected
                ? StaggeredGridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 3,
              crossAxisSpacing: 2,
              staggeredTiles: List.generate(
                artworks.length * 4,
                    (index) {
                  if (index % 6 == 0) {
                    // Create larger tiles with stretched height for every 6th item
                    return StaggeredTile.count(2, 4); // Increase the height value (e.g., from 2 to 4)
                  } else if (index % 3 == 0) {
                    // Create medium-sized tiles with stretched height for every 3rd item
                    return StaggeredTile.count(4, 3); // Increase the height value (e.g., from 2 to 3)
                  } else {
                    // Create small tiles with stretched height for the rest
                    return StaggeredTile.count(2, 2); // Increase the height value (e.g., from 1 to 2)
                  }
                },
              ),
              children: artworks.map((artworkUrl) {
                return _GridTileWidget(artworkData: artworkUrl);
              }).toList(),
            )
                : Container(), // Empty container as a placeholder
          ),
        ],
      ),
    );
  }
}

// GRID 1
class _GridTileWidget extends StatelessWidget {
  final artworkData;


  const _GridTileWidget({required this.artworkData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ArtworkDetailScreen(artworkId: artworkData['artworkId'],)),);
      },
      child: Card(
        color: Color(0xFF52412E),
        child: Image.network(
          artworkData['artworkUrl'],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// GRID 2
class GlowingContainer extends StatelessWidget {
  final artworkUrls; // Add this parameter

  GlowingContainer({required this.artworkUrls});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          itemCount: artworkUrls.length, // Use the length of artworkUrls
          itemBuilder: (BuildContext context, int index) {
            final artworkUrl = artworkUrls[index]['artworkUrl'];
            final artworkId = artworkUrls[index]['artworkId'];

            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ArtworkDetailScreen(artworkId: artworkId),),);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.primaries[index % Colors.primaries.length],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.primaries[index % Colors.primaries.length]
                          .withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    artworkUrl,
                    fit: BoxFit.cover, // Adjust the image fit as needed
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 10.0,
        ),
      ),
    );
  }
}

// GRID 3
class CustomCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final int artworkId;

  CustomCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.artworkId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ArtworkDetailScreen(artworkId: artworkId),),);
          },
          child: Container(
            height: 300, // Adjust the height of the card/image
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.70, 0.95],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color:Color(0xFFF5F5DC),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Color(0xFFF5F5DC),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

