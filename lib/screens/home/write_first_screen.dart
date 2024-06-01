import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pangju/screens/home/utils.dart';
import 'bottom_bar.dart'; // 새로운 BottomBar 위젯을 임포트
import 'write_second_screen.dart'; // 새로 만든 두 번째 화면 임포트

class WriteFirstScreen extends StatefulWidget {
  const WriteFirstScreen({super.key});

  @override
  _WriteFirstScreenState createState() => _WriteFirstScreenState();
}

class _WriteFirstScreenState extends State<WriteFirstScreen> {
  String? selectedCategory;
  Set<String> selectedSubcategories = {};
  String? selectedGender;
  String? selectedAgeGroup;
  Set<String> selectedRegions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          '글쓰기',
          style: TextStyle(color: Colors.black), // 글씨 색상 변경
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0), // 왼쪽 마진 추가
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/images/icons/remove.svg',
              width: 20,
              height: 20,
            ),
            onPressed: () {
              showCancelDialog(context); // 글쓰기 취소 알림 표시
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () {
                // 임시저장 버튼 클릭 시 동작 추가
              },
              child: const Text(
                '임시저장',
                style: TextStyle(
                  color: Color(0xFF37A3E0),
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
        elevation: 0, // 그림자 없애기
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 0), // 여백 추가
              RichText(
                text: const TextSpan(
                  text: '카테고리 대분류 (중복 선택 가능)',
                  style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Color(0xFFEF470A),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5), // 여백 추가
              const Text(
                '찾으시는 사람 또는 물건의 유형을 선택해주세요.',
                style: TextStyle(
                  color: Color(0xFFA5A5A5),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16), // 여백 추가
              Center(
                child: Column(
                  children: [
                    _buildCategoryBox(
                      title: '오프라인 만남',
                      description: '오프라인에서 만난 사람을 찾아요',
                      iconPath: 'assets/images/icons/offline.png',
                      iconBgColor: const Color(0xFFE6F6EB),
                      value: 'offline',
                    ),
                    const SizedBox(height: 8), // 여백 추가
                    _buildCategoryBox(
                      title: '온라인 만남',
                      description: '온라인에서 만난 사람을 찾아요',
                      iconPath: 'assets/images/icons/online.png',
                      iconBgColor: const Color(0xFFFEE4EB),
                      value: 'online',
                    ),
                    const SizedBox(height: 8), // 여백 추가
                    _buildCategoryBox(
                      title: '분실·신고',
                      description: '물건,사람 혹은 동물을 찾고 있어요',
                      iconPath: 'assets/images/icons/missing.png',
                      iconBgColor: const Color(0xFFFBE8E5),
                      value: 'missing',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40), // 여백 추가
              RichText(
                text: const TextSpan(
                  text: '카테고리 소분류 (중복 선택 가능)',
                  style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Color(0xFFEF470A),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5), // 여백 추가
              const Text(
                '찾으시는 사람 또는 물건의 유형을 선택해주세요.',
                style: TextStyle(
                  color: Color(0xFFA5A5A5),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16), // 여백 추가
              Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildSubcategoryBox('가족'),
                    _buildSubcategoryBox('친구'),
                    _buildSubcategoryBox('스승 / 제자'),
                    _buildSubcategoryBox('반려동물'),
                    _buildSubcategoryBox('사물'),
                    _buildSubcategoryBox('기타'),
                  ],
                ),
              ),
              const SizedBox(height: 40), // 여백 추가
              RichText(
                text: const TextSpan(
                  text: '추정 성별 (선택)',
                  style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5), // 여백 추가
              const Text(
                '찾으시는 사람 또는 동물의 성별을 선택해주세요.',
                style: TextStyle(
                  color: Color(0xFFA5A5A5),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16), // 여백 추가
              Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildGenderBox('남자'),
                    _buildGenderBox('여자'),
                    _buildGenderBox('기타'),
                  ],
                ),
              ),
              const SizedBox(height: 40), // 여백 추가
              RichText(
                text: const TextSpan(
                  text: '추정 나이 (선택)',
                  style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5), // 여백 추가
              const Text(
                '찾는 사람의 추정 나이를 선택해주세요.',
                style: TextStyle(
                  color: Color(0xFFA5A5A5),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16), // 여백 추가
              Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildAgeGroupBox('10대 이하'),
                    _buildAgeGroupBox('10대'),
                    _buildAgeGroupBox('20대'),
                    _buildAgeGroupBox('30대'),
                    _buildAgeGroupBox('40대'),
                    _buildAgeGroupBox('50대'),
                    _buildAgeGroupBox('60대'),
                    _buildAgeGroupBox('70대 이상'),
                  ],
                ),
              ),
              const SizedBox(height: 40), // 여백 추가
              RichText(
                text: const TextSpan(
                  text: '지역 (선택)',
                  style: TextStyle(
                    color: Color(0xFF262626),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5), // 여백 추가
              const Text(
                '찾는 사람과 만났던 장소, 혹은 잃어버린 물건의 위치를 선택해주세요.',
                style: TextStyle(
                  color: Color(0xFFA5A5A5),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16), // 여백 추가
              Center(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor:
                          Colors.transparent, // 배경색을 투명으로 설정하여 팝업 외부를 어둡게 처리
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.8,
                          child: StatefulBuilder(
                            // StatefulBuilder 추가
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      margin: const EdgeInsets.only(top: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      '지역을 선택해 주세요 (중복 가능)',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      '찾고 있는 사람과 만났던 장소,\n혹은 잃어버린 물건의 위치를 선택해 주세요.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0XFFA5A5A5),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 35),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: (110 / 48),
                                          ),
                                          itemCount: 18,
                                          itemBuilder: (context, index) {
                                            final regions = [
                                              '서울',
                                              '경기',
                                              '인천',
                                              '대전',
                                              '충북',
                                              '충남',
                                              '부산',
                                              '대구',
                                              '경북',
                                              '경남',
                                              '울산',
                                              '광주',
                                              '전북',
                                              '전남',
                                              '세종',
                                              '강원',
                                              '제주',
                                              '기타'
                                            ];
                                            return _buildRegionBox(
                                                regions[index], setState);
                                          },
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          // 부모 위젯의 상태 업데이트
                                        });
                                      },
                                      child: Container(
                                        width: 350,
                                        height: 47,
                                        decoration: BoxDecoration(
                                          color: selectedRegions.isNotEmpty
                                              ? const Color(0xFF37A3E0)
                                              : const Color(0xFFF1F1F1),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '선택완료',
                                            style: TextStyle(
                                              color: selectedRegions.isNotEmpty
                                                  ? Colors.white
                                                  : const Color(0xFFC3C3C3),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ).then((_) {
                      setState(() {}); // 팝업이 닫힌 후 부모 위젯의 상태를 업데이트
                    });
                  },
                  child: Container(
                    width: 350,
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedRegions.isNotEmpty
                              ? selectedRegions.join(' / ')
                              : '지역을 선택해주세요.',
                          style: const TextStyle(
                            color: Color(0xFF484848),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(
                            'assets/images/icons/rightarrow.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20), // 여백 추가
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        onNext: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const WriteSecondScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
        onRegister: () {
          // Register button logic
        },
        isFirstPage: true, // 첫 번째 페이지에서는 다음 버튼이 활성화
      ),
      backgroundColor: Colors.white, // Body background color
    );
  }

  Widget _buildCategoryBox({
    required String title,
    required String description,
    required String iconPath,
    required Color iconBgColor,
    required String value,
  }) {
    bool isSelected = selectedCategory == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = value;
        });
      },
      child: Container(
        width: 350,
        height: 62,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? const Color(0xFF7B7B7B) : const Color(0xFFE5E5E5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16), // 패딩 조정
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우 정렬
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Image.asset(
                      iconPath,
                      width: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12), // 아이콘과 텍스트 사이 여백
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, // 수직 가운데 정렬
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF484848),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2), // 여백 추가
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFFA5A5A5),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(color: const Color(0xFFE5E5E5)),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? Center(
                      child: Image.asset(
                        'assets/images/icons/checked.png',
                        width: 14,
                        height: 14,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryBox(String title) {
    bool isSelected = selectedSubcategories.contains(title);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSubcategories.remove(title);
          } else {
            selectedSubcategories.add(title);
          }
        });
      },
      child: Container(
        width: 171,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? const Color(0xFF7B7B7B) : const Color(0xFFE5E5E5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center, // 내용 가운데 정렬
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF484848),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderBox(String title) {
    bool isSelected = selectedGender == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = title;
        });
      },
      child: Container(
        width: 171,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? const Color(0xFF7B7B7B) : const Color(0xFFE5E5E5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF484848),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildAgeGroupBox(String title) {
    bool isSelected = selectedAgeGroup == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAgeGroup = title;
        });
      },
      child: Container(
        width: 171,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? const Color(0xFF7B7B7B) : const Color(0xFFE5E5E5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF484848),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildRegionBox(String title, StateSetter setState) {
    bool isSelected = selectedRegions.contains(title);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedRegions.remove(title);
          } else {
            selectedRegions.add(title);
          }
        });
      },
      child: Container(
        width: 110,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? const Color(0xFF7B7B7B) : const Color(0xFFE5E5E5),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color:
                isSelected ? const Color(0xFF484848) : const Color(0xFF484848),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
