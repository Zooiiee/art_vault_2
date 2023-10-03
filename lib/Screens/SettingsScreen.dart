import 'package:art_vault_2/Screens/MainDrawerScreen.dart';
import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Provider/AuthService.dart';
import 'dart:convert';


import '../Provider/UserProfileProvider.dart';
import 'EditProfileScreen.dart';
import 'api_config.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkModeEnabled = false;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
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
    bool isDarkModeEnabled = themeProvider.isDarkModeEnabled; // Get this value from your theme provider

    final userProfileProvider = Provider.of<UserProfileProvider>(context); // Get the UserProfileProvider

    bool notificationsEnabled = true; // Replace with the actual value
    final cc = themeProvider.isDarkModeEnabled ? Color(0xFFF5F5DC): Color(0xFF231A12)
    ;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: themeProvider.isDarkModeEnabled
                    ? [Color(0xFF52412E), Color(0xFF2F1602)]
                    : [
                  Color(0xFFF5F5DC), Color(0xFFEbd2a9), Color(0xFFA97C50)
                ],
              ),
            ),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(

               //  automaticallyImplyLeading :true ,
                  leading: IconButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => NavigationScreen(),
                    ));
                  },
                    icon: Icon(Icons.arrow_back, color: cc,),),
                  title: Text("Settings",style: TextStyle(color: cc, fontWeight: FontWeight.bold),),
                  expandedHeight: 360.0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFFfed2a1),
                        radius: 50.0,
                        backgroundImage: userData['profilePicture'] != null
                            ? NetworkImage(userData['profilePicture']) as ImageProvider<Object> // Use the profile picture URL
                            : AssetImage('assets/avatar.gif'),

                        // Replace with user's image
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        userData['username'] ?? '', // Replace with user's name
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: cc),

                      ),
                      SizedBox(height: 2,),
                      Text(
                          userData['email'] ?? '',// Replace with user's name
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: cc),

                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(

                        onPressed: () {
                          // Handle the "Edit Profile" button tap here, e.g., navigate to the edit profile screen
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ));
                        },
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFFFFAF0),
                          onPrimary: Color(0xFF231A12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),

                    ],

                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 320.0, // Adjust this value to control the position of the sheet
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: themeProvider.isDarkModeEnabled
                    ? Color(0xFF231A12) // Very Very Dark Brown
                    : Color(0xFFF5F5DC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.2), // Adjust opacity as needed
                        borderRadius: BorderRadius.circular(10.0), // Adjust border radius as needed
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/icons/canvas.png', // Replace with the actual path to your vault.png image
                          width: 28, // Adjust the width as needed
                          height: 28, // Adjust the height as needed
                          // color:Color(0xFFEbd2a9)
                        ),
                      ),
                    ),
                    title: Text('Dark Mode',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: cc),),
                    trailing:Transform.scale(
                      scale: 0.8,
                      child: DayNightSwitcher(
                        isDarkModeEnabled: themeProvider.isDarkModeEnabled,
                        onStateChanged: (isDarkModeEnabled) {
                          themeProvider.setDarkMode(isDarkModeEnabled);
                          setState(() {
                            _isDarkModeEnabled = isDarkModeEnabled;
                          });
                        },
                        dayBackgroundColor: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  Divider(height: 15,color: cc,indent: 16,endIndent: 20,),
                  ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/icons/canvas.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                    title: Text(
                      'Notifications',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,color: cc),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          notificationsEnabled ? 'On' : 'Off',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TimeSpentScreen(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/icons/canvas.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                    title: Text(
                      'Time Spent',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: cc ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios), // Arrow icon at the end
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TimeSpentScreen(),
                      ));
                    },
                  ),


                  // Add more settings options here
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}





class TimeSpentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Spent'),
      ),
      // Implement the time spent screen content here
    );
  }
}

