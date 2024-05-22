import 'package:flutter/material.dart';

class WritePage extends StatelessWidget {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글쓰기'),
      ),
      body: const Center(
        child: Text('여기에 글쓰기 화면의 내용을 추가하세요.'),
      ),
    );
  }
}
