import 'package:flutter/material.dart';
import 'package:pangju/screens/home/home_screen.dart';
import 'package:pangju/screens/home/write_first_screen.dart';

void showCancelDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('글쓰기를 취소하시겠습니까?'),
        content: const Text('현재 작성 중인 내용이 사라집니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            child: const Text('예'),
          ),
        ],
      );
    },
  );
}

void showLoadDraftDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('임시저장된 내역이 있습니다.'),
        content: const Text('불러오시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WriteFirstScreen(),
                ),
              );
            },
            child: const Text('예'),
          ),
        ],
      );
    },
  );
}
