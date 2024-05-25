import 'package:flutter/material.dart';

class WriteSecondScreen extends StatelessWidget {
  const WriteSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: const Center(
        child: Text('This is the second screen'),
      ),
    );
  }
}
