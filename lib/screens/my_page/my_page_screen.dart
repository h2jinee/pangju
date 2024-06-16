import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pangju/controller/my_page_controller.dart';
import 'package:pangju/widgets/mypage_item_list_tile.dart';

class MyPageScreen extends StatefulWidget {
  final bool showLikedPostsTab;
  final bool isPrivate;

  const MyPageScreen(
      {super.key, this.showLikedPostsTab = true, this.isPrivate = false});

  @override
  MyPageScreenState createState() => MyPageScreenState();
}

class MyPageScreenState extends State<MyPageScreen> {
  final MyPageController controller = Get.put(MyPageController());

  void resetToInitial() {
    controller.resetPagination();
    controller.fetchInitialData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.showLikedPostsTab ? 3 : 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '마이',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF262626),
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
          future: controller.fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final userData = snapshot.data!;
              return SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  children: [
                    _buildUserInfo(userData, controller),
                    GetBuilder<MyPageController>(
                      builder: (controller) {
                        return IndexedStack(
                          index: controller.selectedIndex,
                          children: [
                            _buildTabContent(controller.posts), // 작성한 글
                            _buildTabContent(controller.comments), // 작성한 댓글
                            if (widget.showLikedPostsTab)
                              _buildTabContent(controller.likedPosts), // 좋아한 글
                          ],
                        );
                      },
                    ),
                    if (controller.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(
      Map<String, dynamic> userData, MyPageController controller) {
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
                          width: 54, height: 54)
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
                if (widget.showLikedPostsTab) const Tab(text: '좋아한 글'),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabContent(List<Map<String, dynamic>> items) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return MyPageItemListTile(item: items[index]);
      },
    );
  }
}
