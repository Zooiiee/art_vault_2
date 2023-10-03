import 'dart:typed_data';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Data/data.dart';
import '../Widgets/SmallWidgets/DotIndicator.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Provider/AuthService.dart';
import 'dart:convert';

import 'api_config.dart';


class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class image{
  final int id;
  final Uint8List? imageBytes;

  image({
   required this.id,
    required this.imageBytes,
});
}


class Post {
  final int uid;
  final String title;
  final String details;
  final String createdAt;
  final String link;
  final Uint8List? imageBytes; // Add this field for the image data

  Post({
    required this.uid,
    required this.title,
    required this.details,
    required this.createdAt,
    required this.link,
    this.imageBytes, // Initialize it as null
  });
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{
  Map<String, dynamic> userData = {};
    List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
    AuthService authService = AuthService();
    authService.getToken().then((uid) {
      if (uid != null) {
        // Fetch user data using the UID
        fetchUserData(uid);
        // fetchImage(4);
      }
    });
  }

    Future<String?> getCurrentUserToken() async {
      final authService = AuthService();
      return authService.getToken();
    }


    Future<void> fetchPosts() async {
      final List<Post> fetchedPosts = [];

      try {
        final String? userToken = await getCurrentUserToken();

        if (userToken == null) {
          // Handle the case where the user is not logged in or the token is missing.
          return;
        }

        final response = await http.get(
          Uri.parse('${ApiConfig.baseUrl}/posts/$userToken'), // Pass the UID as a parameter
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          for (final post in data) {
            final uid = post['uid'];
            final title = post['title'];
            final details = post['details'];
            final createdAt = post['createdAt'];
            final link = post['link'];
            final imageBase64 = post['image']; // Assuming the image is returned as base64

            Uint8List? imageBytes;

            // Check if imageBase64 is not null and decode it
            if (imageBase64 != null) {
              final decodedBytes = base64Decode(imageBase64);
              imageBytes = Uint8List.fromList(decodedBytes);
            }

            final newPost = Post(
              uid: uid,
              title: title,
              details: details,
              createdAt: createdAt,
              link: link,
              imageBytes: imageBytes, // Assign the image data
            );

            fetchedPosts.add(newPost);
          }
        } else {
          print('Failed to load posts. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }

      setState(() {
        posts = fetchedPosts;
      });
    }


    // Future<void> fetchImage(int uid) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://192.168.1.36:5000/image/$uid'),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final dynamic data = json.decode(response.body);
  //
  //       if (data != null &&
  //           data is Map<String, dynamic> &&
  //           data.containsKey('image_blob')) {
  //         final assignmentData = data['image_blob'];
  //
  //
  //         final imageBase64 = assignmentData['image_blob']; // Get the base64-encoded image string
  //
  //         // Initialize imageBytes as null
  //         Uint8List? imageBytes;
  //
  //         if (imageBase64 != null) {
  //           // Decode the base64-encoded image string
  //           final decodedBytes = base64Decode(imageBase64);
  //           imageBytes = Uint8List.fromList(decodedBytes);
  //         }
  //
  //         setState(() {
  //           images= image(
  //             id: uid,
  //             imageBytes: imageBytes, // Store image data
  //           );
  //         });
  //       } else {
  //         print('Invalid JSON data received or missing "assignment" key.');
  //       }
  //     } else {
  //       print('Failed to load assignment details. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Future<void> fetchUserData(String uid) async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/userData/$uid'));

    if (response.statusCode == 200) {
      // User data retrieved successfully
      final fetchedData = jsonDecode(response.body);

      setState(() {
        userData = fetchedData;
      });
    } else if (response.statusCode == 404) {
      print('error');
      // User not found
      // Handle accordingly, e.g., show an error message or redirect to a login screen
    } else {
      print('error');
      // Error occurred while fetching user data
      // Handle the error, e.g., show an error message
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
        : Color(0xFF2F1602);

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(

        body: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
            ),
            // Curved Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 140, // Adjust the height as needed
                decoration: BoxDecoration(
                  color:themeProvider.isDarkModeEnabled
                        ? Color(0xFF52412E)
                        : Color(0xFFD9B588),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
              ),
            ),
            // Profile Image
            Positioned(
              top: 90, // Adjust the top position to align the image
              left: 0,
              right: 0,
              child: Center(
                child: Container(

                  width: 90, // Adjust the width and height as needed
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5.0,
                      ),
                    ],
                    image: DecorationImage(
                      image:userData['profilePicture'] != null?
                      NetworkImage(userData['profilePicture'] ??'')as ImageProvider<Object>
                          : AssetImage('assets/avatar.gif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            // Profile Information
            Positioned(
              top: 182, // Adjust the top position for the profile content
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    userData['name']?? '',
                    style: TextStyle(
                      fontSize: 24,
                      color: contentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '@${userData['username']}'?? '', // Add this line
                    style: TextStyle(
                      fontSize: 17,
                      color: contentColor.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCountText('123', 'Posts'),
                      _buildCountText('456', 'Followers'),
                      _buildCountText('789', 'Following'),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Add more profile information here
                  // Like user details, posts, etc.
                ],
              ),
            ),
            // Tab Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.sizeOf(context).height-352,
                color: Colors.transparent,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'Gallery',),
                        Tab(text: 'Vault'),
                      ],
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 1,
                      indicator: DotTabIndicator(color: contentColor, radius: 4),
                      tabAlignment: TabAlignment.center,
                      indicatorColor: contentColor,
                      labelColor: contentColor,
                     // labelPadding: EdgeInsets.symmetric(horizontal: 25),
                      labelStyle:  GoogleFonts.philosopher(
                        textStyle: TextStyle(
                          fontSize: 18, // Adjust the font size as needed
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                      unselectedLabelColor: themeProvider.isDarkModeEnabled
                          ? Color(0xFFEbd2a9).withOpacity(0.5)
                          : Color(0xFF231A12).withOpacity(0.5),
                      //unselectedLabelColor: Colors.black,
                    ),
                    _buildTabContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountText(String count, String label) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);

    final contentColor = themeProvider.isDarkModeEnabled
        ? Color(0xFFEbd2a9) // Very Very Dark Brown
        : Color(0xFF2F1602);
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: contentColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: contentColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent() {

    final themeProvider = Provider.of<ThemeProvider>(context);

    final contentColor = themeProvider.isDarkModeEnabled
        ? Color(0xFFEbd2a9) // Very Very Dark Brown
        : Color(0xFF2F1602);
    return Expanded(
      child: TabBarView(
        physics: BouncingScrollPhysics(),
        children: [
          // Content for Gallery tab
          // You can replace this with your desired content
          Expanded(

            child: posts.isNotEmpty
                ? StaggeredGridView.countBuilder(
              crossAxisCount: 2, // Number of columns
              itemCount: posts.length, // Use the number of posts you have
              itemBuilder: (BuildContext context, int index) {
                final post = posts[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Add rounded corners
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // Add rounded corners
                    child: Image.memory(
                      post.imageBytes!,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count(1, index.isEven ? 1.4 : 1.9), // Adjust tile heights as needed
              mainAxisSpacing: 0.0, // Vertical spacing between items
              crossAxisSpacing: 0.0, // Horizontal spacing between items
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/lotties/golden-loading.json'), // Replace with your Lottie animation asset
                SizedBox(height: 20),
                Text(
                  'No posts yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

          ),

          // Content for Vault tab
          GridView.builder(
            shrinkWrap: true,
            itemCount: collectionNames.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns in the grid
              mainAxisSpacing: 10.0, // Spacing between grid rows
              crossAxisSpacing: 0.0, // Spacing between grid items
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Wrap the staggered grid in an Expanded widget to force it to fit within the available space
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: double.minPositive,
                        child: StaggeredGridView.countBuilder(
                          physics: NeverScrollableScrollPhysics(), // Disable scrolling
                          crossAxisCount: 2,
                          mainAxisSpacing: 2.0,
                          crossAxisSpacing: 2.0,
                          itemCount: 3, // Number of images in each collection
                          itemBuilder: (BuildContext context, int subIndex) {
                            double itemHeight = subIndex == 0 ? 300.0 : 150.0; // First image is double the height
                            return Container(
                              height: itemHeight+65,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: AssetImage(collectionImages[index][subIndex]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (int subIndex) {
                            return StaggeredTile.count(
                              1, // Width factor
                              subIndex == 0 ? 2 : 1, // Height factor (first image is double)
                            );
                          },
                        ),
                      ),
                    ),
                    // Add a space between the collection and the title
                    SizedBox(height: 10.0),
                    // Add the collection text below the container
                    Text(
                      'Collection ${index + 1}', // Add the collection name or text here
                      style: TextStyle(
                        fontSize: 16,
                        color: contentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

              );
            },

          )


        ],

      ),
    );
  }
}
