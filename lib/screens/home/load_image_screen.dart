import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  OverlayEntry? _dropdownOverlay;
  final GlobalKey _appBarKey = GlobalKey();
  bool _isLoading = true;

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
      setState(() {
        _isLoading = false;
      });
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
      _updateSelectedImages();
      _isLoading = false;
    });
  }

  Future<void> _loadInitialSelectedImages() async {
    for (File file in widget.initialSelectedImages) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      bool found = false;

      for (AssetPathEntity album in albums) {
        final int count = await album.assetCountAsync;
        List<AssetEntity> assets = await album.getAssetListRange(
          start: 0,
          end: count,
        );

        for (AssetEntity asset in assets) {
          File? assetFile = await asset.file;
          if (assetFile != null && assetFile.path == file.path) {
            _selectedImages.add(asset);
            found = true;
            break;
          }
        }
        if (found) break;
      }
    }
    _updateSelectedImages();
    setState(() {});
  }

  void _updateSelectedImages() {
    for (AssetEntity entity in _imageEntities) {
      if (_selectedImages.any((selected) => selected.id == entity.id) &&
          !_selectedImages.contains(entity)) {
        _selectedImages.add(entity);
      }
    }
  }

  void _toggleSelection(AssetEntity entity) {
    setState(() {
      if (_selectedImages.contains(entity)) {
        _selectedImages.remove(entity);
      } else {
        if (_selectedImages.length >= 5) {
          _showAlertDialog('이미지는 최대 5개까지 첨부할 수 있어요.');
        } else {
          _selectedImages.add(entity);
        }
      }
    });
  }

  Future<void> _showAlertDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

  void _toggleDropdown() {
    if (_dropdownOverlay != null) {
      _dropdownOverlay?.remove();
      _dropdownOverlay = null;
    } else {
      _showDropdown(context);
    }
  }

  void _showDropdown(BuildContext context) {
    final RenderBox appBarRenderBox =
        _appBarKey.currentContext!.findRenderObject() as RenderBox;
    final appBarOffset = appBarRenderBox.localToGlobal(Offset.zero);

    _dropdownOverlay = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 0,
          top: appBarOffset.dy + appBarRenderBox.size.height,
          width: MediaQuery.of(context).size.width,
          child: Material(
            color: Colors.white,
            elevation: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _albums.map((album) {
                return ListTile(
                  title: Text(album.name == 'Recent' ? '최근 항목' : album.name),
                  onTap: () async {
                    setState(() {
                      _isLoading = true;
                      _currentAlbum = album;
                    });
                    await _loadImagesFromAlbum(album);
                    _toggleDropdown();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_dropdownOverlay!);
  }

  @override
  void dispose() {
    _dropdownOverlay?.remove();
    super.dispose();
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
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF37A3E0)
                        : const Color(0x66FFFFFF),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                  child: Center(
                    child: isSelected
                        ? Text(
                            (selectedIndex + 1).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          )
                        : null,
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
        key: _appBarKey,
        backgroundColor: const Color(0xFFFFFFFF),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/icons/left_arrow.svg',
            width: 9.43,
            height: 19.74,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: GestureDetector(
          onTap: _toggleDropdown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLoading
                    ? ''
                    : _currentAlbum?.name == 'Recent'
                        ? '최근 항목'
                        : _currentAlbum?.name ?? '',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/icons/down_arrow.svg',
                    width: 6.47,
                    height: 9,
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildGridView(),
          ),
          Container(
            height: 80,
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).padding.bottom + 15,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              border: Border(
                top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _selectedImages.isNotEmpty
                      ? () async {
                          List<File> selectedFiles = await _getSelectedFiles();
                          if (!context.mounted) return;
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context, selectedFiles);
                          }
                        }
                      : null,
                  child: Container(
                    width: 82,
                    height: 41,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedImages.isNotEmpty
                          ? const Color(0xFF37A3E0)
                          : const Color(0xFFF1F1F1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '업로드',
                      style: TextStyle(
                        color: _selectedImages.isNotEmpty
                            ? Colors.white
                            : const Color(0xFFC3C3C3),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
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
