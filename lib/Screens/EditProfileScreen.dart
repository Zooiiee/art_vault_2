import 'dart:io';
import 'package:art_vault_2/Screens/SettingsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import '../Provider/AuthService.dart';
import '../Provider/UserProfileProvider.dart';
import 'api_config.dart';
import 'package:provider/provider.dart';


class EditProfileScreen extends StatefulWidget {
  final String? profilePictureUrl;

  const EditProfileScreen({Key? key, this.profilePictureUrl}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();
  Map<String, dynamic> userData = {};
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.profilePictureUrl;
    AuthService authService = AuthService();
    authService.getToken().then((uid) {
      if (uid != null) {
        // Fetch user data using the UID
        fetchUserData(uid);

      }
    });
  }

  Future<void> fetchUserData(String uid) async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/userData/$uid'));

    if (response.statusCode == 200) {
      // User data retrieved successfully
      final fetchedData = jsonDecode(response.body);

      setState(() {
        userData = fetchedData;
      });
      print(userData['username']);
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

  Future<void> updateUserInformation({
    String ?name,
    String ?username,
    String ?bio,
    String ?email,
  }) async {
    try {
      // Construct the request body with the updated information
      final Map<String, dynamic> requestBody = {
        'name': name,
        'username': username,
        'bio': bio,
        'email': email,
      };

      // Convert the request body to JSON
      final String requestBodyJson = jsonEncode(requestBody);

      // Get the UID from the userData map
      final int? uid = userData['uid'];
      print('UID: $uid');

      if (uid == null) {
        // Handle the case where UID is not available
        print('UID not available');
        return;
      }

      // Update the API URL with the UID
      final String apiUrl = '${ApiConfig.baseUrl}/updateUserInfo/$uid';
      print('API URL: $apiUrl');

      // Send a PUT request to update user information
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        // User information updated successfully
        print('User information updated successfully');
      } else {
        // Handle the error
        print('Failed to update user information. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the update
      print('Error updating user information: $e');
    }
  }


  Future<void> _pickImage({required ImageSource source}) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Call the function to upload the selected image
      await _uploadImage(_imageFile!);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      await Firebase.initializeApp(); // Initialize Firebase
      // Get the UID from the userData map
      final int? uid = userData['uid'];
      print('UID: $uid');

      if (uid == null) {
        // Handle the case where UID is not available
        print('UID not available');
        return;
      }

      // Reference to the Firebase Storage location where you want to store the image
      final Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$uid');

      // Upload the file to Firebase Storage
      final UploadTask uploadTask = storageRef.putFile(imageFile);

      // Get the download URL when the upload is complete
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      // Get the download URL
      final String imageUrl = await snapshot.ref.getDownloadURL();
      // Update the user's profile picture URL in the provider

      await updateUserProfilePicture(imageUrl);
      // Store the imageURL in SQLite
      // You should have a function to save data to SQLite here

      // Print the imageURL for debugging
      print('Image URL: $imageUrl');

    } catch (e) {
      // Handle any exceptions that occur during the upload
      print('Error uploading image: $e');
    }
  }

  Future<void> updateUserProfilePicture(String? profilePicture) async {
    try {
      // Construct the request body with the updated information
      final Map<String, dynamic> requestBody = {
        'profilePicture': profilePicture,
      };

      // Convert the request body to JSON
      final String requestBodyJson = jsonEncode(requestBody);

      // Get the UID from the userData map
      final int? uid = userData['uid'];
      print('UID: $uid');

      if (uid == null) {
        // Handle the case where UID is not available
        print('UID not available');
        return;
      }

      // Update the API URL with the UID
      final String apiUrl = '${ApiConfig.baseUrl}/updateUserProfilePicture/$uid';
      print('API URL: $apiUrl');

      // Send a PUT request to update user information
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        // User profile picture URL updated successfully
        print('Profile picture URL updated successfully');
      } else {
        // Handle the error
        print('Failed to update profile picture URL. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the update
      print('Error updating profile picture URL: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController(text: userData['email']);
    TextEditingController nameController = TextEditingController(text: userData['name']);
    TextEditingController usernameController = TextEditingController(text: userData['username']);
    TextEditingController bioController = TextEditingController(text: userData['bio']);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Color(0xFFF5F5DC),
        ),
        backgroundColor: Color(0xFF52412E),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Color(0xFFF5F5DC)),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => SettingsScreen(),
            ));
          },
          icon: Icon(
            Icons.arrow_back
          ),

        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Color(0xFFF5F5DC),
            ),
            onPressed: () {
              updateUserInformation(
                name: nameController.text,
                username: usernameController.text,
                bio: bioController.text,
                email: emailController.text,
              );
              // Handle save action
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF5F5DC),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImage(source: ImageSource.gallery);
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.transparent,
                    backgroundImage:_imageFile != null
                        ? FileImage(_imageFile!) as ImageProvider<Object> // Use the selected image
                        : userData['profilePicture'] != null
                        ? NetworkImage(userData['profilePicture']) as ImageProvider<Object> // Use the profile picture URL
                        : AssetImage('assets/avatar.gif'),

                    //
                    // userData['profilePicture'] != null
                    //     ? FileImage(_imageFile!) as ImageProvider<Object> // Use the profile picture URL
                    //     : AssetImage('assets/avatar.gif'),

                  ),
                ),
                Positioned(//as ImageProvider<Object>
                  right: 10,
                  bottom: 10,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _pickImage(source: ImageSource.gallery);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFDAA520), width: 2.3),
                        ),
                        border: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.cyan, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Username",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: usernameController, // Replace with user's username
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFDAA520), width: 2.3),

                        ),
                        border: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.cyan, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Bio",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: bioController,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      maxLines: 3,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFDAA520), width: 2.3),
                        ),
                        border: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.cyan, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(

                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFDAA520), width: 2.3),
                        ),
                        border: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.cyan, width: 100),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Joined On",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      userData['joiningDate'] ??'', // Replace with the actual join date
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
