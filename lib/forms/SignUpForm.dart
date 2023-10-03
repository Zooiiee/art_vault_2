import 'package:art_vault_2/Screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:art_vault_2/Screens/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Provider/AuthService.dart';
import '../Screens/MainDrawerScreen.dart';

class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isObscure = true;
  bool authenticated= false;
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  //TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isObscure = true;
  }

  // Validate email format
  bool _isEmailValid(String email) {
    final emailRegExp =
    RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  // Simulate uniqueness check for the username (replace with your actual logic)
  bool _isUsernameUnique(String username) {
    // You should implement the logic to check if the username is unique here.
    // For this example, we always return true.
    return true;
  }

  Future<void> registerUser() async {
    // Check if the username is not empty
    if (usernameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Username is required",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Check if the email is in a valid format
    if (!_isEmailValid(emailController.text)) {
      Fluttertoast.showToast(
        msg: "Invalid email format",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Perform uniqueness check for the username (replace with your logic)
    if (!_isUsernameUnique(usernameController.text)) {
      Fluttertoast.showToast(
        msg: "Username is already taken",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final Uri apiUrl = Uri.parse('${ApiConfig.baseUrl}/register');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final String formattedJoiningDate = DateFormat('dd MMMM, yyyy').format(DateTime.now());

    final Map<String, dynamic> userData = {
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'name': nameController.text,
      'joiningDate': formattedJoiningDate,
    };

    final String userJson = jsonEncode(userData);

    try {
      final http.Response response = await http.post(
        apiUrl,
        headers: headers,
        body: userJson,
      );

      if (response.statusCode == 200) {
        // Authentication successful
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('User data: $data');
        final responseData = jsonDecode(response.body);

        // Store the token after successful login
        final authService = AuthService();
        final generatedUid = data['uid'].toString(); // Replace with your token data
        await authService.storeToken(generatedUid);

        // Proceed with navigation
        Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationScreen()));

        Fluttertoast.showToast(
          msg: "Registration successful. Generated UID: $generatedUid",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // Proceed with navigation



      } else {
        // Handle registration failure
        Fluttertoast.showToast(
          msg: "Username Already Taken",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        print('Error message: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(

          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login.webp'),
              fit: BoxFit.cover,
            ),
          ),

          padding: EdgeInsets.only(top: 45,left: 16,right: 16),
          child: Column(

            children: [
              Lottie.asset(
                'assets/painting.json',
                height: 180.0,
                repeat: true,
                reverse: false,
                animate: true,
              ),
              SizedBox(
                height: 20,
              ),
              Text('Unlock the Vault!',style:TextStyle(fontSize: 32,color: const  Color(0xFF311F19),fontWeight: FontWeight.w700)),
              Text('Sign Up and Unlock the Beauty of Art',style:TextStyle(fontSize: 17,color: const  Color(0xFF311F19),fontWeight: FontWeight.w100)),

              SizedBox(
                height: 22
              ),

              TextFormField(

                controller: nameController,
                cursorColor: Color(0xFFEAD2A8),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20,color: Color(0xFFF5F5DC)),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  filled: true,
                  fillColor : Color(0xFF311F19).withOpacity(0.7),
                  hoverColor:Color(0xFFB99976),
                  labelText: 'Full Name*',
                  hintText: 'Enter your name',
                  floatingLabelStyle: TextStyle(color:Color(0xFFF5F5DC).withOpacity(0.9),fontWeight: FontWeight.w200),

                  hintStyle: TextStyle(fontSize: 17,color:Color(0xFFEAD2A8),fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(fontSize: 17,color:Color(0xFFEAD2A8),fontWeight: FontWeight.w200),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(37.0),
                  ),
                  prefixIcon: Icon(Icons.person_outline_outlined,color: Color(0xFFEAD2A8),),

                  border: OutlineInputBorder(

                    borderSide: BorderSide.none,

                    borderRadius: BorderRadius.circular(37.0),
                  ),

                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(

                controller: usernameController,
                cursorColor: Color(0xFFEAD2A8),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20,color: Color(0xFFF5F5DC)),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  filled: true,
                  fillColor : Color(0xFF311F19).withOpacity(0.7),
                  hoverColor:Color(0xFFB99976),
                  labelText: 'Username*',
                  hintText: 'Enter your desired username',
                  floatingLabelStyle: TextStyle(color:Color(0xFFF5F5DC).withOpacity(0.9),fontWeight: FontWeight.w200),

                  hintStyle: TextStyle(fontSize: 17,color:Color(0xFFEAD2A8),fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(fontSize: 17,color:Color(0xFFEAD2A8),fontWeight: FontWeight.w200),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(37.0),
                  ),
                  prefixIcon: Icon(Icons.person_outline_outlined,color: Color(0xFFEAD2A8),),

                  border: OutlineInputBorder(

                    borderSide: BorderSide.none,

                    borderRadius: BorderRadius.circular(37.0),
                  ),

                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                style: TextStyle(fontSize: 20,color: Color(0xFFF5F5DC)),
                cursorColor: Color(0xFFEAD2A8),
                decoration: InputDecoration(
                  floatingLabelStyle: TextStyle(color:Color(0xFFF5F5DC).withOpacity(0.9),fontWeight: FontWeight.w200),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  filled: true,

                  fillColor : Color(0xFF311F19).withOpacity(0.7),
                  hoverColor:Color(0xFFB99976),
                  labelText: 'E-mail*',
                  hintText: 'Enter your email id',
                  hintStyle: TextStyle(fontSize: 17,color:Color(0xFFEAD2A8),fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(fontSize: 17,color:Color(0xFFEAD2A8),fontWeight: FontWeight.w200),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(37.0),
                  ),
                  prefixIcon: Icon(Icons.email_outlined,color: Color(0xFFEAD2A8),),

                  border: OutlineInputBorder(

                    borderSide: BorderSide.none,

                    borderRadius: BorderRadius.circular(37.0),
                  ),

                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                cursorColor: Color(0xFFEAD2A8),
                style: TextStyle(fontSize: 20,color: Color(0xFFF5F5DC)),
                obscureText: isObscure,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  filled: true,
                  fillColor : Color(0xFF311F19).withOpacity(0.7),
                  hoverColor:Color(0xFFB99976),
                  labelText: 'Password*',
                  hintText: 'Enter a password',
                  hintStyle: TextStyle(fontSize: 17,color:Color(0xFFEAD2A8),fontWeight: FontWeight.w100),
                  labelStyle: TextStyle(fontSize: 17,color:Color(0xFFEAD2A8),fontWeight: FontWeight.w200),
                  floatingLabelStyle: TextStyle(color:Color(0xFFF5F5DC).withOpacity(0.9),fontWeight: FontWeight.w200),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(37.0),
                  ),
                  prefixIcon: Icon(Icons.key_outlined,color: Color(0xFFEAD2A8),),
                  suffixIcon: IconButton(
                    icon: isObscure ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                    color: Color(0xFFEAD2A8),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure; // Toggle the value when the icon is pressed
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(37.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {

                    await registerUser(); // Wait for registration to complete
                    // if (authenticated) {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => NavigationScreen()),
                    //   );
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFEAD2A8),      // Color(0xFF876E4B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(37.0),
                    ),
                  ),
                  child: Text('SIGN UP',style: TextStyle(fontSize: 20,color: Color(0xFF311F19) ,fontWeight: FontWeight.w500),),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Text('------------OR--------------',style:TextStyle(fontSize: 17,color: const  Color(0xFF311F19),fontWeight: FontWeight.w700)),
              // SizedBox(
              //   height: 20,
              // ),
              // SizedBox(
              //   height: 50,
              //   width: double.infinity,
              //   child: ElevatedButton.icon(
              //     onPressed: () {
              //       // Perform sign in with Google action here
              //     },
              //     style: ElevatedButton.styleFrom(
              //       primary: Color(0xFFEAD2A8),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(37.0),
              //       ),
              //     ),
              //     icon: Image.asset('assets/search.png',height: 28,),
              //     label: Text(
              //       'Sign-up with Google',
              //       style: TextStyle(
              //         fontSize: 20,
              //         color: Color(0xFF311F19),
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 400.0),

            ],
          ),
        ),
      ),
    );
  }
}

