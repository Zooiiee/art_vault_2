import 'dart:convert';
import 'dart:typed_data';
import 'package:art_vault_2/Screens/VideoFeed.dart';
import 'package:http/http.dart' as http;
import 'package:art_vault_2/Screens/CreatePostScreen.dart';
import 'package:art_vault_2/Screens/Posts.dart';
import 'package:lottie/lottie.dart';
import 'package:art_vault_2/Screens/SearchScreen.dart';
import 'package:art_vault_2/Screens/SearchScreenForSM.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart'; // Import your theme provider
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart'; // Import the package

import 'package:cached_network_image/cached_network_image.dart';
import '../Provider/AuthService.dart';
import 'ImageSelectionScreen.dart';
import 'api_config.dart';

// class Post {
//   final int uid;
//   final String title;
//   final String details;
//   final String createdAt;
//   final String link;
//   final Uint8List? imageBytes; // Add this field for the image data
//
//   Post({
//     required this.uid,
//     required this.title,
//     required this.details,
//     required this.createdAt,
//     required this.link,
//     this.imageBytes, // Initialize it as null
//   });
// }


class Post {
  final int uid;
  final String title;
  final String details;
  final String createdAt;
  final String link;
  final String imageUrl; // Add this field for the image URL

  Post({
    required this.uid,
    required this.title,
    required this.details,
    required this.createdAt,
    required this.link,
    required this.imageUrl, // Initialize it with the image URL
  });
}



class SocialsScreen extends StatefulWidget {
  @override
  State<SocialsScreen> createState() => _SocialsScreenState();
}
class _SocialsScreenState extends State<SocialsScreen> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled ? Color(0xFF231A12) : Color(0xFFEbd2a9);

    final contentColor = themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9) : Color(0xFF2F1602);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 48,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ArtVault',style: TextStyle(color: contentColor,fontSize:26),),
            Row(
              children: [
                GestureDetector(
                    onTap: (){
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                              color: Colors.transparent,
                              child: CustomBottomSheet());
                        },
                      );
                    },
                    child: Icon(Icons.add,color: contentColor,size: 32,)),
                SizedBox(width: 10),
                GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreenSM()));
                    },
                    child: Icon(Icons.search,color: contentColor,size: 28,)),
              ],
            ),

          ],
        ),
      ),

      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Container(

          color: backgroundColor,
          child: Column(

            children: [
              SizedBox(height: 0,),
              TabBar(
                isScrollable: false,
                tabAlignment: TabAlignment.center,
                indicatorWeight: 0,

                indicator:BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: contentColor,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: contentColor.withOpacity(0.7),
                  //     spreadRadius: 1,
                  //     blurRadius: 10,
                  //     offset: Offset(0, 4),
                  //   ),
                  // ],
                ),
                tabs: [
                  Tab(text: 'For You',),
                  Tab(text: 'Watch'),
                ],
                labelColor: backgroundColor,
                unselectedLabelColor: contentColor.withOpacity(0.8),
                labelStyle:  GoogleFonts.philosopher(
                  textStyle: TextStyle(

                    fontSize: 16, // Adjust the font size as needed
                    fontWeight: FontWeight.bold,
                    // Make the text bold
                  ),
                ),
              ),

              Expanded(
                child: LiquidPullToRefresh(
                  onRefresh: () async {
                   // fetchPosts();
                  },
                  showChildOpacityTransition: true,
                  color: contentColor,
                  backgroundColor: backgroundColor,
                  springAnimationDurationInMilliseconds: 700,
                  height: 300,
                  animSpeedFactor: 2,
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [

                      GlowingContainer(), // Glowing container for "For You" tab
                      VideoFeed(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlowingContainer extends StatefulWidget {
  @override
  State<GlowingContainer> createState() => _GlowingContainerState();
}

class _GlowingContainerState extends State<GlowingContainer> {

  List<Post> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
    isLoading = false;
  }

  Future<void> fetchPosts() async {
    final List<Post> fetchedPosts = [];

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/allPosts'), // Replace with your API URL
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        for (final post in data) {
          final uid = post['uid'];
          final title = post['title'];
          final details = post['details'];
          final createdAt = post['createdAt'];
          final link = post['link'];
          final imageUrl = post['image']; // Use the image URL directly

          final newPost = Post(
            uid: uid,
            title: title,
            details: details,
            createdAt: createdAt,
            link: link,
            imageUrl: imageUrl, // Assign the image URL
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
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);
    return Container(
      color: backgroundColor,
      child: isLoading
          ? Center(
        child: Lottie.asset('assets/lotties/golden-loading.json'),
      )
          : Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          itemCount: posts.length, // Replace with the number of grid items you want
          itemBuilder: (BuildContext context, int index) {
            final post = posts[index];
            return Stack(
              children: [
                post.imageUrl.isNotEmpty
                    ? Container(
                  height: 420,
                      width: 210,
                      child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                      imageUrl: post.imageUrl,
                      fit: BoxFit.cover, //height: 200, // Adjust the height as needed
                      placeholder: (context, url) => Lottie.asset(
                        'assets/pc.json',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                    )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No posts yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: PopupMenuButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: Center(child: Icon(Icons.more_horiz,color: Colors.white,)),
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'option1',
                          child: Text('Option 1'),
                        ),
                        PopupMenuItem(
                          value: 'option2',
                          child: Text('Option 2'),
                        ),
                        // Add more options as needed
                      ];
                    },
                    onSelected: (value) {
                      // Handle option selection here
                      if (value == 'option1') {
                        // Perform action for option 1
                      } else if (value == 'option2') {
                        // Perform action for option 2
                      }
                    },
                  ),
                ),
              ],
            );
          },
          staggeredTileBuilder: (int index) =>

              StaggeredTile.count(1, index.isEven ? 1.2 : 1.8),
          mainAxisSpacing: 18.0,
          crossAxisSpacing: 12.0,

        ),
      ),
    );
  }
}



class CustomBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled ? Color(0xFF231A12) : Color(0xFFEbd2a9);

    final contentColor = themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9) : Color(0xFF2F1602);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFF5F5DC),
            blurRadius: 20.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10.0), // Add padding to move the line down
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 60.0, // Adjust the line width
                  height: 3.0, // Adjust the line thickness
                  color: contentColor, // Choose the line color
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(
                'Start creating',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: contentColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePostScreen()));
                  //showImageOptions(context);
                 // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageSelectionScreen()));
                },
                child: OptionWidget(
                  icon: Icons.edit,
                  title: 'Post',
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostListScreen()));
                  //showImageOptions(context);
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImageSelectionScreen()));
                },

                child: OptionWidget(
                  icon: Icons.lock,
                  title: 'Vault',
                ),
              ),
              OptionWidget(
                icon: Icons.lightbulb_outline,
                title: 'Idea Vault',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OptionWidget extends StatelessWidget {
  final IconData icon;
  final String title;

  OptionWidget({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled ? Color(0xFF231A12) : Color(0xFFEbd2a9);

    final contentColor = themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9) : Color(0xFF2F1602);
    return Column(
      children: [
        Container(
          width: 70.0, // Adjust the box width
          height: 70.0, // Adjust the box height
          padding: EdgeInsets.all(8.0), // Adjust padding as needed
          decoration: BoxDecoration(
            color: contentColor.withOpacity(0.5), // Customize the color of the box
            borderRadius: BorderRadius.circular(20.0), // Adjust for desired roundness
          ),
          child: Center(
            child: Icon(
              icon,
              size: 34.0, // Adjust the icon size as needed
              color: contentColor, // Customize the icon color
            ),
          ),
        ),
        SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.0, // Adjust the text size as needed
              color: contentColor, // Customize the text color
            ),
          ),
        ),
      ],
    );
  }
}

void showImageOptions(BuildContext context) {

  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Container(
          height: 200,
          // decoration: BoxDecoration(
          //   color:  Color(0xFF231A12),
          //   borderRadius: BorderRadius.vertical(
          //     top: Radius.circular(26.0),
          //   ),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Color(0xFFF5F5DC),
          //       blurRadius: 50.0,
          //       spreadRadius: 1.0,
          //     ),
          //   ],
          // ),
          color: Color(0xFFEbd2a9).withOpacity(0.8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(0), // Remove default ListTile padding
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.5), // Box color with opacity
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.camera,
                        size: 30,
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Text color
                    ),
                  ),
                  onTap: () {
                    // Close the bottom sheet
                    Navigator.pop(context);
                    // Navigate to the camera screen
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(),),);
                  },
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.all(0), // Remove default ListTile padding
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.5), // Box color with opacity
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.photo_library,
                        size: 30,
                        color: Colors.white, // Icon color
                      ),
                    ),
                  ),
                  title: Text(
                    'Browse Gallery',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Text color
                    ),
                  ),
                  onTap: () {
                    // Close the bottom sheet
                    Navigator.pop(context);
                    // Navigate to the gallery screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryScreen(),),);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  PickedFile? _pickedImage;

  Future<void> _pickImage() async {
    final pickedImage = await _imagePicker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _pickedImage == null
                ? Text('No image selected.')
                : Image.file(File(_pickedImage!.path)),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick an Image from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
