import 'package:art_vault_2/Data/data.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:art_vault_2/Widgets/ClippedBox.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'api_config.dart';


class ArtworkDetailScreen extends StatefulWidget {
  final int artworkId;

  ArtworkDetailScreen({required this.artworkId});
  @override
  State<ArtworkDetailScreen> createState() => _ArtworkDetailScreenState();
}

class _ArtworkDetailScreenState extends State<ArtworkDetailScreen> {

  Map<String, dynamic>? artworkDetails; // Store fetched artwork details as nullable

  @override
  void initState() {
    super.initState();
    fetchArtworkDetails();
  }

  Future<void> fetchArtworkDetails() async {
    final apiUrl = Uri.parse('${ApiConfig.baseUrl}/artworks/${widget.artworkId}'); //192.168.1.36

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          artworkDetails = data;

        });
      } else {
        // Handle error cases
        print('Failed to fetch artwork details: ${response.statusCode}');
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
        ? Color(0xFFEbd2a9) // Very Very Dark Brown
        : Color(0xFF473B2B);
    final cc2 = themeProvider.isDarkModeEnabled
        ? Color(0xFFF5F5DC) // Very Very Dark Brown
        : Color(0xFF473B2B).withOpacity(0.9);


    return SingleChildScrollView(

      child: Column(
        children: [
          if (artworkDetails != null)
            Stack(
              children: [
                _ActivityImage(artwork: artworkDetails),
                _ArtistImage(artistName: artworkDetails?['artist']), // Remove the null check
              ],
            )
          else
            Container(
              color: backgroundColor,
              child: Center(
                child: Lottie.asset(
                  'assets/lotties/golden-loading.json',
                  width: 400,
                  height: 900,
                ),
              ),
            ),
          if (artworkDetails != null)
            _ActivityInformation(artwork: artworkDetails!)
          else
            Center(
              child: Lottie.asset(
                'assets/lotties/golden-loading.json', // Replace with your Lottie animation file path
                width: 400,
                height: 900,
              ),
            ),
        ],
      ),
    );
  }
}


class _ActivityImage extends StatelessWidget {
  const _ActivityImage({
    Key? key,
    required this.artwork,
  }) : super(key: key);

  final Map<String, dynamic>? artwork;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    final contentColor = themeProvider.isDarkModeEnabled
        ? Color(0xFFEbd2a9) // Very Very Dark Brown
        : Color(0xFF473B2B);
    final cc2 = themeProvider.isDarkModeEnabled
        ? Color(0xFFF5F5DC) // Very Very Dark Brown
        : Color(0xFF473B2B).withOpacity(0.9);
    final artworkId = artwork?['artworkId'];
    final artworkTitle = artwork?['title'];
    final artist = artwork?['artist'];
    final imageUrl = artwork?['artworkUrl'];

    if (artworkId != null && imageUrl != null) {
      return Stack(
        children: [
          Container(
            color: backgroundColor,
            child: const ClippedContainer(height: 744),
          ),
          Hero(
            tag: '$artworkId $imageUrl',
            child: ClippedContainer(imageUrl: imageUrl),
          ),
          if (artworkTitle!= null)
            Positioned(
              bottom: 170, // Adjust the positioning as needed
              left: 34  ,

              child: Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 10),

                child: Text(
                  artworkTitle,
                  style: GoogleFonts.philosopher(
                    textStyle: TextStyle(
                      color: Colors.white, // Adjust text color as needed
                      fontSize: 30, // Adjust text size as needed
                      fontWeight: FontWeight.bold, // Adjust text style as needed
                      decoration: TextDecoration.none, // Remove the underline
                      fontStyle: FontStyle.italic, // Apply italic font style
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          if (artist!= null)
            Positioned(
              bottom: 28, // Adjust the positioning as needed
              left: 142  , // Adjust the positioning as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                children: [
                  Text(
                    artist.toUpperCase(),
                    style: GoogleFonts.philosopher(
                      textStyle: TextStyle(
                        color: contentColor, // Adjust text color as needed
                        fontSize: 20, // Adjust text size as needed
                        fontWeight: FontWeight.normal, // Adjust text style as needed
                        decoration: TextDecoration.none, // Remove the underline
                        fontStyle: FontStyle.italic, // Apply italic font style
                      ),
                    ),
                  ),
                  SizedBox(height: 1,),
                  Text(
                    "Artist", // Your additional text here
                    style: GoogleFonts.philosopher(
                      textStyle: TextStyle(
                        color: cc2, // Adjust text color as needed
                        fontSize: 16, // Adjust text size as needed
                        fontWeight: FontWeight.normal, // Adjust text style as needed
                        decoration: TextDecoration.none, // Remove the underline
                        fontStyle: FontStyle.italic, // Apply italic font style
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    } else {
      // Handle the case when artwork data is not available
      return Center(
        child: Lottie.asset(
          'assets/lotties/golden-loading.json', // Replace with your Lottie animation file path
          width: 400,
          height: 900,
        ),
      ); // Return an empty container or placeholder
    }
  }
}


class _ActivityInformation extends StatefulWidget {

  const _ActivityInformation({
    Key? key,
    required this.artwork,
  }) : super(key: key);

  final artwork;

  @override
  State<_ActivityInformation> createState() => _ActivityInformationState();
}

class _ActivityInformationState extends State<_ActivityInformation> {
  List<dynamic> relatedArtworks = [];

  @override
  void initState() {
    super.initState();
    fetchRelatedArtworks();
  }

  Future<void> fetchRelatedArtworks() async {
    final Uri apiUrl = Uri.parse('${ApiConfig.baseUrl}/relatedArtworks'); // Replace with your Node.js server URL

    final Map<String, dynamic> requestData = {
      'artMovement': widget.artwork['artMovement'],
      'genre': widget.artwork['genre'],
    };

    try {
      final http.Response response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          relatedArtworks = data;

        });
        print('Related Artworks: $data');
      } else {
        // Handle error
        print('Failed to fetch related artworks: ${response.statusCode}');
        print('Error message: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    final contentColor = themeProvider.isDarkModeEnabled
        ? Color(0xFFEbd2a9) // Very Very Dark Brown
        : Color(0xFF473B2B);
    final cc2 = themeProvider.isDarkModeEnabled
        ? Color(0xFFF5F5DC) // Very Very Dark Brown
        : Color(0xFF473B2B).withOpacity(0.9);

    if (widget.artwork == null) {
      // Display a Lottie animation as a loading indicator
      return Center(
        child: Lottie.asset(
          'assets/lotties/golden-loading.json',
          width: 400,
          height: 900,
        ),
      );
    }
    else {
      return Material(
        color: backgroundColor,
        child: Column(
          children: [
            Container(
              color: backgroundColor,
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Created : ",
                            style: TextStyle(color: contentColor.withOpacity(0.7),
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Expanded(
                          child: Text(widget.artwork['created'], style: TextStyle(
                              color:cc2, fontSize: 18)),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Art Movement : ",
                            style: TextStyle(color: contentColor.withOpacity(0.7),
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Expanded(
                          child: Text(widget.artwork['artMovement'],
                              style: TextStyle(color: cc2, fontSize: 18)),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Medium : ",
                            style: TextStyle(color: contentColor.withOpacity(0.7),
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Expanded(
                          child: Text(widget.artwork['medium'], style: TextStyle(
                              color: cc2, fontSize: 18)),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Genre : ",
                            style: TextStyle(color: contentColor.withOpacity(0.7),
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Expanded(
                          child: Text(widget.artwork['genre'], style: TextStyle(
                              color: cc2, fontSize: 18)),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Current Status: ",
                            style: TextStyle(color: contentColor.withOpacity(0.7),
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.artwork['status'],
                            style: TextStyle(color: cc2, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "About",
                            style: TextStyle(color: contentColor.withOpacity(0.8),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),


                      ],
                    ),
                    SizedBox(height: 30),
                    ExpandableText(

                      text : widget.artwork['details'],
                      maxLines: 5,
                    ),
                    SizedBox(height: 40),
                    Text("Related Artworks", style: TextStyle(
                        color: contentColor.withOpacity(0.9),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    // Add your artwork widgets here

                  ],
                ),
              ),
            ),
            Container(
              height: 420, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: relatedArtworks.length, // Replace with the actual number of related artworks
                itemBuilder: (BuildContext context, int index) {
                  final relatedArtwork = relatedArtworks[index]; // Get related artwork data

                  return Padding(
                    padding: const EdgeInsets.only(right: 8,left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Display related artwork image (You can use Image.network or other widgets)
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ArtworkDetailScreen(artworkId: relatedArtwork['artworkId'],)),);
                          },
                          child: Image.network(
                            relatedArtwork['artworkUrl'],
                            width: 250, // Set the width as needed
                            height: 340, // Set the height as needed
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          relatedArtwork['title'],
                          style: TextStyle(
                            color: cc2,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          relatedArtwork['artist'],
                          style: TextStyle(
                            color: contentColor.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}


class _ArtistImage extends StatefulWidget {
  final String artistName; // Add this parameter to accept the artist's name
  _ArtistImage({required this.artistName});

  @override
  _ArtistImageState createState() => _ArtistImageState();
}

class _ArtistImageState extends State<_ArtistImage> {
  String? artistImageUrl; // Store the artist's image URL

  @override
  void initState() {
    super.initState();
    fetchArtistImage();
  }

  Future<void> fetchArtistImage() async {
    final apiUrl =
    Uri.parse('${ApiConfig.baseUrl}/artists/image/${widget.artistName}');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          artistImageUrl = data['artistImage'];
        });
      } else {
        // Handle error cases
        print('Failed to fetch artist image: ${response.statusCode}');
      }
    } catch (error) {
      print('HTTP request error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: artistImageUrl != null
            ? Image.network(
          artistImageUrl!, // Use the artist's image URL
          width: 115, // Adjust the width as needed
          height: 150, // Adjust the height as needed
          fit: BoxFit.cover,
        )
            : Lottie.asset(
          'assets/lotties/placeholder.json', // Replace with your Lottie animation file path
          width: 115,
          height: 150,
        ), // Display Lottie placeholder if image URL is not available
      ),
    );
  }
}



class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  ExpandableText({
    required this.text,
    required this.maxLines,
  });

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final contentColor = themeProvider.isDarkModeEnabled
        ? Color(0xFFF5F5DC)
        : Color(0xFF2F1602);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: isExpanded ? null : widget.maxLines,
          style: TextStyle(
            color:  Color(0xFFF5F5DC),
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? 'Show Less' : 'Read More',
            style: TextStyle(
                fontSize: 17,
                height: 1.4,
                color: contentColor,
                // You can use a different color if you prefer
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }
}
