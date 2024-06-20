import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pangju/controller/navigation_controller.dart';
import 'package:pangju/screens/home/item_detail_screen.dart';
import 'package:pangju/service/api_service.dart';
import 'package:pangju/widgets/item_list_tile.dart';
import 'package:pangju/controller/item_controller.dart'; // ItemController import

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  final NavigationController navigationController = Get.find();
  final ItemController itemController =
      Get.put(ItemController()); // ItemController initialization
  bool _isMapSdkInitialized = false;
  bool _isMapLoaded = false; // 맵 로드 상태를 관리할 변수
  double _currentChildSize = 0.12;
  List<double> _snapSizes = const [0.12, 0.5, 1.0];
  int _selectedCategoryIndex = 0;
  Key _draggableScrollableSheetKey = UniqueKey();
  final ScrollController _scrollController = ScrollController();

  NLatLng? _initialPosition;
  bool _isLocationInitialized = false;

  final List<String> _categories = ['전체', '온라인', '오프라인', '실종 · 분실'];

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스가 활성화되어 있는지 확인합니다.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // 위치 권한을 확인합니다.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (mounted) {
      setState(() {
        _initialPosition = NLatLng(position.latitude, position.longitude);
        _isLocationInitialized = true;
      });
    }

    if (mapControllerCompleter.isCompleted) {
      final controller = await mapControllerCompleter.future;
      log('Updating camera position');
      try {
        final cameraUpdate = NCameraUpdate.withParams(
          target: _initialPosition!,
          zoom: 15,
        );
        await controller.updateCamera(cameraUpdate);
        log('Camera position updated');

        // 마커 추가
        _addMarker(controller);
      } catch (e) {
        log('Error updating camera: $e');
      }
    }
  }

  // 커스텀 마커 이미지를 생성하는 함수
  Future<void> _loadMarkerImage() async {
    await precacheImage(
        const AssetImage('assets/images/icons/marker.png'), context);
  }

  Future<NOverlayImage> createCustomMarker() async {
    final customMarkerWidget = Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF37A3E0).withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset('assets/images/icons/marker.png'),
      ),
    );

    return await NOverlayImage.fromWidget(
      widget: customMarkerWidget,
      size: const Size(38, 38),
      context: context,
    );
  }

  Future<void> _addMarker(NaverMapController controller) async {
    await _loadMarkerImage(); // 이미지 로딩이 완료될 때까지 대기
    final customMarkerImage = await createCustomMarker();
    final marker = NMarker(
      id: 'currentLocation',
      position: _initialPosition!,
      icon: customMarkerImage,
    );
    await controller.clearOverlays();
    await controller.addOverlay(marker);
  }

  @override
  void initState() {
    super.initState();
    _initializeSdk();
    itemController.fetchItems();
    _getCurrentLocation();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !itemController.isLoading.value &&
          itemController.hasMoreItems.value &&
          _currentChildSize == 1.0) {
        itemController.fetchItems();
      }
    });
  }

  Future<void> _initializeSdk() async {
    await ApiService.initializeNaverMapSdk();
    setState(() {
      _isMapSdkInitialized = true;
    });
  }

  // 상태를 초기화하는 메서드
  void resetToInitial() {
    if (mounted) {
      setState(() {
        _currentChildSize = 0.12;
        _snapSizes = const [0.12, 0.5, 1.0];
        _draggableScrollableSheetKey =
            UniqueKey(); // Add this line to reset the key
        _isLocationInitialized = false; // 위치 초기화
        _isMapLoaded = false; // 맵 로드 상태 초기화
      });
    }
    _getCurrentLocation();
    itemController.resetItems(); // Reset items
  }

  void _updateChildSize(double size) {
    setState(() {
      _currentChildSize = size;
    });
  }

  void _onCategoryTap(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
    itemController.resetItems(); // Reset items when category changes
  }

  void _onMapButtonPressed() {
    setState(() {
      _currentChildSize = 0.12;
      _snapSizes = const [0.12, 0.5, 1.0];
      _draggableScrollableSheetKey = UniqueKey(); // To reset the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '내 근처',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF262626),
                ),
              ),
              SvgPicture.asset(
                'assets/images/icons/search.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFF484848),
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFE5E5E5),
            height: 1.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (_isMapSdkInitialized && _isLocationInitialized)
            NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: _initialPosition!,
                  zoom: 15,
                ),
                indoorEnable: true,
                locationButtonEnable: false,
                consumeSymbolTapEvents: false,
              ),
              onMapReady: (controller) async {
                if (!mapControllerCompleter.isCompleted) {
                  mapControllerCompleter.complete(controller);
                }
                log("onMapReady");

                // 마커 추가
                if (_isLocationInitialized) {
                  await _addMarker(controller);
                }
                setState(() {
                  _isMapLoaded = true; // 맵 로드 완료 상태 설정
                });
              },
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_isMapLoaded)
            NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                _updateChildSize(notification.extent);
                return true;
              },
              child: DraggableScrollableSheet(
                key: _draggableScrollableSheetKey,
                initialChildSize: _currentChildSize,
                minChildSize: 0.12,
                maxChildSize: 1.0,
                snap: true,
                snapSizes: _snapSizes,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: _currentChildSize == 1.0
                          ? BorderRadius.zero
                          : const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                      boxShadow: _currentChildSize == 1.0
                          ? []
                          : [
                              const BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                spreadRadius: 0.5,
                              ),
                            ],
                    ),
                    child: Obx(
                      () => itemController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : NotificationListener<ScrollNotification>(
                              onNotification:
                                  (ScrollNotification scrollNotification) {
                                if (scrollNotification.metrics.pixels ==
                                        scrollNotification
                                            .metrics.maxScrollExtent &&
                                    !itemController.isLoading.value &&
                                    itemController.hasMoreItems.value &&
                                    _currentChildSize == 1.0) {
                                  itemController.fetchItems();
                                }
                                return true;
                              },
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: itemController.items.length + 1,
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == 0) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                            left: 15,
                                            bottom: 10,
                                          ),
                                          child: SizedBox(
                                            height: 37,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _categories.length,
                                              itemBuilder: (context, index) {
                                                bool isSelected =
                                                    _selectedCategoryIndex ==
                                                        index;

                                                return GestureDetector(
                                                  onTap: () =>
                                                      _onCategoryTap(index),
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 3),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 14,
                                                        vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: isSelected
                                                          ? const Color(
                                                              0xFF37A3E0)
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                          color:
                                                              Colors.black12),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        _categories[index],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          height: 1.3,
                                                          letterSpacing: -0.2,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: isSelected
                                                              ? Colors.white
                                                              : const Color(
                                                                  0xFF484848),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        if (_currentChildSize != 0.12)
                                          Container(
                                            height: 1,
                                            color: const Color(
                                                0xFFE5E5E5), // Stroke color
                                          ),
                                      ],
                                    );
                                  }

                                  if (_currentChildSize > 0.12) {
                                    final item =
                                        itemController.items[index - 1];
                                    return ItemListTile(
                                      item: item,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ItemDetailScreen(
                                                    id: item['id']),
                                          ),
                                        );
                                      },
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          if (_currentChildSize == 1.0 && _isMapLoaded)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: _onMapButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF37A3E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/icons/place_filled.svg',
                        width: 12.5,
                        height: 15.83,
                        colorFilter: const ColorFilter.mode(
                          Colors.white, // FFFFFF 색상으로 아이콘 색상 변경
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 5), // 아이콘과 텍스트 사이에 간격 추가
                      const Text(
                        '지도보기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.3,
                          letterSpacing: -0.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
