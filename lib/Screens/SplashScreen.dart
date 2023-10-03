import 'package:flutter/material.dart';
import 'dart:async';

import 'package:art_vault_2/Screens/GetStartedScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds before navigating
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetStartedScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD7BD97),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 100.0,
            right: 82.0,
            child: Text(
              'Virtual Art Gallery',
              style: TextStyle(
                fontSize: 28.0,
                color: Color(0xFF463B2B),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/logo2.gif', // Update this path to your GIF's location
              width: double.maxFinite, // Set the width to your desired value
              height: 400.0, // Set the height to your desired value
            ),
          ),
        ],
      ),
    );
  }
}
