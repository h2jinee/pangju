import 'package:flutter/material.dart';

import 'login_screen.dart'; // login_screen.dart 파일을 import 합니다.
import 'phone_verification_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F6FD), // 배경색을 설정
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/main_character.png',
                    ),
                    const SizedBox(height: 15), // 이미지 사이에 간격 추가
                    Image.asset(
                      'assets/images/main_logo.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: const Color(0xFF37A3E0),
                  minimumSize: const Size(350, 50),
                ),
                child: const Text(
                  '시작하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3, // Line height 130%
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '이미 계정이 있나요?',
                    style: TextStyle(
                      color: Color(0xFF7B7B7B),
                      fontSize: 16,
                      height: 1.3, // Line height 130%
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 6), // 여백 6 설정
                      minimumSize: const Size(0, 0),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: Color(0xFF37A3E0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3, // Line height 130%
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
