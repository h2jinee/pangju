import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? userData;
  bool isProfilePublic = true;
  bool isChatNotificationEnabled = false;
  bool isActivityNotificationEnabled = false;

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
                  Get.back();
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
        body: SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildProfileField('이름', '이름은 외부에 공개되지 않아요.'),
                      _buildProfileField('닉네임', null),
                      _buildProfileField('사는 곳', null),
                      _buildProfileField('생년월일', null),
                      _buildGenderSelection(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 12,
                  color: const Color(0xFFF6F6F6),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '사용자 설정',
                            style: TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildToggleOption(
                            '프로필 정보 공개',
                            '사는 곳, 나이, 성별 공개',
                            isProfilePublic,
                            (value) {
                              setState(() {
                                isProfilePublic = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30), // Divider 위 여백
                const Divider(
                  color: Color(0xFFE5E5E5),
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 20), // Divider 아래 여백
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '알림 설정',
                        style: TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildToggleOption(
                        '채팅 알림',
                        '채팅 메시지 알림',
                        isChatNotificationEnabled,
                        (value) {
                          setState(() {
                            isChatNotificationEnabled = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildToggleOption(
                        '활동 알림',
                        '작성한 글에 달린 댓글, 답글, 좋아요 등의 알림',
                        isActivityNotificationEnabled,
                        (value) {
                          setState(() {
                            isActivityNotificationEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30), // Divider 위 여백
                const Divider(
                  color: Color(0xFFE5E5E5),
                  thickness: 1,
                  height: 1,
                ),
                const SizedBox(height: 20), // Divider 아래 여백
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '계정 관리',
                        style: TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '휴대폰 번호',
                        style: TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                          letterSpacing: -0.2,
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          hintText: '휴대폰 번호를 입력해 주세요.',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '이메일',
                        style: TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                          letterSpacing: -0.2,
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          hintText: '이메일을 입력해 주세요.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30), // 두꺼운 바 위 여백
                Container(
                  height: 12,
                  color: const Color(0xFFF6F6F6),
                ),
                const SizedBox(height: 20), // 두꺼운 바 아래 여백
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '기타',
                        style: TextStyle(
                          color: Color(0xFF262626),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            // 로그아웃 기능 추가
                          },
                          child: const Text(
                            '로그아웃',
                            style: TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            // 탈퇴하기 기능 추가
                          },
                          child: const Text(
                            '탈퇴하기',
                            style: TextStyle(
                              color: Color(0xFF262626),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
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
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double boxWidth = (constraints.maxWidth - 50) / 3;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildGenderBox('남자', boxWidth),
                    _buildGenderBox('여자', boxWidth),
                    _buildGenderBox('기타', boxWidth),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderBox(String title, double width) {
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
        width: width,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFFFF) : const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(8),
          border:
              isSelected ? Border.all(color: const Color(0xFFE5E5E5)) : null,
        ),
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

  Widget _buildToggleOption(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF262626),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.3,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color(0xFF7B7B7B),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF37A3E0),
          trackColor: const Color(0xFF787880).withOpacity(0.16),
        ),
      ],
    );
  }
}
