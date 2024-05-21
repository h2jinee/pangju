import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();
  final List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _itemsPerPage = 15;
  int _selectedCategoryIndex = 0;
  int _selectedIndex = 0; // 하단 네비게이션 바 선택 인덱스
  bool _showNotificationBox = true; // 추가된 변수
  bool _hasMoreItems = true; // 추가된 변수

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreItems) {
        _loadMoreItems();
      }
    });
  }

  Future<void> _fetchItems() async {
    if (!_hasMoreItems) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 사용자 이름과 비밀번호를 Base64로 인코딩
      String username = 'user'; // 기본 사용자 이름
      String password =
          '7a5f7c5c-306a-49ef-8265-71de2327efaf'; // Postman에서 사용한 비밀번호
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:8081/api/items?page=$_currentPage&size=$_itemsPerPage'), // 페이지 번호 및 사이즈 추가
        headers: {
          'Authorization': basicAuth, // 인증 헤더 추가
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> newItems =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        if (newItems.isEmpty) {
          setState(() {
            _hasMoreItems = false; // 더 이상 아이템이 없음을 표시
            _isLoading = false;
          });
          return; // 더 이상 데이터를 가져오지 않도록 반환
        }
        setState(() {
          _items.addAll(newItems); // 중복 체크를 제거하고 데이터 추가
          _isLoading = false;
          _currentPage++; // 페이지 번호 증가
        });
      } else {
        print('Failed to load items with status: ${response.statusCode}');
        throw Exception('Failed to load items');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadMoreItems() {
    if (_isLoading || !_hasMoreItems) return; // 수정된 부분

    _fetchItems();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _onCategoryTap(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });

    // 최신순(0)이나 댓글순(3) 선택 시에만 스크롤 애니메이션
    if (index == 0 || index == 3) {
      _categoryScrollController.animateTo(
        index * 100.0, // 임의의 값, 각 아이템의 넓이로 조정 필요
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // 여기에 각 탭에 대한 동작을 추가할 수 있습니다.
  }

  void _hideNotificationBox() {
    setState(() {
      _showNotificationBox = false;
    });
  }

  Color _getMainCategoryBackgroundColor(String mainCategory) {
    switch (mainCategory) {
      case '오프라인':
        return const Color(0xFFE6F6EB);
      case '온라인':
        return const Color(0xFFFEE4EB);
      case '분실·신고':
        return const Color(0xFFFBE8E5);
      default:
        return Colors.grey;
    }
  }

  Color _getMainCategoryTextColor(String mainCategory) {
    switch (mainCategory) {
      case '오프라인':
        return const Color(0xFF17944B);
      case '온라인':
        return const Color(0xFFF14074);
      case '분실·신고':
        return const Color(0xFFEF470A);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F6FD), // 배경 색상 설정
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // 로고 및 소개 텍스트
              Padding(
                padding: const EdgeInsets.only(right: 0, top: 30),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0, left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/main_logo.png',
                                  width: 52,
                                  fit: BoxFit.contain,
                                ), // 로고 이미지
                                const SizedBox(height: 40),
                                const Text(
                                  '팡쥬에서 보고 싶었던\n사람을 찾아보세요.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Color(0xFF3090CC),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Transform.translate(
                            offset: const Offset(-20, 40),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Image.asset(
                                'assets/images/main_character.png',
                                width: 140, // 주요 캐릭터 이미지
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 20,
                      child: SvgPicture.asset(
                        'assets/images/icons/bell.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ), // 간격 조정
              Container(
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
                  padding: const EdgeInsets.only(top: 35, bottom: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CategoryButton(
                            imagePath: 'assets/images/icons/all.png',
                            label: '전체',
                            onTap: () {
                              print('전체 카테고리가 선택되었습니다.');
                            },
                          ),
                          CategoryButton(
                            imagePath: 'assets/images/icons/online.png',
                            label: '온라인',
                            onTap: () {
                              print('온라인 카테고리가 선택되었습니다.');
                            },
                          ),
                          CategoryButton(
                            imagePath: 'assets/images/icons/offline.png',
                            label: '오프라인',
                            onTap: () {
                              print('오프라인 카테고리가 선택되었습니다.');
                            },
                          ),
                          CategoryButton(
                            imagePath: 'assets/images/icons/missing.png',
                            label: '실종·분실',
                            onTap: () {
                              print('실종·분실 카테고리가 선택되었습니다.');
                            },
                          ),
                        ],
                      ),
                      // 새로운 박스 추가 부분
                      if (_showNotificationBox)
                        Container(
                          width: 350,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(top: 30, bottom: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/icons/missing.png',
                                        width: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        '긴급',
                                        style: TextStyle(
                                          height: 1.3,
                                          fontSize: 16,
                                          color: Color(0xFFE14004),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: _hideNotificationBox,
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color:
                                            Color(0x80262626), // 투명도 50% 추가된 색상
                                        shape: BoxShape.circle, // 동그라미 모양
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/icons/remove.png',
                                          width: 14,
                                          height: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '[부산경찰청] 경찰은 부산진구에서 실종된 김도연씨(여, 78세)를 찾고 있습니다 - 146cm, 59kg, 주황색 상의, 하늘색 하의',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Color(0xFF585858),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // 인기 글
              Container(
                height: 330,
                color: const Color(0xFFF6F6F6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 25,
                        top: 20,
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
                                        width: 15,
                                      ), // 아이콘과 카운트 사이 여백
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

              // 여백 줄임
              Padding(
                padding: const EdgeInsets.only(top: 0), // 여백 줄임
                child: Container(
                  color: Colors.white,
                  child: SizedBox(
                    height: 65,
                    child: ListView.builder(
                      controller: _categoryScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: 4, // CategoryBox 갯수
                      itemBuilder: (context, index) {
                        // 각 CategoryBox에 대한 데이터를 리스트로 저장
                        final categoryData = [
                          {
                            'iconPath': 'assets/images/icons/clock.svg',
                            'text': '최신순',
                            'backgroundColor': const Color(0xFF37A3E0),
                            'textColor': Colors.white,
                            'isSelected': true,
                          },
                          {
                            'iconPath': 'assets/images/icons/place.svg',
                            'text': '내근처',
                            'backgroundColor': Colors.white,
                            'textColor': const Color(0xFF484848),
                            'isSelected': false,
                          },
                          {
                            'iconPath': 'assets/images/icons/heart.svg',
                            'text': '공감순',
                            'backgroundColor': Colors.white,
                            'textColor': const Color(0xFF484848),
                            'isSelected': false,
                          },
                          {
                            'iconPath': 'assets/images/icons/chat.svg',
                            'text': '댓글순',
                            'backgroundColor': Colors.white,
                            'textColor': const Color(0xFF484848),
                            'isSelected': false,
                          },
                        ];

                        // 선택된 상태에 따라 배경 색상과 텍스트 색상을 업데이트
                        bool isSelected = _selectedCategoryIndex == index;

                        // 인덱스와 함께 CategoryBox 생성
                        return GestureDetector(
                          onTap: () => _onCategoryTap(index),
                          child: CategoryBox(
                            iconPath: categoryData[index]['iconPath'] as String,
                            text: categoryData[index]['text'] as String,
                            backgroundColor: isSelected
                                ? const Color(0xFF37A3E0)
                                : Colors.white,
                            textColor: isSelected
                                ? Colors.white
                                : const Color(0xFF484848),
                            isSelected: isSelected,
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 23,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                _getMainCategoryBackgroundColor(
                                                    item['mainCategory']),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                          child: Text(
                                            item['mainCategory'],
                                            style: TextStyle(
                                              color: _getMainCategoryTextColor(
                                                  item['mainCategory']),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF6F6F6),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                          child: Text(
                                            item['status'],
                                            style: const TextStyle(
                                              color: Color(0xFF484848),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        item['content'],
                                        style: const TextStyle(
                                          color: Color(0xFF262626),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      item['description'],
                                      style: const TextStyle(
                                        color: Color(0xFF7B7B7B),
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3),
                                          child: Text(
                                            '${item['heartCount']}',
                                            style: const TextStyle(
                                              color: Color(0xFFA5A5A5),
                                            ),
                                          ), // 실제 카운트 값으로 대체
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ), // 아이콘과 카운트 사이 여백
                                        SvgPicture.asset(
                                          'assets/images/icons/chat.svg',
                                          width: 24,
                                          height: 24,
                                          colorFilter: const ColorFilter.mode(
                                            Color(0xFFA5A5A5),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 3),
                                          child: Text(
                                            '${item['chatCount']}',
                                            style: const TextStyle(
                                              color: Color(0xFFA5A5A5),
                                            ),
                                          ), // 실제 카운트 값으로 대체
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (item['image'] != null)
                                Container(
                                  width: 80,
                                  height: 80,
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(item['image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (index != _items.length - 1) // 마지막 인덱스가 아니면
                          Center(
                            child: Container(
                              height: 1,
                              width: 350,
                              color: const Color(0xFFE5E5E5),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // 하단 홈 화면
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE5E5E5), // stroke color
                  width: 1.0,
                ),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF37A3E0),
              unselectedItemColor: const Color(0xFF484848),
              onTap: _onItemTapped,
              currentIndex: _selectedIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5), // 상하 간격 조정
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/images/icons/home.svg',
                            colorFilter: ColorFilter.mode(
                              _selectedIndex == 0
                                  ? const Color(0xFF37A3E0)
                                  : const Color(0xFF484848),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Text(
                          '홈',
                          style: TextStyle(
                            color: _selectedIndex == 0
                                ? const Color(0xFF37A3E0)
                                : const Color(0xFF484848),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5), // 상하 간격 조정
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/images/icons/place.svg',
                            colorFilter: ColorFilter.mode(
                              _selectedIndex == 1
                                  ? const Color(0xFF37A3E0)
                                  : const Color(0xFF484848),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Text(
                          '내 근처',
                          style: TextStyle(
                            color: _selectedIndex == 1
                                ? const Color(0xFF37A3E0)
                                : const Color(0xFF484848),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5), // 상하 간격 조정
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/images/icons/chat.svg',
                            colorFilter: ColorFilter.mode(
                              _selectedIndex == 2
                                  ? const Color(0xFF37A3E0)
                                  : const Color(0xFF484848),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Text(
                          '채팅',
                          style: TextStyle(
                            color: _selectedIndex == 2
                                ? const Color(0xFF37A3E0)
                                : const Color(0xFF484848),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5), // 상하 간격 조정
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            'assets/images/icons/mypage.svg',
                            colorFilter: ColorFilter.mode(
                              _selectedIndex == 3
                                  ? const Color(0xFF37A3E0)
                                  : const Color(0xFF484848),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        Text(
                          '마이',
                          style: TextStyle(
                            color: _selectedIndex == 3
                                ? const Color(0xFF37A3E0)
                                : const Color(0xFF484848),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  label: '',
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 100, // SafeArea 적용
            right: 20,
            child: SafeArea(
              child: FloatingActionButton(
                onPressed: () {
                  // 글쓰기 버튼 클릭 시 동작
                },
                backgroundColor: const Color(0xFF37A3E0),
                shape: const CircleBorder(),
                elevation: 0,
                child: SvgPicture.asset(
                  'assets/images/icons/write.svg',
                  width: 28,
                  height: 28,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ), // 동그라미 모양으로 변경
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryBox extends StatelessWidget {
  final String iconPath;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool isSelected;
  final int index;

  const CategoryBox({
    super.key,
    required this.iconPath,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.isSelected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 25,
        left: index == 0 ? 25 : 8, // 첫 번째 아이템에는 왼쪽 패딩 유지
        right: index == 3 ? 10 : 0, // 마지막 아이템에 오른쪽 패딩 추가
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
          border: isSelected
              ? null
              : Border.all(
                  color: const Color(0xFFE5E5E5),
                  width: 1,
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  textColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 1,
                  blurRadius: 3,
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
