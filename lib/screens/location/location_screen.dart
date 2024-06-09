import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pangju/screens/service/api_service.dart';
import 'package:pangju/controller/navigation_controller.dart';
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

  final List<String> _categories = ['전체', '온라인', '오프라인', '실종 · 분실'];

  @override
  void initState() {
    super.initState();
    _initializeSdk();
    _fetchItems();

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

    setState(() {
      _isLoadingItems = true;
    });

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
    });
    _initializeSdk().then((_) {
      _fetchItems();
    });
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
              onPressed: () {}, // Search button action
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
          if (_isMapSdkInitialized)
            NaverMap(
              options: const NaverMapViewOptions(
                indoorEnable: true,
                locationButtonEnable: false,
                consumeSymbolTapEvents: false,
              ),
              onMapReady: (controller) async {
                mapControllerCompleter.complete(controller);
                log("onMapReady");
              },
            )
          else
            const Center(
              child: CircularProgressIndicator(),
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
                                    if (_currentChildSize != 0.12) // 추가된 부분
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
