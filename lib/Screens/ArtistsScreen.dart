import 'package:art_vault_2/Screens/ArtistDetailScreen.dart';
import 'package:art_vault_2/Widgets/StaggeredGridViewArtists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart'; // Import your theme provider
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'SearchScreen.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'api_config.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';

class ArtistsScreen extends StatefulWidget {
  @override
  _ArtistsScreenState createState() => _ArtistsScreenState();
}

class _ArtistsScreenState extends State<ArtistsScreen> {
  bool isLoading = true;

  List<dynamic> artists = [];
  @override
  void initState() {
    super.initState();
    fetchArtists();
  }

  Future<void> fetchArtists() async {
    final apiUrl = Uri.parse('${ApiConfig.baseUrl}/artists'); // Replace with your server URL

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          artists = data;
        });
      } else {
        // Handle error cases
        print('Failed to fetch artists: ${response.statusCode}');
      }
    } catch (error) {
      print('HTTP request error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageAssets = <String>[
      'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
      'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
      'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
      'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
      'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
      'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
    ];
    final names = <String>[
      'assets/fesddddddddddddcat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
      'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
      'assets/cat.jpeg', 'vdfvd/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
      'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
      'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/vvsdvsdvsdv.jpg', 'assets/appImages/artworks1.jpeg',
      'assets/cat.jpeg', 'assets/cat2.jpeg', 'assets/cat3.jpg', 'assets/appImages/artworks1.jpeg',
    ];
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // Add a SliverAppBar with an image
          SliverAppBar(
            iconTheme: IconThemeData(color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12)),
            backgroundColor:  backgroundColor,

            title: Text('Artists',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12),),),
            expandedHeight: 104.0, // Set the expanded height as needed
            floating: true, // Set to true if you want the app bar to appear when scrolling up
            pinned: true, // Set to true if you want the app bar to always be visible
            bottom: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false, // Remove back button
              titleSpacing:10,
              title:  ClipRRect(
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
                    height: 43,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            'assets/icons/search_ani.gif', // Replace with the actual path to your vault.png image
                            width: 35, // Adjust the width as needed
                            height: 60, // Adjust the height as needed


                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Search for Artists Eg. Farida Khalo',
                            style: TextStyle(color: Colors.grey,fontSize: 16),
                          ),
                        ),

                      ],

                    ),

                  ),

                ),
              ),

            ),

          ),

          SliverToBoxAdapter(
            child :
            Container(
              height: MediaQuery.sizeOf(context).height-140,
              color: backgroundColor,
              child: StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(4),
                mainAxisSpacing: 8,
                crossAxisSpacing: 4,
                crossAxisCount: 2,
                itemCount: artists.length,
                staggeredTileBuilder: (int index) => index % 2 == 0
                    ? StaggeredTile.count(1, 2)
                    : StaggeredTile.count(1, 1.5),
                itemBuilder: (BuildContext context, int index) =>  GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePage1(
                          imageUrl: artists[index],
                          index: index,
                        ),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistDetailScreen(artistId: artists[index]['artistId'])
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),

                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90),
                        child: Stack(
                          fit: StackFit.expand,
                          children:[
                            CachedNetworkImage(
                              imageUrl: artists[index]['artistUrl'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>Lottie.asset(
                              'assets/pc.json', // Replace with your Lottie animation file path
                              width: 50, // Adjust the width as needed
                              height: 50,
                              ), // Optional loading indicator
                              errorWidget: (context, url, error) => Icon(Icons.error), // Optional error widget
                            ),

                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: const [0.6, 0.95],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              left: 28,
                              right: 18,
                              child: Text(
                                artists[index]['artistName'], // Display the corresponding name
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]
                        ),

                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
