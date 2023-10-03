import 'package:art_vault_2/Screens/EditPostScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'ArtMovementsDetail.dart';
import 'ProfileScreen.dart';
//
//
// class UserPostScreen extends StatelessWidget {
//   final Post post; // Replace with your Post model
//
//   UserPostScreen({required this.post});
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//     final backgroundColor = themeProvider.isDarkModeEnabled
//         ? Color(0xFF231A12) // Very Very Dark Brown
//         : Color(0xFFEbd2a9);
//     final contentColor = themeProvider.isDarkModeEnabled
//         ? Color(0xFFEbd2a9) // Very Very Dark Brown
//         : Color(0xFF473B2B);
//
//     final cc = themeProvider.isDarkModeEnabled
//         ? Color(0xFFF5F5DC)
//         : Color(0xFF2F1602);
//
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 // Background image
//                 Container(
//                   padding: EdgeInsets.only(
//                     left: 5.0,
//                     right: 10.0,
//                     top: 40.0,
//                   ),
//                   height: 600,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(post.imageUrl), // Use the imageBytes from your Post model
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             width: 42, // Adjust the width to make it square
//                             height: 42, // Adjust the height to make it square
//                             margin: EdgeInsets.only(left: 5, top: 2), // Add margin to the left side
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8), // Add rounded corners
//                               color: Colors.black.withOpacity(0.6),
//                             ),
//                             child: IconButton(
//                               icon: Icon(
//                                 Icons.arrow_back,
//                                 size: 28,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 40.0),
//                     ],
//                   ),
//                 ),
//                 // White screen with details
//                 SingleChildScrollView(
//                   child: Container(
//                     transform: Matrix4.translationValues(0.0, -20.0, 0.0),
//                     decoration: BoxDecoration(
//                       color: backgroundColor,
//                       borderRadius: BorderRadius.circular(24.0),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 20.0,
//                             vertical: 20.0,
//                           ),
//                           child: Text(
//                             post.title, // Use the title from your Post model
//                             style: TextStyle(
//                               fontSize: 26.0,
//                               color: contentColor,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         if (post.details != null && post.details.isNotEmpty)
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20.0,
//                               vertical: 0.0,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(
//                                   post.details, // Use the details from your Post model
//                                   style: TextStyle(
//                                     fontSize: 17.0,
//                                     color: cc,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 5.0),
//                               ],
//                             ),
//                           ),
//                         if (post.link != null && post.link.isNotEmpty)
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20.0,
//                               vertical: 0.0,
//                             ),
//                             child: Text(
//                               'Link: ${post.link}', // Use the link from your Post model
//                               style: TextStyle(
//                                 fontSize: 17.0,
//                                 color: cc,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 20.0,
//                             vertical: 20.0,
//                           ),
//                           child: Text(
//                             'Created : ${getTimeDifference(post.createdAt)}', // Use the createdAt from your Post model
//                             style: TextStyle(
//                               fontSize: 18.0,
//                               color: cc,
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: 20.0),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.all(8),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => EditPostScreen(post: post),
//                                     ),
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   primary: Colors.blue, // Change the button color
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30), // Rounded edges
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 14,
//                                     horizontal: 10,
//                                   ),
//                                   child: Text(
//                                     'Edit',
//                                     style: TextStyle(fontSize: 18),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(8),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // Implement delete functionality here
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   primary: Colors.red, // Change the button color
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30), // Rounded edges
//                                   ),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 14,
//                                     horizontal: 10,
//                                   ),
//                                   child: Text(
//                                     'Delete',
//                                     style: TextStyle(fontSize: 18),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
// }
//
// String getTimeDifference(String createdAt) {
//   final currentTime = DateTime.now();
//   final createdTime = DateTime.parse(createdAt);
//   final difference = currentTime.difference(createdTime);
//
//   if (difference.inDays > 0) {
//     return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
//   } else if (difference.inHours > 0) {
//     return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
//   } else {
//     return 'Just now';
//   }
// }
