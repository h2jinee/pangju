import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryBox extends StatelessWidget {
  final String iconPath;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool isSelected;
  final int index;

  const CategoryBox({
    super.key,
    required this.iconPath,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.isSelected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 25,
        left: index == 0 ? 25 : 8, // 첫 번째 아이템에는 왼쪽 패딩 유지
        right: index == 3 ? 10 : 0, // 마지막 아이템에 오른쪽 패딩 추가
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50),
          border: isSelected
              ? null
              : Border.all(
                  color: const Color(0xFFE5E5E5),
                  width: 1,
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  textColor,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
