import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _username = 'user';
  static const String _password = '7e33af58-91b9-4994-a394-f94117a9bd1c';
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

    final response = await http.get(
      Uri.parse('$_baseUrl?page=$page&size=$size'),
      headers: {
        'Authorization': basicAuth,
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      log('Failed to load items with status: ${response.statusCode}');
      throw Exception('Failed to load items');
    }
  }

  static Future<Map<String, dynamic>> fetchItemById(int id) async {
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$_username:$_password'))}';

    final response = await http.get(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Authorization': basicAuth,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log('Failed to load item with status: ${response.statusCode}');
      throw Exception('Failed to load item');
    }
  }
}
