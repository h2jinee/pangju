import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class LoadImageScreen extends StatefulWidget {
  const LoadImageScreen({super.key});

  @override
  _LoadImageScreenState createState() => _LoadImageScreenState();
}

class _LoadImageScreenState extends State<LoadImageScreen> {
  List<AssetEntity> _imageEntities = [];

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadImages();
  }

  Future<void> _requestPermissionAndLoadImages() async {
    print('Requesting permission...');
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    print('Permission state: $ps');
    if (ps.isAuth || ps.hasAccess) {
      // 권한이 부여된 경우에만 이미지를 불러옵니다.
      print('Permission granted. Loading images...');
      _pickImages();
    } else {
      // 권한이 부여되지 않은 경우 설정을 열어 사용자에게 권한 요청을 안내합니다.
      print('Permission denied. Opening settings...');
      PhotoManager.openSetting();
    }
  }

  Future<void> _pickImages() async {
    print('Fetching albums...');
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common, // 이미지와 비디오를 모두 요청합니다.
      hasAll: true, // 모든 앨범 가져오기
    );

    if (albums.isNotEmpty) {
      print('Albums fetched: ${albums.length}');
      List<AssetEntity> photos = await albums[0].getAssetListPaged(
        page: 0,
        size: 100,
      );
      print('Photos fetched: ${photos.length}');

      setState(() {
        _imageEntities = photos;
      });
    } else {
      print('No albums found.');
    }
  }

  Widget _buildGridView() {
    return GridView.builder(
      itemCount: _imageEntities.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (BuildContext context, int index) {
        AssetEntity entity = _imageEntities[index];
        return GestureDetector(
          onTap: () async {
            File? file = await entity.file;
            if (file != null) {
              if (!context.mounted) return;
              Navigator.pop(context, file);
            }
          },
          child: AssetEntityImage(
            entity,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 선택'),
      ),
      body: _imageEntities.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildGridView(),
    );
  }
}
