import 'package:flutter/material.dart';
import 'package:pangju/utils/utils.dart';
import 'package:pangju/widgets/bottom_navigation_bar.dart';
import 'package:pangju/widgets/bottom_navigation_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedIndex = 2; // 해당 페이지의 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
        centerTitle: true, // Center align the text
        title: const Text(
          '채팅',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500, // Medium weight
            color: Colors.black, // Change text color to black
          ),
        ),
      ),
      body: const Center(
        child: Text('채팅 화면입니다.'),
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
