import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pangju/controller/navigation_controller.dart';
import 'package:pangju/screens/service/api_service.dart';
import 'package:pangju/widgets/item_list_tile.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  final NavigationController navigationController = Get.find();
  bool _isMapSdkInitialized = false;
  double _currentChildSize = 0.12;
  List<double> _snapSizes = const [0.12, 0.5, 1.0];
  final List<Map<String, dynamic>> _items = [];
  bool _isLoadingItems = false;
  bool _hasMoreItems = true;
  int _currentPage = 1;
  final int _itemsPerPage = 15;
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
      await controller.updateCamera(NCameraUpdate.withParams(
        target: _initialPosition!,
        zoom: 15,
      ));

      // 마커 추가
      if (mounted) {
        final customMarkerImage = await createCustomMarker();
        final marker = NMarker(
          id: 'currentLocation',
          position: _initialPosition!,
          icon: customMarkerImage,
        );
        await controller.clearOverlays();
        await controller.addOverlay(marker);
      }
    }
  }

  // 커스텀 마커 이미지를 생성하는 함수
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

  Future<void> _searchLocation(String query) async {
    final url = Uri.parse(
        'https://openapi.naver.com/v1/search/local.json?query=$query&display=5&sort=comment');
    final response = await http.get(
      url,
      headers: {
        'X-Naver-Client-Id': 'HEPrP9HkJgIr4iDgmHD3',
        'X-Naver-Client-Secret': 'cP0OTRXucq',
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      log('Search result: $result');
      // TODO: Handle the search result
    } else {
      log('Failed to search location: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSdk();
    _fetchItems();
    _getCurrentLocation();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingItems &&
          _hasMoreItems &&
          _currentChildSize == 1.0) {
        _fetchItems();
      }
    });
  }

  Future<void> _initializeSdk() async {
    await ApiService.initializeNaverMapSdk();
    setState(() {
      _isMapSdkInitialized = true;
    });
  }

  Future<void> _fetchItems() async {
    if (!_hasMoreItems) return;

    if (mounted) {
      setState(() {
        _isLoadingItems = true;
      });
    }

    try {
      List<Map<String, dynamic>> newItems =
          await ApiService.fetchItems(_currentPage, _itemsPerPage);
      if (newItems.isEmpty) {
        if (mounted) {
          setState(() {
            _hasMoreItems = false;
            _isLoadingItems = false;
          });
        }
        return;
      }
      if (mounted) {
        setState(() {
          _items.addAll(newItems);
          _isLoadingItems = false;
          _currentPage++;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingItems = false;
        });
      }
    }
  }

  // 상태를 초기화하는 메서드
  void resetToInitial() {
    if (mounted) {
      setState(() {
        _currentChildSize = 0.12;
        _snapSizes = const [0.12, 0.5, 1.0];
        _items.clear();
        _isLoadingItems = false;
        _hasMoreItems = true;
        _currentPage = 1;
        _selectedCategoryIndex = 0;
        _draggableScrollableSheetKey =
            UniqueKey(); // Add this line to reset the key
        _isLocationInitialized = false; // 위치 초기화
      });
    }
    _getCurrentLocation();
  }

  void _updateChildSize(double size) {
    setState(() {
      _currentChildSize = size;
    });
  }

  void _onCategoryTap(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _items.clear();
      _currentPage = 1;
      _hasMoreItems = true;
    });
    _fetchItems();
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
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          '내근처',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/images/icons/search.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFF000000),
                  BlendMode.srcIn,
                ),
              ),
              onPressed: () {
                _searchLocation('강남');
              }, // Search button action
            ),
          ),
        ],
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
                final customMarkerImage = await createCustomMarker();
                final marker = NMarker(
                  id: 'currentLocation',
                  position: _initialPosition!,
                  icon: customMarkerImage,
                );
                await controller.addOverlay(marker);
              },
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: 15,
            right: 15,
            child: GestureDetector(
              onTap: () async {
                await _getCurrentLocation();
                setState(() {});
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      offset: const Offset(0, 0),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/icons/gps.svg',
                    width: 21.6,
                    height: 21.6,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF37A3E0),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                  child: _isLoadingItems
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : NotificationListener<ScrollNotification>(
                          onNotification:
                              (ScrollNotification scrollNotification) {
                            if (scrollNotification.metrics.pixels ==
                                    scrollNotification
                                        .metrics.maxScrollExtent &&
                                !_isLoadingItems &&
                                _hasMoreItems &&
                                _currentChildSize == 1.0) {
                              _fetchItems();
                            }
                            return true;
                          },
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: _items.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: _currentChildSize == 0.12
                                          ? const EdgeInsets.only(
                                              top: 20,
                                              left: 15,
                                              bottom: 10,
                                            )
                                          : const EdgeInsets.symmetric(
                                              vertical: 20,
                                              horizontal: 15,
                                            ),
                                      child: SizedBox(
                                        height: 37,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _categories.length,
                                          itemBuilder: (context, index) {
                                            bool isSelected =
                                                _selectedCategoryIndex == index;

                                            return GestureDetector(
                                              onTap: () =>
                                                  _onCategoryTap(index),
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color(0xFF37A3E0)
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                      color: Colors.black12),
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
                                final item = _items[index - 1];
                                return ItemListTile(item: item);
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                );
              },
            ),
          ),
          if (_currentChildSize == 1.0)
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
                  child: const Text(
                    '지도보기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.3,
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
