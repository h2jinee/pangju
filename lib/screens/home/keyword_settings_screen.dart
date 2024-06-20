import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KeywordSettingsScreen extends StatefulWidget {
  const KeywordSettingsScreen({super.key});

  @override
  _KeywordSettingsScreenState createState() => _KeywordSettingsScreenState();
}

class _KeywordSettingsScreenState extends State<KeywordSettingsScreen> {
  final TextEditingController _keywordController = TextEditingController();
  bool _isButtonEnabled = false;
  List<String> _registeredKeywords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _keywordController.addListener(_validateInput);
    _fetchRegisteredKeywords();
  }

  void _validateInput() {
    setState(() {
      _isButtonEnabled = _keywordController.text.isNotEmpty;
    });
  }

  Future<void> _fetchRegisteredKeywords() async {
    // 여기에서 실제 API 호출을 해야 합니다.
    // 예시로 딜레이를 주고 임의의 키워드 리스트를 반환합니다.
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _registeredKeywords = ['서울', '강동초', '96년', '전교회장', '피구'];
      _isLoading = false;
    });
  }

  void _removeKeyword(String keyword) {
    setState(() {
      _registeredKeywords.remove(keyword);
    });
    _showSnackBar('키워드 알림이 삭제되었습니다.');
  }

  void _showSnackBar(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 30.0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFA5A5A5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // 배경 색상 설정
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          '키워드 알림 설정',
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
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            color: Color(0xFFE5E5E5),
            thickness: 1.0,
            height: 1.0,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          height: 49,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _keywordController,
                            decoration: const InputDecoration(
                              hintText: '키워드를 입력해주세요',
                              hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isButtonEnabled
                              ? () {
                                  setState(() {
                                    _registeredKeywords
                                        .add(_keywordController.text);
                                    _keywordController.clear();
                                    _isButtonEnabled = false;
                                  });
                                  FocusScope.of(context).unfocus(); // 키보드 내리기
                                  Future.delayed(
                                      const Duration(milliseconds: 300),
                                      () => _showSnackBar('키워드 알림이 등록되었습니다.'));
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: _isButtonEnabled
                                ? const Color(0xFF37A3E0)
                                : const Color(0xFFF1F1F1),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(
                            '키워드 등록',
                            style: TextStyle(
                              color: _isButtonEnabled
                                  ? Colors.white
                                  : const Color(0xFFC3C3C3),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), // 버튼 아래에 여백 추가
                      ],
                    ),
                  ),
                  Container(
                    height: 12,
                    color: const Color(0xFFF6F6F6),
                  ),
                  if (_registeredKeywords.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '등록한 키워드',
                              style: TextStyle(
                                color: Color(0xFF262626),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            for (var keyword in _registeredKeywords)
                              Container(
                                height: 52,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: const Color(0xFFE5E5E5), width: 1),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                margin: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      keyword,
                                      style: const TextStyle(
                                        color: Color(0xFF484848),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        height: 1.3,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _removeKeyword(keyword);
                                      },
                                      icon: SvgPicture.asset(
                                        'assets/images/icons/recycle_bin.svg',
                                        width: 24,
                                        height: 24,
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xFF484848),
                                          BlendMode.srcIn,
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
                ],
              ),
            ),
    );
  }
}
