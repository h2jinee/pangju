import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class LoadImageScreen extends StatefulWidget {
  final List<File> initialSelectedImages;
  const LoadImageScreen({super.key, required this.initialSelectedImages});

  @override
  _LoadImageScreenState createState() => _LoadImageScreenState();
}

class _LoadImageScreenState extends State<LoadImageScreen> {
  List<AssetEntity> _imageEntities = [];
  final List<AssetEntity> _selectedImages = [];
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _currentAlbum;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndLoadImages();
  }

  Future<void> _requestPermissionAndLoadImages() async {
    final PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      await _loadAlbums();
      await _loadInitialSelectedImages();
    } else {
      openAppSettings();
    }
  }

  Future<void> _loadAlbums() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
      hasAll: true,
    );

    if (albums.isNotEmpty) {
      setState(() {
        _albums = albums;
        _currentAlbum = albums.first;
        _loadImagesFromAlbum(_currentAlbum!);
      });
    }
  }

  Future<void> _loadImagesFromAlbum(AssetPathEntity album) async {
    List<AssetEntity> photos = await album.getAssetListPaged(
      page: 0,
      size: 100,
    );

    setState(() {
      _imageEntities = photos;
    });
  }

  Future<void> _loadInitialSelectedImages() async {
    for (File file in widget.initialSelectedImages) {
      List<AssetEntity> assets = await PhotoManager.getAssetPathList(
        type: RequestType.common,
        filterOption: FilterOptionGroup(
          orders: [const OrderOption(type: OrderOptionType.createDate)],
        ),
      ).then((List<AssetPathEntity> paths) =>
          paths[0].getAssetListRange(start: 0, end: 100));
      for (AssetEntity asset in assets) {
        if (await asset.file == file) {
          setState(() {
            _selectedImages.add(asset);
          });
          break;
        }
      }
    }
  }

  void _toggleSelection(AssetEntity entity) {
    setState(() {
      if (_selectedImages.contains(entity)) {
        _selectedImages.remove(entity);
      } else {
        if (_selectedImages.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('이미지는 최대 5개까지 첨부할 수 있어요.')),
          );
        } else {
          _selectedImages.add(entity);
        }
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
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (BuildContext context, int index) {
        AssetEntity entity = _imageEntities[index];
        int selectedIndex = _selectedImages.indexWhere((img) => img == entity);
        bool isSelected = selectedIndex != -1;
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
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (selectedIndex + 1).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AssetPathEntity>(
              value: _currentAlbum,
              items: _albums
                  .map((album) => DropdownMenuItem(
                        value: album,
                        child: Text(album.name),
                      ))
                  .toList(),
              onChanged: (album) {
                setState(() {
                  _currentAlbum = album;
                  if (album != null) {
                    _loadImagesFromAlbum(album);
                  }
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _imageEntities.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _buildGridView(),
          ),
          Container(
            color: const Color(0xFFFFFFFF),
            height: 70, // Set the height of the bottom bar
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(bottom: 10.0), // Adjust padding to move button up
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 82,
                  height: 41,
                  child: ElevatedButton(
                    onPressed: _selectedImages.isNotEmpty
                        ? () async {
                            List<File> selectedFiles =
                                await _getSelectedFiles();
                            if (!context.mounted) return;
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context, selectedFiles);
                            }
                          }
                        : null,
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                      ),
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.disabled)) {
                            return const Color(0xFFF1F1F1);
                          }
                          return const Color(0xFF37A3E0);
                        },
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Text(
                      '업로드',
                      style: TextStyle(
                        color: _selectedImages.isNotEmpty
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFFC3C3C3),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
