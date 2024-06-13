import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class ClusterMapScreen extends StatefulWidget {
  const ClusterMapScreen({super.key});

  @override
  _ClusterMapScreenState createState() => _ClusterMapScreenState();
}

class _ClusterMapScreenState extends State<ClusterMapScreen> {
  final Completer<NaverMapController> _controller = Completer();
  final List<NLatLng> markerPositions = [
    const NLatLng(37.559100098899556, 127.20105086155206),
    const NLatLng(37.55679331382699, 127.20640916861812),
    const NLatLng(37.556368393939664, 127.20203945834803),
    // 추가적인 마커 위치를 여기에 추가합니다.
  ];
  List<NMarker> _markers = [];

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() async {
    final markers = <NMarker>[];
    for (var position in markerPositions) {
      final marker = NMarker(
        id: position.toString(),
        position: position,
        icon: await createCustomMarker(),
      );
      markers.add(marker);
    }
    setState(() {
      _markers = markers;
    });
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

  void _clusterMarkers(
      NaverMapController controller, List<NMarker> markers) async {
    final clusters = <String, List<NMarker>>{};

    for (var marker in markers) {
      final key = _getClusterKey(marker.position);
      clusters.putIfAbsent(key, () => []).add(marker);
    }

    await controller.clearOverlays();

    for (var clusterKey in clusters.keys) {
      final cluster = clusters[clusterKey]!;
      if (cluster.length > 1) {
        final clusterMarker = NMarker(
          id: clusterKey,
          position: _getClusterCenter(cluster),
          icon: await createClusterIcon(cluster.length),
        );
        await controller.addOverlay(clusterMarker);
      } else {
        await controller.addOverlay(cluster.first);
      }
    }
  }

  String _getClusterKey(NLatLng position) {
    const clusterSize = 0.01; // 클러스터 크기 조정
    final lat = (position.latitude / clusterSize).floor() * clusterSize;
    final lng = (position.longitude / clusterSize).floor() * clusterSize;
    return '$lat,$lng';
  }

  NLatLng _getClusterCenter(List<NMarker> cluster) {
    double lat = 0;
    double lng = 0;
    for (var marker in cluster) {
      lat += marker.position.latitude;
      lng += marker.position.longitude;
    }
    return NLatLng(lat / cluster.length, lng / cluster.length);
  }

  Future<NOverlayImage> createClusterIcon(int count) async {
    final clusterIconWidget = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count.toString(),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return await NOverlayImage.fromWidget(
      widget: clusterIconWidget,
      size: const Size(40, 40),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(37.5666102, 126.9783881),
                zoom: 12,
              ),
              indoorEnable: true,
              locationButtonEnable: false,
              consumeSymbolTapEvents: false,
            ),
            onMapReady: (controller) async {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
              _clusterMarkers(controller, _markers);
            },
            onCameraIdle: () async {
              final controller = await _controller.future;
              _clusterMarkers(controller, _markers);
            },
          ),
        ],
      ),
    );
  }
}
