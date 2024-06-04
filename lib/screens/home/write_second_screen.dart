import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pangju/screens/home/utils.dart';

import 'bottom_bar.dart';
import 'load_image_screen.dart';

class WriteSecondScreen extends StatefulWidget {
  const WriteSecondScreen({super.key});

  @override
  _WriteSecondScreenState createState() => _WriteSecondScreenState();
}

class _WriteSecondScreenState extends State<WriteSecondScreen> {
  final TextEditingController _contentController = TextEditingController();
  final List<File> _selectedImages = [];
  int _currentImageIndex = 0;

  Future<void> _navigateAndPickImage(BuildContext context) async {
    final List<File>? selectedImages = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadImageScreen(
          initialSelectedImages: _selectedImages,
        ),
      ),
    );

    if (selectedImages != null) {
      setState(() {
        _selectedImages.clear();
        _selectedImages.addAll(selectedImages);
        _currentImageIndex = 0; // Reset the current image index
      });
    }
  }

  void _nextImage() {
    setState(() {
      if (_currentImageIndex < _selectedImages.length - 1) {
        _currentImageIndex++;
      } else {
        _currentImageIndex = 0; // Go to the first image if it's the last one
      }
    });
  }

  void _previousImage() {
    setState(() {
      if (_currentImageIndex > 0) {
        _currentImageIndex--;
      } else {
        _currentImageIndex = _selectedImages.length -
            1; // Go to the last image if it's the first one
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            '글쓰기',
            style: TextStyle(color: Colors.black),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/images/icons/remove.svg',
                width: 15.65,
                height: 15.72,
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
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: '제목',
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
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 49,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: '제목을 입력해 주세요.',
                        hintStyle: TextStyle(
                            color: Color(0xFFA5A5A5),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  RichText(
                    text: const TextSpan(
                      text: '사진 (선택)',
                      style: TextStyle(
                        color: Color(0xFF262626),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '이미지는 최대 5개까지 첨부할 수 있어요.',
                    style: TextStyle(
                      color: Color(0xFFA5A5A5),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      if (_selectedImages.isEmpty) {
                        _navigateAndPickImage(context);
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 350,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5E5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: _selectedImages.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/icons/image.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      '클릭하여 이미지를 업로드해 주세요',
                                      style: TextStyle(
                                        color: Color(0xFFA5A5A5),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.file(
                                          _selectedImages[_currentImageIndex],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        top: 0,
                                        bottom: 0,
                                        child: IconButton(
                                          icon: Image.asset(
                                            'assets/images/icons/image_left_arrow.png',
                                          ),
                                          onPressed: _previousImage,
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 0,
                                        bottom: 0,
                                        child: IconButton(
                                          icon: Image.asset(
                                            'assets/images/icons/image_right_arrow.png',
                                          ),
                                          onPressed: _nextImage,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 15,
                                        right: 15,
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _navigateAndPickImage(context);
                                              },
                                              child: Container(
                                                width: 78,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFE5E5E5),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/images/icons/write.svg',
                                                      width: 20,
                                                      height: 20,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        Color(0xFF484848),
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    const Text(
                                                      '수정',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF484848),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedImages.removeAt(
                                                      _currentImageIndex);
                                                  if (_currentImageIndex > 0) {
                                                    _currentImageIndex--;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                width: 78,
                                                height: 37,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFE5E5E5),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/images/icons/recycle_bin.svg',
                                                      width: 20,
                                                      height: 20,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        Color(0xFF484848),
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 2),
                                                    const Text(
                                                      '삭제',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF484848),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            width: 60,
                            height: 26,
                            decoration: BoxDecoration(
                              color: const Color(0xE5262626),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                '${_selectedImages.isEmpty ? 0 : _currentImageIndex + 1} / ${_selectedImages.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: const TextSpan(
                      text: '내용',
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
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE5E5E5),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: TextFormField(
                        controller: _contentController,
                        minLines: 5,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: '내용을 입력해 주세요.',
                          hintStyle: TextStyle(
                            color: Color(0xFFA5A5A5),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomBar(
          onNext: () {
            // 다음 페이지로 이동하는 로직 추가
          },
          onRegister: () {
            // 등록 버튼 로직 추가
          },
          isFirstPage: false,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
