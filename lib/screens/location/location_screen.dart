import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pangju/widgets/bottom_navigation_bar.dart';

void main() async {
  await _initialize();
  runApp(const NaverMapApp());
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  String clientId = await _getClientId();
  await NaverMapSdk.instance.initialize(
    clientId: clientId, // 클라이언트 ID 설정
    onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"),
  );
}

Future<String> _getClientId() async {
  const platform = MethodChannel('com.pangju/meta');
  try {
    final String clientId = await platform.invokeMethod('getClientId');
    return clientId;
  } on PlatformException catch (e) {
    log("Failed to get client ID: '${e.message}'.");
    return '';
  }
}

class NaverMapApp extends StatelessWidget {
  const NaverMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int _selectedIndex = 1; // 해당 페이지의 인덱스
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  bool _isMapSdkInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    String clientId = await _getClientId();
    await NaverMapSdk.instance.initialize(
      clientId: clientId, // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"),
    );
    setState(() {
      _isMapSdkInitialized = true;
    });
  }

  Future<String> _getClientId() async {
    const platform = MethodChannel('com.pangju/meta');
    try {
      final String clientId = await platform.invokeMethod('getClientId');
      return clientId;
    } on PlatformException catch (e) {
      log("Failed to get client ID: '${e.message}'.");
      return '';
    }
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
        centerTitle: true, // Center align the text
        title: const Text(
          '내근처',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500, // Medium weight
            color: Colors.black, // Change text color to black
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
                // 검색 아이콘 클릭 시 동작
              },
            ),
          ),
        ],
      ),
      body: _isMapSdkInitialized
          ? Column(
              children: [
                Expanded(
                  flex: 3,
                  child: NaverMap(
                    options: const NaverMapViewOptions(
                      indoorEnable: true, // 실내 맵 사용 가능 여부 설정
                      locationButtonEnable: false, // 위치 버튼 표시 여부 설정
                      consumeSymbolTapEvents: false, // 심볼 탭 이벤트 소비 여부 설정
                    ),
                    onMapReady: (controller) async {
                      // 지도 준비 완료 시 호출되는 콜백 함수
                      mapControllerCompleter
                          .complete(controller); // Completer에 지도 컨트롤러 완료 신호 전송
                      log("onMapReady", name: "onMapReady");
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF37A3E0),
        unselectedItemColor: const Color(0xFF484848),
        onTap: (index) => onItemTapped(index),
        currentIndex: _selectedIndex,
        items: bottomNavigationBarItems(context, _selectedIndex, (int idx) {
          setState(() {
            _selectedIndex = idx;
          });
        }),
      ),
    );
  }
}
