import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align items to the left
            children: [
              SizedBox(height: 40),

              // Sign in Text
              Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'NextTrial', // Font "Next Trial"
                ),
              ),
              SizedBox(height: 20),

              // Email/Phone input (Rounded and without hint text)
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Your email address',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'NextTrial', // Font "Next Trial" for label
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade700),
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  hintStyle: TextStyle(
                      fontFamily: 'NextTrial'), // Font "Next Trial" for hint
                ),
              ),
              SizedBox(height: 20),

              // Password input (Rounded and without hint text)
              TextField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'NextTrial', // Font "Next Trial" for label
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green.shade700),
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey.shade400,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  hintStyle: TextStyle(
                      fontFamily: 'NextTrial'), // Font "Next Trial" for hint
                ),
              ),
              SizedBox(
                  height: 20), // Space between password and forgot password

              // Sign in button (full width, rounded)
              ElevatedButton(
                onPressed: () {
                  // Handle sign in
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0B5E4F), // Dark green background
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 48), // Full width
                ),
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NextTrial', // Font "Next Trial"
                  ),
                ),
              ),
              SizedBox(
                  height:
                      10), // Space before "Forgot Password?" and "Don't have an account?"

              // Center the "Forgot Password?" and "Don't have an account yet?" text
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centered
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'NextTrial', // Font "Next Trial"
                      ),
                    ),
                  ),
                  Text(
                    "or", // "or" text between the two buttons
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'NextTrial', // Font "Next Trial"
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle registration or sign up
                    },
                    child: Text(
                      "Dont have an account yet?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B5E4F), // Green color for the text
                        fontFamily: 'NextTrial', // Font "Next Trial"
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
