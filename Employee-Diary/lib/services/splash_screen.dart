import 'dart:async';
import 'package:crud_project/Pages/login.dart';
import 'package:flutter/material.dart';
 // Adjust the import path based on your project structure

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay to display the splash screen
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
      MaterialPageRoute(builder: (context) => LoginScreen())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Adjust color as needed
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png', // Adjust the path as per your project structure
              height: 150, // Adjust height as needed
            ),
            SizedBox(height: 20),
            Text(
              'Employee Diary\n(Founder-Dhruv)',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
