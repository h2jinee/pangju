import 'package:flutter/material.dart';
import 'package:pangju/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'PretendardBold',
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
