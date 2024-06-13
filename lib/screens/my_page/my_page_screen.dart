import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pangju/controller/navigation_controller.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  Future<Map<String, dynamic>> fetchUserData() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Return sample data
    return {
      'profileImage': '', // Empty to simulate missing profile image
      'nickname': '룰루랄라',
      'location': '서울',
      'age': 23,
      'gender': '남자',
    };
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.find();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // Remove shadow
          centerTitle: true, // Center align the text
          automaticallyImplyLeading: false,
          title: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0), // Add padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '마이',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold, // Bold weight
                    color: Color(0xFF262626), // Text color
                  ),
                ),
                SvgPicture.asset(
                  'assets/images/icons/setting.svg',
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF484848),
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final userData = snapshot.data!;
              final hasProfileImage = userData['profileImage'] != null &&
                  userData['profileImage'].isNotEmpty;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: const Color(0xFFE5E5E5),
                                        width: 1),
                                    color: hasProfileImage
                                        ? Colors.transparent
                                        : const Color(0xFFC3C3C3),
                                  ),
                                  child: ClipOval(
                                    child: hasProfileImage
                                        ? Image.network(
                                            userData['profileImage'],
                                            fit: BoxFit.cover,
                                            width: 54,
                                            height: 54,
                                          )
                                        : Image.asset(
                                            'assets/images/default_profile.png',
                                            fit: BoxFit.cover,
                                            width: 54,
                                            height: 54,
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                    height: 10), // Space between image and text
                                Text(
                                  userData['nickname'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold, // Bold weight
                                    height: 1.3,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(
                                    height: 20), // Space between text and box
                                Container(
                                  width: 350,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: const Color(0xFFE5E5E5),
                                        width: 1),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
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
                                                    fontWeight:
                                                        FontWeight.normal,
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
                                                    fontWeight:
                                                        FontWeight.normal,
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
                                                    fontWeight:
                                                        FontWeight.normal,
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
                              ],
                            ),
                          ),
                          const SizedBox(
                              height: 20), // Space between user info and tabs
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFE5E5E5),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const TabBar(
                              labelColor: Color(0xFF484848),
                              unselectedLabelColor: Color(0xFFA5A5A5),
                              labelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500, // Medium weight
                                height: 1.3,
                                letterSpacing: -0.2,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400, // Regular weight
                                height: 1.3,
                                letterSpacing: -0.2,
                              ),
                              indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                  width: 2.0,
                                  color: Color(0xFF484848),
                                ),
                                insets: EdgeInsets.zero,
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs: [
                                Tab(text: '작성한 글'),
                                Tab(text: '작성한 댓글'),
                                Tab(text: '좋아한 글'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        Center(child: Text('작성한 글')),
                        Center(child: Text('작성한 댓글')),
                        Center(child: Text('좋아한 글')),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
