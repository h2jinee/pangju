import 'package:flutter/material.dart';
import 'package:pangju/widgets/mypage_item_list_tile.dart';

class MyPageItemListTab extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function(int, int) fetchItems;

  const MyPageItemListTab(this.fetchItems, {super.key});

  @override
  _MyPageItemListTabState createState() => _MyPageItemListTabState();
}

class _MyPageItemListTabState extends State<MyPageItemListTab> {
  final List<Map<String, dynamic>> _items = [];
  bool _isLoading = false;
  bool _hasMoreItems = true;
  int _currentPage = 1;
  final int _itemsPerPage = 15;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMoreItems) {
        _fetchItems();
      }
    });
  }

  Future<void> _fetchItems() async {
    if (_isLoading || !_hasMoreItems) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> newItems =
          await widget.fetchItems(_currentPage, _itemsPerPage);
      if (newItems.isEmpty) {
        setState(() {
          _hasMoreItems = false;
        });
      } else {
        setState(() {
          _items.addAll(newItems);
          _currentPage++;
        });
      }
    } catch (e) {
      // Handle error
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading && _items.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            itemCount: _items.length + (_hasMoreItems ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _items.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final item = _items[index];
              return MyPageItemListTile(item: item);
            },
          );
  }
}
