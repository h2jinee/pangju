import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class LoadImageScreen extends StatefulWidget {
  const LoadImageScreen({super.key});

  @override
  _LoadImageScreenState createState() => _LoadImageScreenState();
}

class _LoadImageScreenState extends State<LoadImageScreen> {
  List<AssetEntity> _imageEntities = [];
  final List<AssetEntity> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadImages();
  }

  Future<void> _requestPermissionAndLoadImages() async {
    final PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      _pickImages();
    } else {
      openAppSettings();
    }
  }

  Future<void> _pickImages() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      hasAll: true,
    );

    if (albums.isNotEmpty) {
      List<AssetEntity> photos = await albums[0].getAssetListPaged(
        page: 0,
        size: 100,
      );

      setState(() {
        _imageEntities = photos;
      });
    }
  }

  void _toggleSelection(AssetEntity entity) {
    setState(() {
      if (_selectedImages.contains(entity)) {
        _selectedImages.remove(entity);
      } else {
        _selectedImages.add(entity);
      }
    });
  }

  Future<List<File>> _getSelectedFiles() async {
    List<File> files = [];
    for (AssetEntity entity in _selectedImages) {
      File? file = await entity.file;
      if (file != null) {
        files.add(file);
      }
    }
    return files;
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
        bool isSelected = _selectedImages.contains(entity);
        return GestureDetector(
          onTap: () {
            _toggleSelection(entity);
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: AssetEntityImage(
                  entity,
                  fit: BoxFit.cover,
                ),
              ),
              if (isSelected)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.blue,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 선택'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              // 비동기 작업이 완료될 때까지 잠시 기다립니다.
              List<File> selectedFiles = await _getSelectedFiles();
              if (!context.mounted) return; // 상태가 변경되지 않았는지 확인합니다.
              if (Navigator.canPop(context)) {
                Navigator.pop(context, selectedFiles);
              }
            },
          ),
        ],
      ),
      body: _imageEntities.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildGridView(),
    );
  }
}
