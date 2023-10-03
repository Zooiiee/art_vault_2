import 'package:art_vault_2/Screens/ArtMovementsDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';

import '../Widgets/Parallex.dart'; // Import your theme provider

class ArtMovementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final backgroundColor = themeProvider.isDarkModeEnabled
        ? Color(0xFF231A12) // Very Very Dark Brown
        : Color(0xFFEbd2a9);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        toolbarHeight: 56,
        iconTheme: IconThemeData(color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12)),
        title:Text('Art Movements',style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: themeProvider.isDarkModeEnabled ? Color(0xFFEbd2a9): Color(0xFF231A12),),),
        backgroundColor: themeProvider.isDarkModeEnabled
            ? Color(0xFF231A12)
            : Color(0xFFEbd2a9),


      ),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArtMovementDetails()));
        },
        child: Container(
          color: backgroundColor,
          child: ArtMovementsParallax(),


        ),
      ),
    );
  }
}
