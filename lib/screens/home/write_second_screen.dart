import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:pangju/screens/home/bottom_bar.dart';
import 'package:pangju/screens/home/utils.dart';

class WriteSecondScreen extends StatefulWidget {
  const WriteSecondScreen({super.key});

  @override
  _WriteSecondScreenState createState() => _WriteSecondScreenState();
}

class _WriteSecondScreenState extends State<WriteSecondScreen> {
  final TextEditingController _contentController = TextEditingController();
  List<Asset> _images = <Asset>[];

  Future<void> _pickImages() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Select Images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } catch (e) {
      // Handle error or cancellation
    }

    if (!mounted) return;

    setState(() {
      _images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 다른 영역을 클릭하면 키보드를 닫음
      },
      child: Scaffold(
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
                const SizedBox(height: 10), // 여백 추가
                Container(
                  width: 350,
                  height: 49,
                  margin: const EdgeInsets.only(bottom: 20), // 추가된 여백
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
                const SizedBox(height: 15), // 여백 추가
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
                const SizedBox(height: 5), // 여백 추가
                const Text(
                  '이미지는 최대 5개까지 첨부할 수 있어요.',
                  style: TextStyle(
                    color: Color(0xFFA5A5A5),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 15), // 여백 추가
                GestureDetector(
                  onTap: _pickImages, // 이미지 선택 함수 호출
                  child: Stack(
                    children: [
                      Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5E5E5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _images.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/icons/image.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(height: 10), // 여백 추가
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
                                itemCount: _images.length,
                                itemBuilder: (context, index) {
                                  return AssetThumb(
                                    asset: _images[index],
                                    width: 350,
                                    height: 350,
                                  );
                                },
                              ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 60, // 너비를 넓혀 텍스트가 잘리지 않도록 수정
                          height: 26,
                          decoration: BoxDecoration(
                            color: const Color(0xE5262626),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              '${_images.length} / 5', // 선택한 이미지 개수 표시
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
                const SizedBox(height: 20), // 여백 추가
                if (_images.isNotEmpty)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _images
                        .map((image) => AssetThumb(
                              asset: image,
                              width: 100,
                              height: 100,
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 20), // 여백 추가
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
                const SizedBox(height: 10), // 여백 추가
                Container(
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE5E5E5),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30), // 여백 추가
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
                const SizedBox(height: 20), // 여백 추가
              ],
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
          isFirstPage: false, // 두 번째 페이지에서는 이전 버튼이 활성화
        ),
        backgroundColor: Colors.white, // Body background color
      ),
    );
  }
}
