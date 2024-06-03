import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'load_image_screen.dart';
import 'bottom_bar.dart';
import 'dart:io';

class WriteSecondScreen extends StatefulWidget {
  const WriteSecondScreen({super.key});

  @override
  _WriteSecondScreenState createState() => _WriteSecondScreenState();
}

class _WriteSecondScreenState extends State<WriteSecondScreen> {
  final TextEditingController _contentController = TextEditingController();
  final List<File> _selectedImages = [];

  Future<void> _navigateAndPickImage(BuildContext context) async {
    final List<File>? selectedImages = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoadImageScreen(),
      ),
    );

    if (selectedImages != null) {
      setState(() {
        if (_selectedImages.length + selectedImages.length <= 5) {
          _selectedImages.addAll(selectedImages);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('이미지는 최대 5개까지 첨부할 수 있습니다.')),
          );
        }
      });
    }
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
                width: 20,
                height: 20,
              ),
              onPressed: () {
                // 글쓰기 취소 알림 표시
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
                      _navigateAndPickImage(context);
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
                              : PageView.builder(
                                  itemCount: _selectedImages.length,
                                  itemBuilder: (context, index) {
                                    return Image.file(
                                      _selectedImages[index],
                                      fit: BoxFit.cover,
                                    );
                                  },
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
                                '${_selectedImages.length} / 5',
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
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _selectedImages
                        .map((image) => Stack(
                              children: [
                                Image.file(
                                  image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedImages.remove(image);
                                      });
                                    },
                                    child: Container(
                                      color: Colors.black54,
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
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
