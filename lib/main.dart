import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pangju/screens/home/home_screen.dart';
import 'package:pangju/screens/auth/welcome_screen.dart';
import 'package:pangju/widgets/bottom_navigation_bar.dart';
import 'package:pangju/screens/service/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.initializeNaverMapSdk();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkIfSignedUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSignedUp') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Pretendard',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            height: 1.3,
            letterSpacing: -0.2,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: FutureBuilder<bool>(
        future: checkIfSignedUp(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data == true) {
              return const BottomNavigationScreen();
            } else {
              return const WelcomeScreen();
            }
          }
        },
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        // 다른 라우트 추가
      },
    );
  }
}
