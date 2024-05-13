import 'dart:ui';

import 'package:flutter/material.dart';

enum Pretendard {
  title1,
  title2,
  title3,
  subtitle1,
  subtitle2,
  subtitle3,
  subtext1,
  subtext2,
  caption,
}

extension CGTextStyleExtension on Pretendard {
  static const String _fontFamily = 'Pretendard';

  TextStyle? textStyle({Color color = Colors.black}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: _getFontWeight(this),
      fontSize:  _getFontSize(this),
      height: _getHeight(this),
      color: color,
    );
  }

  static FontWeight _getFontWeight(Pretendard type) {
    switch (type) {
      case Pretendard.title1:
      case Pretendard.title2:
        return FontWeight.w700;
      case Pretendard.title3:
      case Pretendard.subtitle1:
      case Pretendard.subtitle3:
        return FontWeight.w600;
      case Pretendard.subtitle2:
        return FontWeight.w700;
      default:
        return FontWeight.w400;
    }
  }

  static double _getFontSize(Pretendard type) {
    switch (type) {
      case Pretendard.title1:
        return 24;
      case Pretendard.title2:
        return 20;
      case Pretendard.title3:
        return 18;
      case Pretendard.subtitle1:
        return 16;
      case Pretendard.subtitle2:
        return 14;
      case Pretendard.subtitle3:
        return 12;
      case Pretendard.subtext1:
        return 16;
      case Pretendard.subtext2:
        return 14;
      case Pretendard.caption:
        return 12;
      default:
        return 16;
    }
  }

  static double _getHeight(Pretendard type) {
    switch (type) {
      case Pretendard.title1:
        return 1.2;
      case Pretendard.title2:
        return 1.4;
      case Pretendard.title3:
      case Pretendard.subtitle1:
        return 1.2;
      case Pretendard.subtitle2:
        return 1.2;
      case Pretendard.subtitle3:
        return 1.1;
      case Pretendard.subtext1:
        return 1.3;
      case Pretendard.subtext2:
        return 1.2;
      case Pretendard.caption:
        return 1.2;
      default:
        return 1.0;
    }
  }
}