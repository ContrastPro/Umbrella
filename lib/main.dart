import 'package:flutter/material.dart';
import 'package:umbrella/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Umbrella',
      home: Scaffold(body: HomePage()),
    );
  }
}

// flutter build apk --target-platform android-arm
