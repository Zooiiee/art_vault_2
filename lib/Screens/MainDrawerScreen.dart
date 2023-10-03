import 'package:art_vault_2/Screens/Artworksscreen.dart';
import 'package:art_vault_2/Screens/DrawingCanvas.dart';
import 'package:art_vault_2/Screens/SettingsScreen.dart';
import 'package:art_vault_2/Screens/SocialsPage.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../Provider/AuthService.dart';
import '../Provider/UserProfileProvider.dart';
import 'ArtMovementScreen.dart';
import 'ArtistsScreen.dart';
import 'EventScreen.dart';
import 'ExplorePage.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'Home.dart';
import 'dart:convert';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:art_vault_2/Classes/ClassBuilder.dart';
import 'api_config.dart';

class NavigationScreen extends KFDrawerContent {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  late KFDrawerController _drawerController;
  bool _isDarkModeEnabled = false;
  int _currentIndex = 0;
  int currentIndex = 0;
  Map<String, dynamic> userData = {};

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
  void onTap(int index) {
    setState(() {
      super.initState();

      AuthService authService = AuthService();
      _currentIndex = index;
    });
  }

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
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('Navigation'),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Home', style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),),
          icon: Image.asset(
              'assets/icons/home.png', // Replace with the actual path to your vault.png image
              width: 20, // Adjust the width as needed
              height: 20, // Adjust the height as needed
              color:Color(0xFFEbd2a9)),
          // page: Home(),
          onPressed: () {
           _drawerController.close!();
          },
        ),

        KFDrawerItem.initWithPage(
          text: Text(
            'Artists',
            style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),
          ),
          icon: Image.asset(
              'assets/icons/painter.png', // Replace with the actual path to your vault.png image
              width: 26, // Adjust the width as needed
              height: 26, // Adjust the height as needed
              color:Color(0xFFEbd2a9)),
          //page: Profile(),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtistsScreen(),));
          },
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Gallery',
            style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),
          ),
          icon: Image.asset(
              'assets/icons/mona-lisa.png', // Replace with the actual path to your vault.png image
              width: 26, // Adjust the width as needed
              height: 26, // Adjust the height as needed
              color:Color(0xFFEbd2a9)),
          //page: ClassBuilder.fromString('Notifications'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtworksScreen(),));
          },
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Events & Exibitions',
            style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),
          ),
          icon: Image.asset(
              'assets/icons/event.png', // Replace with the actual path to your vault.png image
              width: 24, // Adjust the width as needed
              height: 24, // Adjust the height as needed
              color:Color(0xFFEbd2a9)),
          //page: ClassBuilder.fromString('Notifications'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventScreen()));
          },
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Art Movements',
            style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),
          ),
          icon:Image.asset(
              'assets/icons/history1.png', // Replace with the actual path to your vault.png image
              width: 26, // Adjust the width as needed
              height: 26, // Adjust the height as needed
              //color:Color(0xFFEbd2a9)
            ),
          //page: ClassBuilder.fromString('Notifications'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtMovementsScreen(),));
          },
        ),

        // KFDrawerItem.initWithPage(
        //   text: Text(
        //     'Museums',
        //     style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),
        //   ),
        //   icon: Image.asset(
        //     'assets/icons/location.png', // Replace with the actual path to your vault.png image
        //     width: 26, // Adjust the width as needed
        //     height: 26, // Adjust the height as needed
        //     color:Color(0xFFEbd2a9)
        //   ),
        //   onPressed: () {
        //     _drawerController.close!();
        //   },
        // ),

        KFDrawerItem.initWithPage(
          text: Text(
            'Canvas',
            style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),
          ),
          icon: Image.asset(
              'assets/icons/canvas.png', // Replace with the actual path to your vault.png image
              width: 26, // Adjust the width as needed
              height: 26, // Adjust the height as needed
             // color:Color(0xFFEbd2a9)
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DrawingCanvas()));
          },
        ),


        KFDrawerItem.initWithPage(
          text: Text(
            'Vault',
            style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),
          ),
          icon: Image.asset(
            'assets/icons/vault.png', // Replace with the actual path to your vault.png image
            width: 26, // Adjust the width as needed
            height: 26, // Adjust the height as needed
            //color:Color(0xFFEbd2a9)
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SocialsScreen(),));
          },
        ),
        // KFDrawerItem.initWithPage(
        //   text: Text(
        //     'Notifications',
        //     style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),
        //   ),
        //   icon: Icon(Icons.notifications_active, color: Color(0xFFEbd2a9)),
        //   //page: ClassBuilder.fromString('Notifications'),
        //   onPressed: () {
        //     _drawerController.close!();
        //   },
        // ),




        KFDrawerItem.initWithPage(
          // onPressed: ,
          text: Text(
            'Settings',
            style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),
          ),
          icon: Icon(Icons.settings, color: Color(0xFFEbd2a9)),
          //page: Settings(),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen(),));
          },
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'LogOut',
            style: TextStyle(color: Color(0xFFEbd2a9), fontSize: 18),
          ),
          icon: Icon(Icons.logout, color: Color(0xFFEbd2a9)),
          onPressed: () async {
            // Close the drawer
            _drawerController.close!();

            // Remove the token from shared preferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');

            // Navigate to the login or splash screen
            Navigator.of(context).pushReplacementNamed('/connect'); // Replace with your login or splash screen route
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context); // Get the UserProfileProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkModeEnabled = themeProvider.isDarkModeEnabled; // Get this value from your theme provider

    BoxDecoration decoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkModeEnabled
            ?  [Color(0xFF231A12), Color(0xFF473B2B)]
            : [Color(0xFF52412E), Color(0xFF2F1602)],

      ),
    );
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          KFDrawer(
            controller: _drawerController,
            header: Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // SizedBox(height: 00,),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                  image: userData['profilePicture'] != null
                                      ? NetworkImage(userData['profilePicture']) as ImageProvider<Object> // Use the profile picture URL
                                      // : userProfileProvider.profilePictureUrl != null
                                      // ? NetworkImage(userProfileProvider.profilePictureUrl) as ImageProvider<Object>
                                      : AssetImage('assets/avatar2.gif'), // Use the default asset image
                                  fit: BoxFit.cover
                              )
                          ),
                        ),
                        SizedBox(
                          width: 10,
                          height: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(userData['name'] ?? ' ', style: new TextStyle(fontSize: 20, color: Color(0xFFF5F5DC))),
                            new SizedBox(height: 2),
                            new Text(userData['username'] ?? ' ', style: new TextStyle(fontSize: 15, color: Colors.grey)),
                            new SizedBox(height: 50),
                          ],

                        ),
                        // SizedBox(height: 100,),
                      ],
                    ),
                  ],
                ),

              ),

            ),
            footer: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Transform.scale(
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
                ),
              ],
            ),
            decoration: decoration,
          ),
        ],
      ),



    );
  }
}
