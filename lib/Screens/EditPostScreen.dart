import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'ProfileScreen.dart';
import 'UserPostScreen.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import 'api_config.dart';
//
// class EditPostScreen extends StatefulWidget {
//   final Post post; // Replace with your Post model
//
//   EditPostScreen({required this.post});
//
//   @override
//   _EditPostScreenState createState() => _EditPostScreenState();
// }
//
// class _EditPostScreenState extends State<EditPostScreen> {
//   TextEditingController titleController = TextEditingController();
//   TextEditingController detailsController = TextEditingController();
//   TextEditingController linkController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     titleController.text = widget.post.title; // Set existing title data
//     detailsController.text = widget.post.details; // Set existing details data
//     linkController.text = widget.post.link; // Set existing link data
//   }
//
//   String title = "";
//   String details = "";
//   String link = "";
//
// bool _isUpdating =false;
//   Future<void> updatePostData() async {
//     final String apiUrl = '${ApiConfig.baseUrl}/updatePost/${widget.post.uid}'; // Replace with your API endpoint URL
//
//     final updatedData = {
//       'title': title.isNotEmpty ? title : widget.post.title,
//       'details': details.isNotEmpty ? details : widget.post.details,
//       'link': link.isNotEmpty ? link : widget.post.link,
//     };
//
//     try {
//       final response = await http.put(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(updatedData),
//       );
//
//       if (response.statusCode == 200) {
//         // Post updated successfully, you can handle the success here
//         print('Post updated successfully');
//         Future.delayed(Duration(seconds: 2), () {
//           setState(() {
//             _isUpdating = false;
//           });
//
//           // Show a toast message
//           Fluttertoast.showToast(
//             msg: "Post Updated!",
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 2,
//             backgroundColor: Color(0xFF463B2B),
//             textColor: Colors.white,
//             fontSize: 16.0,
//           );
//
//           // After 2 seconds, pop the screen
//           Navigator.of(context).pop();
//         });
//
//         // After the update, navigate back to the previous screen
//         Navigator.of(context).pop();
//       } else {
//         // Handle API errors or show an error message
//         print('Error updating post: ${response.statusCode}');
//       }
//     } catch (error) {
//       // Handle network or other errors
//       print('Error updating post: $error');
//     }
//   }
//
//   @override
//   void dispose() {
//     titleController.dispose();
//     detailsController.dispose();
//     linkController.dispose();
//     super.dispose();
//   }
//
//   @override
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Color(0xFF463B2B),
//         ),
//         title: Text(
//           "Edit Post",
//           style: TextStyle(
//             color: Color(0xFF463B2B),
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         backgroundColor: Color(0xFFFAF3E0),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Color(0xFFFAF3E0), Color(0xFFD1B588)],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Stack(
//
//             children: [
//               Column(
//                 children: [
//                   SizedBox(height: 16.0),
//                   Center(
//                     child: GestureDetector(
//                       onTap: () {
//                         // Implement image selection logic here
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width * 0.90,
//                         height: MediaQuery.of(context).size.height * 0.40,
//                         decoration: BoxDecoration(
//                           color: Color(0xFFFFFBF0),
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                         child: Container(
//                           width: MediaQuery.of(context).size.width * 0.90,
//                           height: MediaQuery.of(context).size.height * 0.45,
//                           decoration: BoxDecoration(
//                             color: Color(0xFFFFFBF0),
//                             borderRadius: BorderRadius.circular(20.0),
//                           ),
//                           child:Image.network(
//                             widget.post.imageUrl!,
//                             fit: BoxFit.fill,
//                           ),
//                         )
//
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: TextField(
//                       controller: titleController,
//                       decoration: InputDecoration(
//                         hintStyle: TextStyle(fontSize: 17),
//                         hintText: 'Edit the title',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           title = value;
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: TextField(
//                       controller: detailsController,
//                       maxLines: 4,
//                       decoration: InputDecoration(
//                         hintText: 'Edit the details',
//                         hintStyle: TextStyle(fontSize: 17),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           details = value;
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: TextField(
//                       controller: linkController,
//                       decoration: InputDecoration(
//                         hintStyle: TextStyle(fontSize: 17),
//                         hintText: 'Edit the link',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           link = value;
//                         });
//                       },
//                     ),
//
//                   ),
//                   SizedBox(height: 26.0),
//                   Center(
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * 0.92,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _isUpdating = true;
//                           });
//                           updatePostData();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           primary: Color(0xFF463B2B),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(40.0),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Update Post',
//                                 style: TextStyle(
//                                   fontSize: 20.0,
//                                   color: Color(0xFFE6D9B8),
//                                 ),
//                               ),
//                               SizedBox(width: 30,),
//                               Container(
//                                 padding: EdgeInsets.all(8.0),
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Color(0xFFD1B588),
//                                 ),
//                                 child: Icon(
//                                   Icons.arrow_forward,
//                                   size: 32.0,
//                                   color: Color(0xFF463B2B),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 32.0),
//                 ],
//               ),
//               if (_isUpdating)
//                 Center(
//                   child: Container(
//                     height: MediaQuery.sizeOf(context).height,
//                     color: Color(0xFF463B2B).withOpacity(0.5),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Lottie.asset('assets/lotties/loading.json'),
//                         SizedBox(height: 16.0), // Add spacing between the animation and text
//                         Text(
//                           'Updating post...',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
