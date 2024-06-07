import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pangju/screens/home/home_screen.dart';
import 'package:pangju/screens/location/location_screen.dart';
import 'package:pangju/screens/chat/chat_screen.dart';
import 'package:pangju/screens/my_page/my_page_screen.dart';

List<BottomNavigationBarItem> bottomNavigationBarItems(
    BuildContext context, int selectedIndex, Function(int) onItemTapped) {
  return [
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5), // 상하 간격 조정
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
        padding: const EdgeInsets.symmetric(vertical: 5), // 상하 간격 조정
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
        padding: const EdgeInsets.symmetric(vertical: 5), // 상하 간격 조정
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
        padding: const EdgeInsets.symmetric(vertical: 5), // 상하 간격 조정
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

void onItemTapped(BuildContext context, int index, Function(int) setState) {
  setState(index);
  Widget screen;
  switch (index) {
    case 0:
      screen = const HomeScreen();
      break;
    case 1:
      screen = const LocationScreen(); // ChatScreen으로 변경
      break;
    case 2:
      screen = const ChatScreen(); // ChatScreen으로 변경
      break;
    case 3:
      screen = const MyPageScreen(); // MyPageScreen으로 변경
      break;
    default:
      screen = const HomeScreen();
  }
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 1; // 현재 선택된 페이지의 인덱스

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFE5E5E5),
                width: 1.0,
              ),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF37A3E0),
            unselectedItemColor: const Color(0xFF484848),
            onTap: (index) => onItemTapped(context, index, (int idx) {
              setState(() {
                _selectedIndex = idx;
              });
            }),
            currentIndex: _selectedIndex,
            items: bottomNavigationBarItems(context, _selectedIndex, (int idx) {
              setState(() {
                _selectedIndex = idx;
              });
            }),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
