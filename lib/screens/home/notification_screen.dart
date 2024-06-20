import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pangju/screens/home/keyword_settings_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Future<int> fetchKeywordCount() async {
    // 여기에 실제 API 호출 코드를 작성하세요.
    // 예시로 딜레이를 주고 임의의 숫자를 반환합니다.
    await Future.delayed(const Duration(seconds: 2));
    return 5; // 예시로 5개의 키워드를 반환
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            '알림',
            style: TextStyle(
              color: Color(0xFF262626),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              height: 1.3,
              letterSpacing: -0.2,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/icons/left_arrow.svg',
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF484848),
                      BlendMode.srcIn,
                    ),
                    height: 19.74,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // 뒤로 가기 동작
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: () {
                  // 편집 버튼 클릭 시 동작 추가
                },
                child: const Text(
                  '편집',
                  style: TextStyle(
                    color: Color(0xFF37A3E0),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ],
          elevation: 0,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48.0),
            child: Column(
              children: [
                TabBar(
                  labelColor: Color(0xFF484848),
                  unselectedLabelColor: Color(0xFFA5A5A5),
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    letterSpacing: -0.2,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                    letterSpacing: -0.2,
                  ),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 2.0,
                      color: Color(0xFF484848),
                    ),
                    insets: EdgeInsets.zero,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: '활동'),
                    Tab(text: '키워드'),
                    Tab(text: '맞춤'),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const Center(child: Text('활동 내용')),
            _buildKeywordTabContent(),
            _buildCustomTabContent(),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildKeywordTabContent() {
    return FutureBuilder<int>(
      future: fetchKeywordCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('오류가 발생했습니다.'));
        } else {
          final int keywordCount = snapshot.data ?? 0;
          final String message = keywordCount == 0
              ? '키워드 알림을 설정해보세요.'
              : '설정한 키워드 알림 $keywordCount개';

          return Column(
            children: [
              Container(
                height: 57,
                color: const Color(0xFFFBFBFB),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        letterSpacing: -0.2,
                        color: Color(0xFF7B7B7B),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const KeywordSettingsScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFFFFF),
                          side: const BorderSide(
                            color: Color(0xFFE5E5E5),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4,
                          ),
                          child: const Text(
                            '설정',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                              letterSpacing: -0.2,
                              color: Color(0xFF484848),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Center(child: Text('키워드 내용')),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildCustomTabContent() {
    return Column(
      children: [
        Container(
          height: 57,
          color: const Color(0xFFFBFBFB),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Text(
            '좋아한 글은 나만 볼 수 있어요.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.3,
              letterSpacing: -0.2,
              color: Color(0xFF7B7B7B),
            ),
          ),
        ),
        const Expanded(
          child: Center(child: Text('맞춤 내용')),
        ),
      ],
    );
  }
}
