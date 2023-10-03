import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:art_vault_2/Data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'api_config.dart';
import 'ArtworkDetailScreen.dart';



class ArtistDetailScreen extends StatefulWidget {
  late final int artistId;


  ArtistDetailScreen({required this.artistId});
  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  bool isLoading = true; // Track loading state
  List<dynamic> relatedArtworks = [];
  Map<String, dynamic> ? artistDetails ; // Initialize as an empty map

  @override
  void initState() {
    super.initState();
    fetchArtistDetails(widget.artistId);
  }

  Future<void> fetchArtistDetails(int artistId) async {
    final apiUrl = Uri.parse('${ApiConfig.baseUrl}/artists/$artistId'); // Replace with your server URL

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          artistDetails = data;
          isLoading = false;
        });

      } else {
        setState(() {
          isLoading = false; // Error occurred while fetching data
        });
        print('Failed to fetch artist details: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Error occurred while fetching data
      });
      print('HTTP request error: $error');
    }
  }
  Future<void> fetchRelatedArtworks() async {
    final Uri apiUrl = Uri.parse('${ApiConfig.baseUrl}/RelatedArtworks'); // Replace with your Node.js server URL
    final Map<String, dynamic> requestData = {
      'artMovement': artistDetails?['artMovement'],
      'genre': artistDetails?['genre'],
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

    return Scaffold(
      body: isLoading
          ? Container(
        color: Color(0xFF473B2B),
        child: Center(
          child: Lottie.asset(
            'assets/lotties/load2.json', // Replace with the path to your Lottie animation file
            width: 400, // Adjust the width and height as needed
            height: 800,
          ),
        ),
      )
          : Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color:Color(0xFF231A12) ,
                  width: MediaQuery.sizeOf(context).width, // Adjust the width as needed
                  height: 564, // Adjust the height as needed
                  child: Stack(

                    children: [
                      Center(
                        child: Container(
                          width: 280, // Adjust the width as needed
                          height: 370, // Adjust the height as needed
                          decoration:BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                artistDetails?['artistUrl']
                              ),
                              fit: BoxFit.cover,
                            ),
                            color:Color(0xFF231A12) ,// Background color
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(150.0), // Fully rounded top border
                              bottom: Radius.zero,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFA86F11), // Gold color for the glow
                                spreadRadius: 10,
                                blurRadius: 70,
                                offset: Offset(0, 0),
                              ),

                            ],
                          ),

                        ),

                      ),
                      Positioned(
                        top: 85, // Adjust the position as needed
                        left: 40, // Adjust the position as needed
                        child: Container(
                          width: 280, // Adjust the width as needed
                          height: 370, // Adjust the height as needed
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(200.0), // Adjust to match the top border of the container
                              bottom: Radius.zero, // Straight bottom border
                            ),
                            border: Border.all(
                              color: Color(0xFFA86F11), // Border color
                              width: 1.5, // Border width
                            ),
                          ),
                        ),
                      ),
                      // Text and information
                     Positioned(
                        bottom: 65,
                        left: 10,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                             constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40),
                            child: Text(
                              artistDetails?['artistName'],
                                  style: GoogleFonts.philosopher(
                                    textStyle: TextStyle(
                                      color: Color(0xFFEbd2a9), // Adjust text color as needed
                                      fontSize: 42, // Adjust text size as needed
                                      fontWeight: FontWeight.normal, // Adjust text style as needed
                                      decoration: TextDecoration.none, // Remove the underline
                                      fontStyle: FontStyle.italic, // Apply italic font style
                                    ),
                                  ),
                                ),
                          ),


                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        left: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // SizedBox(height: 10,),
                              Text(
                              artistDetails?['dob'],
                                style: GoogleFonts.philosopher(
                                  textStyle: TextStyle(
                                    color: Color(0xFFF5F5DC), // Adjust text color as needed
                                    fontSize: 20, // Adjust text size as needed
                                    fontWeight: FontWeight.normal, // Adjust text style as needed
                                    decoration: TextDecoration.none, // Remove the underline
                                    fontStyle: FontStyle.italic, // Apply italic font style
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 48,
                       left: 18,
                       child: Icon(Icons.arrow_back,color: Color(0xFFA86F11),)
                      ),
                    ],
                  ),
                ),

                // Rest of the content outside the stack
                SingleChildScrollView(

                  child: Container(
                    color: Color(0xFF231A12),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Flexible(
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              //color:Color(0xFF231A12) ,
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 28),
                              child:ExpandableText(
                                text : artistDetails?['details'],
                                maxLines: 6, // Set the maximum number of lines
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Nationality',
                              style: GoogleFonts.philosopher(
                                textStyle: TextStyle(
                                  color: Color(0xFFEbd2a9), // Adjust text color as needed
                                  fontSize: 20, // Adjust text size as needed
                                  fontWeight: FontWeight.bold, // Adjust text style as needed
                                  decoration: TextDecoration.none, // Remove the underline
                                  fontStyle: FontStyle.italic, // Apply italic font style
                                ),
                              ),
                            ),
                            Text(
                              artistDetails?['nationality'],
                              style: GoogleFonts.philosopher(
                                textStyle: TextStyle(
                                  color: Color(0xFFF5F5DC), // Adjust text color as needed
                                  fontSize: 20, // Adjust text size as needed
                                  fontWeight: FontWeight.normal, // Adjust text style as needed
                                  decoration: TextDecoration.none, // Remove the underline
                                  fontStyle: FontStyle.italic, // Apply italic font style
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Art Movement',
                              style: GoogleFonts.philosopher(
                                textStyle: TextStyle(
                                  color:Color(0xFFEbd2a9), // Adjust text color as needed
                                  fontSize: 20, // Adjust text size as needed
                                  fontWeight: FontWeight.bold, // Adjust text style as needed
                                  decoration: TextDecoration.none, // Remove the underline
                                  fontStyle: FontStyle.italic, // Apply italic font style
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                             Text(
                               artistDetails?['period'],
                              style: GoogleFonts.philosopher(
                                textStyle: TextStyle(
                                  color: Color(0xFFF5F5DC), // Adjust text color as needed
                                  fontSize: 20, // Adjust text size as needed
                                  fontWeight: FontWeight.normal, // Adjust text style as needed
                                  decoration: TextDecoration.none, // Remove the underline
                                  fontStyle: FontStyle.italic, // Apply italic font style
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'Discover this artist',
                              style: GoogleFonts.philosopher(
                                textStyle: TextStyle(
                                  color: Color(0xFFEbd2a9), // Adjust text color as needed
                                  fontSize: 20, // Adjust text size as needed
                                  fontWeight: FontWeight.bold, // Adjust text style as needed
                                  decoration: TextDecoration.none, // Remove the underline
                                  fontStyle: FontStyle.italic, // Apply italic font style
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              height: 420,
                              width: double.maxFinite,
                              child: isLoading || relatedArtworks.isEmpty
                                  ? ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Color(0xFF231A14),
                                    BlendMode.color,
                                  ),
                                  child: Lottie.asset('assets/lotties/load2.json',  width : 500,height: 350,)) // Display Lottie animation
                                  : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: relatedArtworks.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final relatedArtwork = relatedArtworks[index]; // Get related artwork data

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8, left: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        // Display related artwork image (You can use Image.network or other widgets)
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ArtworkDetailScreen(artworkId: relatedArtwork['artworkId']),
                                              ),
                                            );
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
                                            color: Color(0xFFEbd2a9),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          relatedArtwork['artist'],
                                          style: TextStyle(
                                            color: Color(0xFFEbd2a9).withOpacity(0.8),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
              fontSize: 16,
                

                color: Color(0xFFEbd2a9) ,
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
