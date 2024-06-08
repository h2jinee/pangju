import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pangju/widgets/bottom_navigation_bar.dart';
import 'package:pangju/screens/home/write_first_screen.dart';
import 'package:pangju/screens/service/api_service.dart';
import 'package:pangju/widgets/category_constants.dart';
import 'package:pangju/widgets/category_box.dart';
import 'package:pangju/widgets/category_button.dart';
import 'package:pangju/controller/navigation_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();
  final List<Map<String, dynamic>> _items = [];
  final NavigationController navigationController = Get.find();
  bool _isLoading = false;
  int _currentPage = 1;
  final int _itemsPerPage = 15;
  int _selectedCategoryIndex = 0;
  bool _showNotificationBox = true;
  bool _hasMoreItems = true;

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
      List<Map<String, dynamic>> newItems =
          await ApiService.fetchItems(_currentPage, _itemsPerPage);
      if (newItems.isEmpty) {
        if (mounted) {
          setState(() {
            _hasMoreItems = false;
            _isLoading = false;
          });
        }
        return;
      }
      if (mounted) {
        setState(() {
          _items.addAll(newItems);
          _isLoading = false;
          _currentPage++;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _loadMoreItems() {
    if (_isLoading || !_hasMoreItems) return;

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

    if (index == 0 || index == 3) {
      _categoryScrollController.animateTo(
        index * 100.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
      backgroundColor: const Color(0xFFE3F6FD),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0, top: 30),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 0, left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/main_logo.png',
                                      width: 52,
                                      fit: BoxFit.contain,
                                    ),
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
                                    width: 140,
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
                  const SizedBox(height: 20),
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
                          offset: const Offset(0, 0),
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
                                  log('전체 카테고리가 선택되었습니다.');
                                },
                              ),
                              CategoryButton(
                                imagePath: 'assets/images/icons/online.png',
                                label: '온라인',
                                onTap: () {
                                  log('온라인 카테고리가 선택되었습니다.');
                                },
                              ),
                              CategoryButton(
                                imagePath: 'assets/images/icons/offline.png',
                                label: '오프라인',
                                onTap: () {
                                  log('오프라인 카테고리가 선택되었습니다.');
                                },
                              ),
                              CategoryButton(
                                imagePath: 'assets/images/icons/missing.png',
                                label: '실종·분실',
                                onTap: () {
                                  log('실종·분실 카테고리가 선택되었습니다.');
                                },
                              ),
                            ],
                          ),
                          if (_showNotificationBox)
                            Container(
                              width: 350,
                              padding: const EdgeInsets.all(16),
                              margin:
                                  const EdgeInsets.only(top: 30, bottom: 10),
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
                                            color: Color(0x80262626),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/images/icons/remove.svg',
                                              width: 12,
                                              height: 12,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Colors.white,
                                                BlendMode.srcIn,
                                              ),
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
                  Container(
                    height: 330,
                    color: const Color(0xFFF6F6F6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 25, top: 20),
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
                                  left: index == 0 ? 25 : 15,
                                  right: index == 9 ? 25 : 0,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEE4EB),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: const Text(
                                          '온라인',
                                          style: TextStyle(
                                            color: Color(0xFFF14074),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
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
                                            ),
                                          ),
                                          const SizedBox(width: 15),
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
                                            ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Container(
                      color: Colors.white,
                      child: SizedBox(
                        height: 65,
                        child: ListView.builder(
                          controller: _categoryScrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryData.length,
                          itemBuilder: (context, index) {
                            bool isSelected = _selectedCategoryIndex == index;

                            return GestureDetector(
                              onTap: () => _onCategoryTap(index),
                              child: CategoryBox(
                                iconPath:
                                    categoryData[index]['iconPath'] as String,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                  color:
                                                      _getMainCategoryTextColor(
                                                          item['mainCategory']),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Color(0xFFA5A5A5),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(
                                                '${item['heartCount']}',
                                                style: const TextStyle(
                                                  color: Color(0xFFA5A5A5),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            SvgPicture.asset(
                                              'assets/images/icons/chat.svg',
                                              width: 24,
                                              height: 24,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Color(0xFFA5A5A5),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(
                                                '${item['chatCount']}',
                                                style: const TextStyle(
                                                  color: Color(0xFFA5A5A5),
                                                ),
                                              ),
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
                            if (index != _items.length - 1)
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
            Positioned(
              bottom: 15,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WriteFirstScreen()),
                  );
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
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF37A3E0),
            unselectedItemColor: const Color(0xFF484848),
            onTap: navigationController.changeIndex,
            currentIndex: navigationController.selectedIndex.value,
            items: bottomNavigationBarItems(
              context,
              navigationController.selectedIndex.value,
              navigationController.changeIndex,
            ),
          )),
    );
  }
}
