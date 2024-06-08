import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pangju/controller/navigation_controller.dart';
import 'package:pangju/widgets/bottom_navigation_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.find();

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
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF37A3E0),
            unselectedItemColor: const Color(0xFF484848),
            onTap: navigationController.changeIndex,
            currentIndex: navigationController.selectedIndex.value,
            items: bottomNavigationBarItems(
              context,
              navigationController.selectedIndex.value,
              navigationController.changeIndex,
            ),
          )),
    );
  }
}
