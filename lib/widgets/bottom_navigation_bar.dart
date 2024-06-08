import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pangju/screens/home/home_screen.dart';
import 'package:pangju/screens/location/location_screen.dart';
import 'package:pangju/screens/chat/chat_screen.dart';
import 'package:pangju/screens/my_page/my_page_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _getBody(_selectedIndex),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const LocationScreen();
      case 2:
        return const ChatScreen();
      case 3:
        return const MyPageScreen();
      default:
        return const HomeScreen();
    }
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

void onItemTapped(BuildContext context, int index, Function(int) setState) {
  setState(index);
  Widget screen;
  switch (index) {
    case 0:
      screen = const HomeScreen();
      break;
    case 1:
      screen = const LocationScreen();
      break;
    case 2:
      screen = const ChatScreen();
      break;
    case 3:
      screen = const MyPageScreen();
      break;
    default:
      screen = const HomeScreen();
  }
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}
