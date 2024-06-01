import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pangju/screens/home/home_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({required this.phoneNumber, super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _verificationController = TextEditingController();
  bool _isButtonEnabled = false;
  int _timerSeconds = 300; // 5분
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _verificationController.addListener(_validateVerificationCode);
  }

  void _validateVerificationCode() {
    setState(() {
      _isButtonEnabled = _verificationController.text.length ==
          6; // Assuming verification code is 6 digits
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  void _verifyCode() {
    // Code to verify the entered verification code
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _verificationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
            children: [
              TextFormField(
                initialValue: widget.phoneNumber,
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ), // 여백 설정
                ),
                style: const TextStyle(
                  color: Color(0xFF262626),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF37A3E0)),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 20,
                ),
                child: Center(
                  child: Text(
                    '인증문자 다시 받기 (${_formatDuration(_timerSeconds)})',
                    style: const TextStyle(
                      color: Color(0xFF37A3E0),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: _verificationController,
                keyboardType: TextInputType.number,
                cursorColor: const Color(0xFF37A3E0),
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: '인증번호를 입력해 주세요.',
                  hintStyle: const TextStyle(color: Color(0xFFA5A5A5)),
                  filled: true,
                  fillColor: const Color(0xFFF6F6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ), // 여백 설정
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _verifyCode : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: _isButtonEnabled
                      ? const Color(0xFF37A3E0)
                      : const Color(0xFFF1F1F1),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  '인증번호 확인',
                  style: TextStyle(
                    color: _isButtonEnabled
                        ? Colors.white
                        : const Color(0xFFC3C3C3),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // 이메일로 계정 찾기 로직 추가
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 6), // 여백 6 설정
                      minimumSize: const Size(0, 0),
                    ),
                    child: const Text(
                      '인증번호가 오지 않나요?',
                      style: TextStyle(
                        color: Color(0xFF37A3E0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
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

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
