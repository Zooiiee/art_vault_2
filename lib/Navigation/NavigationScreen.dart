import 'package:art_vault_2/Screens/BiddingPage.dart';
import 'package:art_vault_2/Screens/ExplorePage.dart';
import 'package:art_vault_2/Screens/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:provider/provider.dart';
import '../Screens/Home.dart';
import '../Screens/SocialsPage.dart';

class Navigation extends KFDrawerContent { // Extend KFDrawerContent
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<Navigation> {
  List<Widget> pages = [Home(onTap: (int ) {  }, onDarkModeToggle: (bool ) {  }, currentIndex: 0,), ExploreScreen(),  SocialsScreen(),BiddingScreen(),ProfileScreen(),];
  int currentIndex = 0;
  bool isHomeIconTapped = true;
  List<bool> isAlternateImages = List.filled(5, false);


  void onTap(int index) {
    setState(() {
      currentIndex = index;
      if (index == 0) {
        // Toggle the boolean flag on tapping the home icon
        isHomeIconTapped = !isHomeIconTapped;
      } else {
        // Reset the flag when any other tab icon is tapped
        isHomeIconTapped = false;
      }

      isAlternateImages[index] = !isAlternateImages[index];
      // Reset the flags for other tab icons
      for (int i = 0; i < isAlternateImages.length; i++) {
        if (i != index) {
          isAlternateImages[i] = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        onTap: onTap,
        backgroundColor: themeProvider.isDarkModeEnabled ?  Color(0xFF231A12) : Color(0xFFEbd2a9),//Color(0xFF473B2B),
        color: const Color(0xFF52412E),
        buttonBackgroundColor: const Color(0xFF473B2B),
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        items: [
          isHomeIconTapped ? Image.asset('assets/icons/home.png', width: 22, height: 22, color: const Color(0xFFEbd2a9),)
              : Image.asset('assets/icons/home1.png', width: 24, height: 24, color: const Color(0xFFEbd2a9),),
          isAlternateImages[1]? Image.asset('assets/icons/compass.png',width: 26, height: 26, color: const Color(0xFFEbd2a9),)
              : Image.asset('assets/icons/compass1.png',width: 24,height: 24,color: const Color(0xFFEbd2a9),),
          isAlternateImages[2]? Image.asset('assets/icons/trending1.png',width: 24, height: 24, color: const Color(0xFFEbd2a9),)
              : Image.asset('assets/icons/trending.png',width: 24,height: 24,color: const Color(0xFFEbd2a9),),

          isAlternateImages[3]? Image.asset('assets/icons/chat1.png',width: 24, height: 24, color: const Color(0xFFEbd2a9),)
              : Image.asset('assets/icons/chat.png',width: 28,height: 28,color: const Color(0xFFEbd2a9),),
        isAlternateImages[4]? Image.asset('assets/icons/user2.png',width: 24, height: 24, color: const Color(0xFFEbd2a9),)
            : Image.asset('assets/icons/user1.png',width: 24,height: 24,color: const Color(0xFFEbd2a9),),
        ],
      ),
    );
  }
}
