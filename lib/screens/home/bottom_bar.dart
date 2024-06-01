import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onRegister;
  final bool isFirstPage;

  const BottomBar({
    super.key,
    required this.onNext,
    required this.onRegister,
    this.isFirstPage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 68,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildBottomBarButton(
                text: '이전',
                isEnabled: !isFirstPage,
                onPressed: () {
                  if (!isFirstPage) {
                    Navigator.of(context).pop(); // 이전 페이지로 이동
                  }
                },
              ),
              const SizedBox(width: 8),
              _buildBottomBarButton(
                text: '다음',
                isEnabled: isFirstPage,
                onPressed: onNext,
              ),
            ],
          ),
          _buildRegisterButton(
            text: '등록',
            isEnabled: !isFirstPage,
            onPressed: onRegister,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBarButton({
    required String text,
    required bool isEnabled,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 68,
        height: 41,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFE5E5E5),
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color:
                isEnabled ? const Color(0xFF484848) : const Color(0xFFC3C3C3),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton({
    required String text,
    required bool isEnabled,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 68,
        height: 41,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isEnabled ? const Color(0xFF37A3E0) : const Color(0xFFF1F1F1),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isEnabled ? Colors.white : const Color(0xFFC3C3C3),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
