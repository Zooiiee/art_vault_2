import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart'; // Import your theme provider

class BiddingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);

    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Text(
            'Bidding Screen',
            style: TextStyle(
              fontSize: 24,
              color: themeProvider.isDarkModeEnabled ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
