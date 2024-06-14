import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class ApiService {
  static const String _username = 'user';
  static const String _password = 'e624e7fb-ce72-455d-ab3c-ab874ed87895';
  static const String _baseUrl = 'http://10.0.2.2:8081/api/items';

  static Future<void> initializeNaverMapSdk() async {
    String clientId = await _getClientId();
    await NaverMapSdk.instance.initialize(
      clientId: clientId,
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e"),
    );
  }

  static Future<String> _getClientId() async {
    const platform = MethodChannel('com.pangju/meta');
    try {
      final String clientId = await platform.invokeMethod('getClientId');
      return clientId;
    } on PlatformException catch (e) {
      log("Failed to get client ID: '${e.message}'.");
      return '';
    }
  }

  static Future<List<Map<String, dynamic>>> fetchItems(
      int page, int size) async {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$_username:$_password'))}';
    final uri = Uri.parse('$_baseUrl?page=$page&size=$size');

    log('Sending request to: $uri');
    log('Authorization header: $basicAuth');

    final client = HttpClient();
    final request = await client.getUrl(uri);
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode == 200) {
      // log('Items loaded successfully: $responseBody');
      return List<Map<String, dynamic>>.from(json.decode(responseBody));
    } else {
      log('Failed to load items with status: ${response.statusCode}, body: $responseBody');
      throw Exception('Failed to load items');
    }
  }
}
