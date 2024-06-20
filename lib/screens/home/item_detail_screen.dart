import 'package:flutter/material.dart';
import 'package:pangju/service/api_service.dart';

class ItemDetailScreen extends StatefulWidget {
  final int id;

  const ItemDetailScreen({super.key, required this.id});

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late Future<Map<String, dynamic>> item;

  @override
  void initState() {
    super.initState();
    item = ApiService.fetchItemById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Detail'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: item,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final itemData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Main Category: ${itemData['mainCategory']}'),
                  Text('Sub Category: ${itemData['subCategory']}'),
                  Text('Status: ${itemData['status']}'),
                  Text('Content: ${itemData['content']}'),
                  // Add other item details here
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
