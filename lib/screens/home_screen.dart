import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                            padding: const EdgeInsets.only(top: 30, left: 20),
                            child: Image.asset(
                              'assets/images/main_logo.png',
                              width: 52,
                              fit: BoxFit.contain,
                            ), // 로고 이미지
                          ),
                          const SizedBox(height: 40),
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
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
              right: 20,
              top: 80,
              child: Image.asset('assets/images/main_character.png',
                  width: 140), // 주요 캐릭터 이미지
            ),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.only(top: 148), // 적절한 위치 조정
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC6C6C6).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 0), // 상단 그림자
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 42),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: CategoryButton(
                          imagePath: 'assets/images/icons/all.png',
                          label: '전체',
                          onTap: () {
                            print('전체 카테고리가 선택되었습니다.');
                          },
                        ),
                      ),
                      Flexible(
                        child: CategoryButton(
                          imagePath: 'assets/images/icons/online.png',
                          label: '온라인',
                          onTap: () {
                            print('온라인 카테고리가 선택되었습니다.');
                          },
                        ),
                      ),
                      Flexible(
                        child: CategoryButton(
                          imagePath: 'assets/images/icons/offline.png',
                          label: '오프라인',
                          onTap: () {
                            print('오프라인 카테고리가 선택되었습니다.');
                          },
                        ),
                      ),
                      Flexible(
                        child: CategoryButton(
                          imagePath: 'assets/images/icons/missing.png',
                          label: '실종·분실',
                          onTap: () {
                            print('실종·분실 카테고리가 선택되었습니다.');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 355, // 위치 조정 필요
              left: 0,
              right: 0,
              child: Container(
                height: 350,
                color: const Color(0xFFF6F6F6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 25,
                        top: 25,
                      ),
                      child: Text(
                        '인기 글',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 255,
                            margin: EdgeInsets.only(
                              left: index == 0 ? 25 : 15, // 첫 번째 아이템에는 왼쪽 패딩 유지
                              right: index == 9 ? 25 : 0, // 마지막 아이템에 오른쪽 패딩 추가
                              top: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.0),
                                  spreadRadius: 0.1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEE4EB), // 박스 색상
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: const Text(
                                      '온라인',
                                      style: TextStyle(
                                          color: Color(0xFFF14074), // 글씨 색상
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      '콘서트 같이 갔었던 분 찾아요.',
                                      style: TextStyle(
                                        color: Color(0xFF262626),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '여기에는 글의 내용이 들어갑니다. 더 많은 텍스트와 설명을 추가할 수 있습니다. 내용은 상세하게 기술됩니다.',
                                    style: TextStyle(
                                      color: Color(0xFF7B7B7B),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/icons/heart.svg',
                                        width: 24,
                                        height: 24,
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xFFA5A5A5),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 3),
                                        child: Text(
                                          '38',
                                          style: TextStyle(
                                            color: Color(0xFFA5A5A5),
                                          ),
                                        ), // 실제 카운트 값으로 대체
                                      ),
                                      const SizedBox(
                                          width: 15), // 아이콘과 카운트 사이 여백
                                      SvgPicture.asset(
                                        'assets/images/icons/chat.svg',
                                        width: 24,
                                        height: 24,
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xFFA5A5A5),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 3),
                                        child: Text(
                                          '11',
                                          style: TextStyle(
                                            color: Color(0xFFA5A5A5),
                                          ),
                                        ), // 실제 카운트 값으로 대체
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
  final VoidCallback onTap; // 클릭 이벤트 핸들러

  const CategoryButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap, // onTap 매개변수 추가
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap, // InkWell에 onTap 이벤트 연결
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 40, // 이미지 너비 조절
                fit: BoxFit.scaleDown, // 비율 유지하며 크기 조절
              ),
            ),
          ),
        ),
        const SizedBox(height: 8), // 이미지와 텍스트 사이의 여백
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14, // 글자 크기 조정
          ),
        ),
      ],
    );
  }
}
