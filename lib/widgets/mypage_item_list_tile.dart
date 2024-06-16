import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pangju/utils/list_styles.dart';

class MyPageItemListTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const MyPageItemListTile({required this.item, super.key});

  Color _getCategoryColor(String mainCategory, {required bool isBackground}) {
    final colorMap = {
      '오프라인': isBackground ? const Color(0xFFE6F6EB) : const Color(0xFF17944B),
      '온라인': isBackground ? const Color(0xFFFEE4EB) : const Color(0xFFF14074),
      '분실·신고': isBackground ? const Color(0xFFFBE8E5) : const Color(0xFFEF470A),
    };
    return colorMap[mainCategory] ??
        (isBackground ? Colors.grey : Colors.black);
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  // Edit action
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        'assets/images/icons/write.svg',
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF484848),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      '수정하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.3,
                        letterSpacing: -0.2,
                        color: Color(0xFF484848),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  // Delete action
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        'assets/images/icons/recycle_bin.svg',
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFEF470A),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      '삭제하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.3,
                        letterSpacing: -0.2,
                        color: Color(0xFFEF470A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(item['mainCategory'],
                                isBackground: true),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            item['mainCategory'],
                            style: ListStyles.myPageMainCategoryStyle.copyWith(
                              color: _getCategoryColor(item['mainCategory'],
                                  isBackground: false),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            item['status'],
                            style: ListStyles.myPageMainCategoryStyle.copyWith(
                              color: const Color(0xFF484848),
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: IconButton(
                            icon: SvgPicture.asset(
                              'assets/images/icons/ellipsis.svg',
                            ),
                            onPressed: () => _showBottomSheet(context),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['content'],
                                style: ListStyles.myPageContentStyle,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['description'],
                                style: ListStyles.myPageDescriptionStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/heart.svg',
                                    width: 20,
                                    height: 20,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFFA5A5A5),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Text(
                                      '${item['heartCount']}',
                                      style: ListStyles.myPageIconTextStyle,
                                    ),
                                  ),
                                  const SizedBox(width: 13),
                                  SvgPicture.asset(
                                    'assets/images/icons/chat.svg',
                                    width: 20,
                                    height: 20,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFFA5A5A5),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: Text(
                                      '${item['chatCount']}',
                                      style: ListStyles.myPageIconTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (item['image'] != null)
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(item['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            height: 1,
            width: 350,
            color: const Color(0xFFE5E5E5),
          ),
        ),
      ],
    );
  }
}
