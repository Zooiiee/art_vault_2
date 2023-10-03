import 'package:art_vault_2/Screens/SplashScreen.dart';
import 'package:art_vault_2/theme/ThemeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Classes/ClassBuilder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Provider/AuthService.dart';
import 'Provider/UserProfileProvider.dart';
import 'Screens/ConnectScreen.dart';
import 'Screens/MainDrawerScreen.dart';
import 'Screens/SocialsPage.dart';
import 'forms/LoginForm.dart';
import 'forms/SignUpForm.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is initialized.
  await Firebase.initializeApp();
  ClassBuilder.registerClasses();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()), // Your existing provider
        ChangeNotifierProvider(create: (context) => UserProfileProvider()), // UserProfileProvider
        // Add more providers if needed
      ],
      child: MyApp(),
    ),
  );
}//ThemeProvider()
class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: _authService.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen(); // Show SplashScreen while checking authentication status
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? NavigationScreen() : SplashScreen(); // Replace with your home and connect screens
        },
      ),
      routes: {
        '/connect': (context) => ConnectScreen(), // Define the 'connect' route
        '/login': (context) => LoginForm(), // Define the 'login' route
        '/signup': (context) => SignUpForm(), // Define the 'signup' route
      },
      debugShowCheckedModeBanner: false,
      //themeMode: ThemeMode.system,
      theme: ThemeData(
        cardColor: Colors.amber,
        primaryColor: Colors.amber, // Customize the primary color
       // brightness: Brightness.light,
        textTheme: GoogleFonts.philosopherTextTheme(Theme.of(context).textTheme),
        focusColor: Color(0xFF52412E),
      ),
    );
  }
}
