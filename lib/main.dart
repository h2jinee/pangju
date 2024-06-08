import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pangju/screens/home/home_screen.dart';
import 'package:pangju/screens/location/location_screen.dart';
import 'package:pangju/screens/chat/chat_screen.dart';
import 'package:pangju/screens/my_page/my_page_screen.dart';
import 'package:pangju/controller/navigation_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'pangju',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final NavigationController navigationController =
      Get.put(NavigationController());

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: navigationController.selectedIndex.value,
            onTap: navigationController.changeIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on),
                label: 'Location',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'My Page',
              ),
            ],
          )),
      body: Obx(() {
        switch (navigationController.selectedIndex.value) {
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
      }),
    );
  }
}
