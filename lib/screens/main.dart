import 'package:flutter/material.dart';
import 'package:pangju/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Future<void> _clearSignUpStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('isSignedUp'); // 회원가입 상태 초기화
  // }

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
            height: 1.2,
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
            ); // 로딩 중 표시
          } else {
            if (snapshot.data == true) {
              return const HomePage(); // 회원가입이 완료된 경우 홈 화면으로 이동
            } else {
              // return const WelcomeScreen(); // 회원가입이 완료되지 않은 경우 회원가입/로그인 화면으로 이동
              return const HomePage(); // 회원가입이 완료되지 않은 경우 회원가입/로그인 화면으로 이동
            }
          }
        },
      ),
      routes: {
        '/home': (context) => const HomePage(),
        '/items': (context) => const HomePage(),
      },
    );
  }
}
