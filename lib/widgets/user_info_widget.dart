import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pangju/controller/my_page_controller.dart';

class UserInfoWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final bool showLikedPostsTab;

  const UserInfoWidget(
      {super.key, required this.userData, required this.showLikedPostsTab});

  @override
  Widget build(BuildContext context) {
    final hasProfileImage =
        userData['profileImage'] != null && userData['profileImage'].isNotEmpty;

    return Column(
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
                  color: hasProfileImage
                      ? Colors.transparent
                      : const Color(0xFFC3C3C3),
                ),
                child: ClipOval(
                  child: hasProfileImage
                      ? Image.network(userData['profileImage'],
                          width: 72, height: 72)
                      : Image.asset('assets/images/default_profile.png',
                          width: 54, height: 54),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                userData['nickname'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 350,
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                '사는곳',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF262626),
                                  height: 1.3,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userData['location'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF7B7B7B),
                                  height: 1.5,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 42,
                          color: const Color(0xFFE5E5E5),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                '나이',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF262626),
                                  height: 1.3,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userData['age'].toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF7B7B7B),
                                  height: 1.5,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 42,
                          color: const Color(0xFFE5E5E5),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                '성별',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF262626),
                                  height: 1.3,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userData['gender'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF7B7B7B),
                                  height: 1.5,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        GetBuilder<MyPageController>(
          builder: (controller) {
            return TabBar(
              onTap: (index) => controller.changeTab(index),
              labelColor: const Color(0xFF484848),
              unselectedLabelColor: const Color(0xFFA5A5A5),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.3,
                letterSpacing: -0.2,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.3,
                letterSpacing: -0.2,
              ),
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Color(0xFF484848),
                ),
                insets: EdgeInsets.zero,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                const Tab(text: '작성한 글'),
                const Tab(text: '작성한 댓글'),
                if (showLikedPostsTab) const Tab(text: '좋아한 글'),
              ],
            );
          },
        ),
      ],
    );
  }
}
