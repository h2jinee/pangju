import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? userData;
  bool get hasProfileImage =>
      userData != null &&
      userData!['profileImage'] != null &&
      userData!['profileImage'].isNotEmpty;

  @override
  void initState() {
    super.initState();
    // 임시로 userData 설정
    userData = {
      'profileImage': '', // 기본 프로필 이미지 URL이 없을 때 빈 문자열로 설정
      'nickname': '룰루랄라',
      'gender': '남자', // 성별 초기화
    };
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            '계정 설정',
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
                  // 완료 버튼 클릭 시 동작 추가
                },
                child: const Text(
                  '완료',
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color(0xFFE5E5E5),
              height: 1.0,
              width: double.infinity,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
            '계정 설정',
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
                  // 완료 버튼 클릭 시 동작 추가
                },
                child: const Text(
                  '완료',
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color(0xFFE5E5E5),
              height: 1.0,
              width: double.infinity,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFE5E5E5), width: 1),
                          color: hasProfileImage
                              ? Colors.transparent
                              : const Color(0xFFC3C3C3),
                        ),
                        child: ClipOval(
                          child: hasProfileImage
                              ? Image.network(
                                  userData!['profileImage'],
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/default_profile.png', // 기본 프로필 이미지 경로
                                  width: 54,
                                  height: 54,
                                ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            // 프로필 이미지 변경 기능 추가
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xFFE5E5E5), width: 1),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/images/icons/camera.svg',
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildProfileField('이름', '이름은 외부에 공개되지 않아요.'),
                  _buildProfileField('닉네임', null),
                  _buildProfileField('사는 곳', null),
                  _buildProfileField('생년월일', null),
                  _buildGenderSelection(),
                  const SizedBox(height: 20),
                  // 여기에 추가 필드를 넣을 수 있습니다.
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildProfileField(String label, String? subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF262626),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFFA5A5A5),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              hintText: '$label을 입력해 주세요.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '성별',
            style: TextStyle(
              color: Color(0xFF262626),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGenderBox('남자'),
                _buildGenderBox('여자'),
                _buildGenderBox('기타'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderBox(String title) {
    bool isSelected = userData != null && userData!['gender'] == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (userData != null) {
            userData!['gender'] = title;
          }
        });
      },
      child: Container(
        width: 110,
        height: 36,
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              )
            : null,
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color:
                isSelected ? const Color(0xFF484848) : const Color(0xFF262626),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
