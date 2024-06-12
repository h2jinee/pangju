import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pangju/screens/home/home_screen.dart';
import 'package:pangju/screens/location/location_screen.dart';
import 'package:pangju/screens/chat/chat_screen.dart';
import 'package:pangju/screens/my_page/my_page_screen.dart';
import 'package:pangju/controller/navigation_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'xhihwzgpec');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'pangju',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            height: 1.3,
            letterSpacing: -0.2,
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final NavigationController navigationController =
      Get.put(NavigationController());
  final GlobalKey<LocationScreenState> locationScreenKey =
      GlobalKey<LocationScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() => Container(
            decoration: const BoxDecoration(
              color: Colors.white, // 배경색상 설정
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE5E5E5),
                  width: 1.0,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: navigationController.selectedIndex.value,
              onTap: (index) async {
                // 이미 선택된 탭을 다시 누르면 초기화
                if (navigationController.selectedIndex.value == index &&
                    index == 1) {
                  locationScreenKey.currentState?.resetToInitial();
                  setState(() {});
                }
                navigationController.changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              items: bottomNavigationBarItems(
                  context,
                  navigationController.selectedIndex.value,
                  navigationController.changeIndex),
            ),
          )),
      body: Obx(() {
        return IndexedStack(
          index: navigationController.selectedIndex.value,
          children: [
            const HomeScreen(),
            LocationScreen(key: locationScreenKey),
            const ChatScreen(),
            const MyPageScreen(),
          ],
        );
      }),
    );
  }
}

List<BottomNavigationBarItem> bottomNavigationBarItems(
    BuildContext context, int selectedIndex, Function(int) onItemTapped) {
  return [
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                'assets/images/icons/home.svg',
                colorFilter: ColorFilter.mode(
                  selectedIndex == 0
                      ? const Color(0xFF37A3E0)
                      : const Color(0xFF484848),
                  BlendMode.srcIn,
                ),
              ),
            ),
            Text(
              '홈',
              style: TextStyle(
                color: selectedIndex == 0
                    ? const Color(0xFF37A3E0)
                    : const Color(0xFF484848),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                'assets/images/icons/place.svg',
                colorFilter: ColorFilter.mode(
                  selectedIndex == 1
                      ? const Color(0xFF37A3E0)
                      : const Color(0xFF484848),
                  BlendMode.srcIn,
                ),
              ),
            ),
            Text(
              '내 근처',
              style: TextStyle(
                color: selectedIndex == 1
                    ? const Color(0xFF37A3E0)
                    : const Color(0xFF484848),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                'assets/images/icons/chat.svg',
                colorFilter: ColorFilter.mode(
                  selectedIndex == 2
                      ? const Color(0xFF37A3E0)
                      : const Color(0xFF484848),
                  BlendMode.srcIn,
                ),
              ),
            ),
            Text(
              '채팅',
              style: TextStyle(
                color: selectedIndex == 2
                    ? const Color(0xFF37A3E0)
                    : const Color(0xFF484848),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                'assets/images/icons/mypage.svg',
                colorFilter: ColorFilter.mode(
                  selectedIndex == 3
                      ? const Color(0xFF37A3E0)
                      : const Color(0xFF484848),
                  BlendMode.srcIn,
                ),
              ),
            ),
            Text(
              '마이',
              style: TextStyle(
                color: selectedIndex == 3
                    ? const Color(0xFF37A3E0)
                    : const Color(0xFF484848),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      label: '',
    ),
  ];
}
