import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F6FD), // 배경 색상 설정
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 18),
                            child: Image.asset(
                              'assets/images/main_logo.png',
                              width: 52,
                              fit: BoxFit.contain,
                            ), // 로고 이미지
                          ),
                          const SizedBox(height: 40),
                          const Padding(
                            padding: EdgeInsets.only(left: 18),
                            child: Text(
                              '팡쥬에서 보고 싶었던\n사람을 찾아보세요.',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Color(0xFF3090CC),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(), // 비워둔 공간
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: 35,
              top: 80,
              child: Image.asset('assets/images/main_character.png',
                  width: 140), // 주요 캐릭터 이미지
            ),
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(top: 178), // 적절한 위치 조정
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC6C6C6).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0), // 상단 그림자
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    left: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CategoryButton(
                        imagePath: 'assets/images/icons/all.png',
                        label: '전체',
                      ),
                      CategoryButton(
                        imagePath: 'assets/images/icons/online.png',
                        label: '온라인',
                      ),
                      CategoryButton(
                        imagePath: 'assets/images/icons/offline.png',
                        label: '오프라인',
                      ),
                      CategoryButton(
                        imagePath: 'assets/images/icons/missing.png',
                        label: '실종·분실',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String imagePath;
  final String label;

  const CategoryButton(
      {super.key, required this.imagePath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(imagePath,
              width: 72, height: 72), // Use full size of container
          const SizedBox(height: 4), // Small space between icon and text
          Text(label),
        ],
      ),
    );
  }
}
