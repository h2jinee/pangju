import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pangju/widgets/bottom_navigation_bar.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int _selectedIndex = 1; // 해당 페이지의 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
        centerTitle: true, // Center align the text
        title: const Text(
          '내근처',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500, // Medium weight
            color: Colors.black, // Change text color to black
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/images/icons/search.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFF000000),
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                // 검색 아이콘 클릭 시 동작
              },
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('내 근처 화면입니다.'),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
