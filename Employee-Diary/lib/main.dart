import 'package:flutter/material.dart';
import 'package:crud_project/firebase_options.dart';
import 'package:crud_project/services/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crud_project/Pages/login.dart'; // Import your login page
import 'package:crud_project/Pages/signup.dart'; // Import your signup page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // Define your app's theme here
      ),
      // Define routes for navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), // SplashScreen as the initial screen
        '/login': (context) => const LoginScreen(), // LoginScreen route
        '/signup': (context) => const SignupScreen(), // SignupScreen route
      },
      // Handle unknown routes (optional)
      // onUnknownRoute: (settings) {
      //   return MaterialPageRoute(
      //     builder: (context) => const Scaffold(
      //       body: Center(
      //         child: Text('Route not found!'),
      //       ),
      //     ),
      //   );
      // },
    );
  }
}
