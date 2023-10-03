
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../Provider/AuthService.dart';
import '../Screens/MainDrawerScreen.dart';
import 'package:art_vault_2/Screens/api_config.dart';


class LoginForm extends StatefulWidget {

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isObscure = true;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Map<String, dynamic> userData = {};


  Future<bool> login() async {
    final Uri apiUrl = Uri.parse('${ApiConfig.baseUrl}/login'); // Replace with your server URL

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> credentials = {
      'username': usernameController.text,
      'password': passwordController.text,
    };

    final String credentialsJson = jsonEncode(credentials);

    try {
      final http.Response response = await http.post(
        apiUrl,
        headers: headers,
        body: credentialsJson,
      );

      if (response.statusCode == 200) {
        // Authentication successful
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('User data: $data');

        // Store the token after successful login
        final authService = AuthService();
        final generatedUid = data['uid'].toString(); // Replace with your token data
        await authService.storeToken(generatedUid);

        // Proceed with navigation
        Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationScreen()));

        return true;
      } else if (response.statusCode == 404) {
        // User not found
        Fluttertoast.showToast(
          msg: "Username not found",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        // Handle other error cases
        Fluttertoast.showToast(
          msg: "Login failed: ${response.statusCode}",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print('Error message: ${response.body}');
      }
    } catch (error) {
      print('HTTP request error: $error');
    }

    // Authentication failed
    return false;
  }

  @override
  void initState() {
    super.initState();
    _isObscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/sign.jpg'),
            fit: BoxFit.cover,
          ),
        ),





        padding: EdgeInsets.all(12.0),
        child: Container(
          padding: EdgeInsets.all(0.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/painting.json',
                height: 250.0,
                repeat: true,
                reverse: false,
                animate: true,
              ),
              SizedBox(
                height: 20,
              ),

              Text('Welcome Back!',style:TextStyle(fontSize: 40,color: const  Color(0xFFEAD2A8),fontWeight: FontWeight.w700)),
              Text('Login to your account',style:TextStyle(fontSize: 17,color: const  Color(0xFFEAD2A8),fontWeight: FontWeight.w100)),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: usernameController,
                cursorColor: Color(0xFFEAD2A8),
                style: TextStyle(fontSize: 21,color: Color(0xFF52412E),fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  floatingLabelStyle: TextStyle(color:Color(0xFFF5F5DC).withOpacity(0.9),fontWeight: FontWeight.w200),
                  contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                  filled: true,
                  fillColor : Color(0xFFEAD2A8).withOpacity(0.6),
                  labelText: 'Username*',
                  hintText: 'Enter your username',
                  hintStyle: TextStyle(fontSize: 18,color:Color(0xFF52412E),fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(fontSize: 18,color:Color(0xFF52412E),fontWeight: FontWeight.w200),
                    prefixIconColor:Color(0xFF52412E),
                  focusColor: Color(0xFF52412E),
                  hoverColor: Color(0xFF52412E).withOpacity(0.7),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF52412E)),
                    borderRadius: BorderRadius.circular(37.0),
                  ),
                  prefixIcon: Icon(Icons.person_outline_outlined),

                  iconColor: Color(0xFF52412E),
                  border: OutlineInputBorder(

                    borderSide: BorderSide.none,

                    borderRadius: BorderRadius.circular(37.0),
                  ),

                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 21,color:Color(0xFF52412E),fontWeight: FontWeight.w500),
                cursorColor: Color(0xFFEAD2A8),
                obscureText: _isObscure,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 18.0),
                  floatingLabelStyle: TextStyle(color:Color(0xFFF5F5DC).withOpacity(0.9),fontWeight: FontWeight.w200),

                  fillColor : Color(0xFFEAD2A8).withOpacity(0.6),
                  hoverColor: Color(0xFF52412E).withOpacity(0.7),
                  labelText: 'Password*',
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(fontSize: 18,color:Color(0xFF52412E),fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(fontSize: 18,color:Color(0xFF52412E),fontWeight: FontWeight.w200),
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                  suffixIcon: IconButton(
                    icon: _isObscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                    color: Color(0xFF52412E),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure; // Toggle the value when the icon is pressed
                      });
                    },
                  ),
                  prefixIconColor:Color(0xFF52412E),
                  suffixIconColor: Color(0xFF52412E),
                  iconColor: Color(0xFF52412E),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(37.0),
                  ),
                ),
              ),
              SizedBox(height: 5), // Add some spacing between the login button and the "Forgot Password?" link
              //
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {
              //       // Add your logic for handling the "Forgot Password?" action here
              //     },
              //     child: Container(
              //       color: Colors.transparent.withOpacity(0.2),
              //       child: Text(
              //         'Forgot Password?',
              //         style: TextStyle(fontSize: 16, color: Colors.blue,fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 0.0),
              SizedBox(
                height: 57,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Call the login function
                    final loginSuccess = await login();

                    if (loginSuccess) {
                      // Navigate to the NavigationScreen if login was successful
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NavigationScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF311F19),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(34.0),
                    ),
                  ),
                  child: Text('LOGIN',style: TextStyle(fontSize: 20,color:Color(0xFFEAD2A8) , ),),
                ),
              ),

              SizedBox(height: 170,),

            ],

          ),

        ),

      ),

    );
  }
}

