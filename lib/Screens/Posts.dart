import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:lottie/lottie.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import '../Provider/AuthService.dart';
import 'api_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }
  Future<String?> getCurrentUserToken() async {
    final authService = AuthService();
    return authService.getToken();
  }

  Future<void> fetchPosts() async {
    final List<Post> fetchedPosts = [];
    final String? userToken = await getCurrentUserToken();
print(userToken);
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/allPosts/$userToken'), // Replace with your API URL
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Post List'),
      ),
      body: StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        itemCount: posts.length,
        staggeredTileBuilder: (int index) {
          return StaggeredTile.fit(1);
        },
        itemBuilder: (BuildContext context, int index) {
          final post = posts[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.all(8),
            child: Column(
              children: [
                // Display the image if available
                if (post.imageUrl.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: post.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Lottie.asset(
                      'assets/pc.json', // Replace with your Lottie animation file path
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),

                ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.details),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
