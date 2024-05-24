import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WritePage extends StatelessWidget {
  const WritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('글쓰기'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0), // 왼쪽 마진 추가
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/images/icons/remove.svg', // SVG 아이콘 경로
              width: 24, // 적절한 크기로 설정
              height: 24, // 적절한 크기로 설정
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // 오른쪽 마진 추가
            child: TextButton(
              onPressed: () {
                // 임시저장 버튼 클릭 시 동작 추가
              },
              child: const Text(
                '임시저장',
                style: TextStyle(
                  color: Color(0xFF37A3E0), // 지정된 색상
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('여기에 글쓰기 화면의 내용을 추가하세요.'),
      ),
    );
  }
}
