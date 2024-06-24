import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pangju/controller/my_page_controller.dart';
import 'package:pangju/screens/my_page/settings.dart';
import 'package:pangju/widgets/user_info_widget.dart';
import 'package:pangju/widgets/tab_content_widget.dart';

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
                GestureDetector(
                  onTap: () {
                    // Navigate to SettingsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/images/icons/setting.svg',
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF484848),
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  ),
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
                    UserInfoWidget(
                      userData: userData,
                      showLikedPostsTab: widget.showLikedPostsTab,
                    ),
                    GetBuilder<MyPageController>(
                      builder: (controller) {
                        return Column(
                          children: [
                            if (controller.selectedIndex == 2 &&
                                widget.showLikedPostsTab)
                              Container(
                                height: 50,
                                color: const Color(0xFFFBFBFB),
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 16.0),
                                child: const Text(
                                  '좋아한 글은 나만 볼 수 있어요.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                    letterSpacing: -0.2,
                                    color: Color(0xFF484848),
                                  ),
                                ),
                              ),
                            IndexedStack(
                              index: controller.selectedIndex,
                              children: [
                                TabContentWidget(
                                    items: controller.posts), // 작성한 글
                                TabContentWidget(
                                    items: controller.comments), // 작성한 댓글
                                if (widget.showLikedPostsTab)
                                  TabContentWidget(
                                      items: controller.likedPosts), // 좋아한 글
                              ],
                            ),
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
}
