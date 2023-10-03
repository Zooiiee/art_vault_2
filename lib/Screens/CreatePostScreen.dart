import 'dart:io';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import '../Provider/AuthService.dart';
import 'Posts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'api_config.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  File? _imageFile;
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;
  String imageUrl = "";
  String title = "";
  String details = "";
  String link = "";

  bool _isUploading = false;


  @override
  void initState() {
    super.initState();

    _uploadImage();
    _uploadImage1();
  }
  Future<String?> getCurrentUserToken() async {
    final authService = AuthService();
    return authService.getToken();
  }



  @override
  Future<void> _pickImage({required ImageSource source}) async {
    final pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Call the function to upload the selected image
   //   await _uploadImage(_imageFile!);
    }
  }

  Future<void> _uploadImage1() async {
    if (_imageFile == null) return;

    try {
      await Firebase.initializeApp();
      final FirebaseStorage storage = FirebaseStorage.instance;
      final Reference storageRef = storage.ref().child('post_images/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the image to Firebase Storage
      final UploadTask uploadTask = storageRef.putFile(_imageFile!);

      // Wait for the upload to complete and get the download URL
      final TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL
      final String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Get the current user's token (UID)
      final String? userToken = await getCurrentUserToken();

      if (userToken == null) {
        // Handle the case where the user is not logged in or the token is missing.
        return;
      }

      // Replace with your server URL
      final serverUrl = '${ApiConfig.baseUrl}/insertPosts1';

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'uid': userToken,
          'title': title,
          'details': details,
          'createdAt': DateTime.now().toIso8601String(),
          'link': link,
          'image': imageUrl, // Use the Firebase image URL
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final postId = responseData['postId'];

        // setState(() {
        //   imageUrl = imageUrl; // Update the imageUrl variable with the Firebase URL
        // });

        print('Post inserted successfully. Image URL: $imageUrl');
        setState(() {
          _isUploading = true;
        });

        // Simulate the upload process
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _isUploading = false;
          });

          // Show a toast message
          Fluttertoast.showToast(
            msg: "Post created!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Color(0xFF463B2B),
            textColor: Colors.white,
            fontSize: 16.0,
          );

          // After 2 seconds, pop the screen
          Navigator.of(context).pop();
        });
      } else {
        // Handle error
        print('Post insertion failed');
      }
    } catch (error) {
      print('Error uploading image and inserting post: $error');
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    List<int> imageBytes = _imageFile!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    // Get the current user's token (UID)
    final String? userToken = await getCurrentUserToken();

    if (userToken == null) {
      // Handle the case where the user is not logged in or the token is missing.
      return;
    }

    // Replace with your server URL
    final serverUrl = '${ApiConfig.baseUrl}/insertPost';

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken', // Include the token in the request headers
        },
        body: jsonEncode({
          'uid': userToken, // Replace with the actual user ID
          'title': title, // Use the value from the title variable
          'details': details, // Use the value from the details variable
          'createdAt': DateTime.now().toIso8601String(),
          'link': link, // Use the value from the link variable
          'image': base64Image,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final postId = responseData['postId']; // Get the postId from the response

        setState(() {
          imageUrl = responseData['message'];
        });

        print('Post inserted successfully. Image URL: $imageUrl');
        setState(() {
          _isUploading = true;
        });


        // Simulate the upload process
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _isUploading = false;
          });

          // Show a toast message
          Fluttertoast.showToast(
            msg: "Post created!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Color(0xFF463B2B),
            textColor: Colors.white,
            fontSize: 16.0,
          );

          // After 2 seconds, pop the screen
          Navigator.of(context).pop();
        });
      } else {
        // Handle error
        print('Post insertion failed');
      }
    } catch (error) {
      print('Error uploading image and inserting post: $error');
    }
  }

  @override
  void showImageOptions(BuildContext context) async {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.29, // Adjust the height as needed
          decoration: BoxDecoration(
            color: Color(0xFFEbd2a9).withOpacity(0.90),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(26.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 8),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10.0), // Add padding to move the line down
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 60.0, // Adjust the line width
                        height: 3.0, // Adjust the line thickness
                        color: Color(0xFF463B2B), // Choose the line color
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(
                      'Select Image from',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF463B2B),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                GestureDetector(
                  onTap:(){
                    Navigator.pop(context);
                    _pickImage(source: ImageSource.camera);
                  },
                  child: ListTile(
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
                          color: Color(0xFF463B2B), // Icon color
                        ),
                      ),
                    ),
                    title: Text(
                      'Camera',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF463B2B),
                          fontWeight: FontWeight.bold// Text color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Divider(height: 2,thickness: 1,),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: ()  {
                    Navigator.pop(context);
                    _pickImage(source: ImageSource.gallery);
                  },
                  child: ListTile(
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
                          color: Color(0xFF463B2B), // Icon color
                        ),
                      ),
                    ),
                    title: Text(
                      'Browse Gallery',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF463B2B), // Text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final List<String>? selectedTags = ModalRoute.of(context)?.settings.arguments as List<String>?;


    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFF463B2B)
        ),

        title:  Text("\t\t\t\t\t\tCreate New Post",style: TextStyle(color:Color(0xFF463B2B), fontWeight: FontWeight.bold,fontSize: 24),),
        backgroundColor: Color(0xFFFAF3E0),
        elevation: 0, // Remove the shadow
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient:LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFAF3E0), Color(0xFFD1B588)],
          )
        ),
        child: SingleChildScrollView(
          child: Stack(

            children: [
              Column(
                children: [
                  SizedBox(height: 16.0),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        showImageOptions(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFBF0),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child:_imageFile != null
                            ? Container(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: MediaQuery.of(context).size.height * 0.35,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFBF0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                              child: Image.file(
                          _imageFile!,
                          width: 128.0,
                          height: 128.0,
                          fit: BoxFit.fill,
                        ),
                            )
                            :  GestureDetector(
                          onTap: (){
                            showImageOptions(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.brown.withOpacity(0.0), // Replace with your desired color and opacity
                                  BlendMode.srcATop,
                                ),
                                child: Lottie.asset(
                                  'assets/lotties/upload.json', // Replace with your Lottie animation file path
                                  width: 128.0,
                                  height: 128.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                'Upload your artwork',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: 'Give your artwork a title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                    ),

                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'More about your artwork',
                        hintStyle: TextStyle(fontSize: 17),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          details = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 17),
                        hintText: 'Add destination website',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            // Add your button's functionality here
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          link = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap : (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TagSelectionScreen(),));

                          },

                          child: Text(
                            'Tag related topics ',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        GestureDetector(
                          onTap : (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TagSelectionScreen(),));
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.0),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.92,
                      child: ElevatedButton(
                        onPressed: () {
                          _uploadImage1();

                          // Add create post handling code here
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF463B2B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8,top: 8,bottom: 8,right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Create Post',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFFE6D9B8),
                                ),
                              ),
                              SizedBox(width: 18,),
                              Container(
                                padding: EdgeInsets.all(8.0), // Adjust padding as needed
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFD1B588), // Lighter brown color
                                ),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 32.0,
                                  color: Color(0xFF463B2B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ),
                  SizedBox(height: 32.0),
                ],
              ),
              if (_isUploading)
                Center(
                  child: Container(
                    height: MediaQuery.sizeOf(context).height,
                    color: Color(0xFF463B2B).withOpacity(0.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lotties/loading.json'),
                        SizedBox(height: 16.0), // Add spacing between the animation and text
                        Text(
                          'Creating post...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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


class TagSelectionScreen extends StatefulWidget {
  @override
  _TagSelectionScreenState createState() => _TagSelectionScreenState();
}

class _TagSelectionScreenState extends State<TagSelectionScreen> {
  List<String> tagNames = [];
  List<String> selectedTags = [];
  int mostRecentPostId = 0; // Initialize with 0


  @override
  void initState() {
    super.initState();
    fetchMostRecentPostId();
    fetchTags().then((tags) {
      setState(() {
        tagNames = tags;
      });
    }).catchError((error) {
      print('Error fetching tags: $error');
    });
  }

  Future<void> fetchMostRecentPostId() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/mostRecentPostId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      mostRecentPostId = data['mostRecentPostId'] + 1; // Add 1 to the most recent postId
    } else {
      throw Exception('Failed to load most recent postId');
    }
  }
  Future<List<String>> fetchTags() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/tags'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<String> tags = data.map((item) => item['tagName'] as String).toList();
      return tags;
    } else {
      throw Exception('Failed to load tags');
    }
  }


  void _handleDoneButtonPressed() async {
    // Send the selected tags and mostRecentPostId to the server
    final String serverUrl = '${ApiConfig.baseUrl}/insertTags';
    final Map<String, dynamic> requestData = {
      'postId': mostRecentPostId.toString(),
      'tags': selectedTags,
    };

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        // Tags inserted successfully, you can now navigate back or perform other actions
        Navigator.pop(context);

        // Optionally, you can show a success message to the user
        // You can use a toast message or a snackbar for this
      } else {
        // Handle the case where inserting tags failed
        // You can show an error message to the user if needed
      }
    } catch (error) {
      // Handle any network or server errors
      // You can show an error message to the user if needed
      print('Error inserting tags: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.brown
        ),
        title: Text('Select Tags',style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),),
        elevation: 0,
        backgroundColor: Color(0xFFFAF3E0),
        actions: [
          TextButton(
            onPressed: () {

            },
            child: ElevatedButton(
              onPressed: (){
                _handleDoneButtonPressed();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF463B2B) ,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFAF3E0), Color(0xFFD1B588)],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: tagNames.map((tagName) {
                final isSelected = selectedTags.contains(tagName);

                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (isSelected) {
                        selectedTags.remove(tagName);
                      } else {
                        selectedTags.add(tagName);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isSelected ? Color(0xFF463B2B) : Color(0xFFD1B588),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      tagName,
                      style: TextStyle(

                        fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
                        color: isSelected ?  Color(0xFFD1B588) :Color(0xFF463B2B),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
