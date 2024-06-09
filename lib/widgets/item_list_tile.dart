import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pangju/utils/list_styles.dart';

class ItemListTile extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemListTile({required this.item, super.key});

  Color _getMainCategoryBackgroundColor(String mainCategory) {
    switch (mainCategory) {
      case '오프라인':
        return const Color(0xFFE6F6EB);
      case '온라인':
        return const Color(0xFFFEE4EB);
      case '분실·신고':
        return const Color(0xFFFBE8E5);
      default:
        return Colors.grey;
    }
  }

  Color _getMainCategoryTextColor(String mainCategory) {
    switch (mainCategory) {
      case '오프라인':
        return const Color(0xFF17944B);
      case '온라인':
        return const Color(0xFFF14074);
      case '분실·신고':
        return const Color(0xFFEF470A);
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 23,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                            color: _getMainCategoryBackgroundColor(
                                item['mainCategory']),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            item['mainCategory'],
                            style: ListStyles.mainCategoryStyle.copyWith(
                              color: _getMainCategoryTextColor(
                                  item['mainCategory']),
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
                            style: ListStyles.mainCategoryStyle.copyWith(
                              color: const Color(0xFF484848),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        item['content'],
                        style: ListStyles.contentStyle,
                      ),
                    ),
                    Text(
                      item['description'],
                      style: ListStyles.descriptionStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/icons/heart.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFA5A5A5),
                            BlendMode.srcIn,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text(
                            '${item['heartCount']}',
                            style: ListStyles.iconTextStyle,
                          ),
                        ),
                        const SizedBox(width: 13),
                        SvgPicture.asset(
                          'assets/images/icons/chat.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFA5A5A5),
                            BlendMode.srcIn,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text(
                            '${item['chatCount']}',
                            style: ListStyles.iconTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (item['image'] != null)
                Container(
                  width: 80,
                  height: 80,
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
