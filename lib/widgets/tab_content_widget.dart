import 'package:flutter/material.dart';
import 'package:pangju/widgets/mypage_item_list_tile.dart';

class TabContentWidget extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const TabContentWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return MyPageItemListTile(item: items[index]);
      },
    );
  }
}
