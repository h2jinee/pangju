import 'package:flutter/material.dart';

const List<Map<String, dynamic>> categoryData = [
  {
    'iconPath': 'assets/images/icons/clock.svg',
    'text': '최신순',
    'backgroundColor': Color(0xFF37A3E0),
    'textColor': Colors.white,
    'isSelected': true,
  },
  {
    'iconPath': 'assets/images/icons/place.svg',
    'text': '내근처',
    'backgroundColor': Colors.white,
    'textColor': Color(0xFF484848),
    'isSelected': false,
  },
  {
    'iconPath': 'assets/images/icons/heart.svg',
    'text': '공감순',
    'backgroundColor': Colors.white,
    'textColor': Color(0xFF484848),
    'isSelected': false,
  },
  {
    'iconPath': 'assets/images/icons/chat.svg',
    'text': '댓글순',
    'backgroundColor': Colors.white,
    'textColor': Color(0xFF484848),
    'isSelected': false,
  },
];
