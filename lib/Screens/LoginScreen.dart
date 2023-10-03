import '../forms/SignUpForm.dart';
import 'package:flutter/material.dart';
import '../forms/LoginForm.dart';

class AuthScreen extends StatefulWidget {

  final bool isSignUp; // Add this parameter to the AuthScreen widget

  const AuthScreen({Key? key, required this.isSignUp}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static bool _isSignUp = false;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.isSignUp;
  }


  void updateView() {
    setState(() {
      _isSignUp = !_isSignUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // LOGIN SCREEN
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            width: size.width * 0.88,
            height: size.height,
            left: _isSignUp ? -size.width * 0.76 : 0,
            child: GestureDetector(
              onTap: () {
                if (_isSignUp) {
                  setState(() {
                    _isSignUp = false;
                  });
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/sign.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 50),
                  child: _isSignUp
                      ? Align(
                    alignment: Alignment.centerRight,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSignUp = false;
                          });
                        },
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEAD2A8),
                          ),
                        ),
                      ),
                    ),
                  )
                      : LoginForm(),
                ),
              ),
            ),
          ),


          // SIGN UP SCREEN
          // SIGN UP SCREEN
          // SIGN UP SCREEN
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            width: size.width * 0.88,
            height: size.height,
            left: _isSignUp ? size.width * 0.12 : size.width * 0.88,
            child: Stack(
              children: [
                if (_isSignUp)
                  Positioned.fill(
                    child: SignUpForm(),
                  ), // Add the loginForm() widget here with Positioned.fill
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/login.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, top: 50),
                    child: !_isSignUp
                        ? Align(
                      alignment: Alignment.centerLeft,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSignUp = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 0),
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF52412E),
                              ),
                            ),

                          ),


                        ),
                      ),
                    )
                        : null,
                  ),

                ),
              ],
            ),
          ),


        ],
      ),
    );
  }

}

