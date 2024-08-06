import 'package:flutter/material.dart';
import 'package:tams/HOME/Pages/Home.dart';
import 'package:tams/Login/Pages/Login.dart';

import 'Splash_screen/splash_screen_pge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(), // Set SplashScreen as the initial route
    );
  }
}
