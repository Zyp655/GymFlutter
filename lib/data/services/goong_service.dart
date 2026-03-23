import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';

class GoongPlace {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  const GoongPlace({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  factory GoongPlace.fromJson(Map<String, dynamic> json) {
    final structured = json['structured_formatting'] as Map<String, dynamic>?;
    return GoongPlace(
      placeId: json['place_id'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mainText: structured?['main_text'] as String? ?? '',
      secondaryText: structured?['secondary_text'] as String? ?? '',
    );
  }
}

class GoongPlaceDetail {
  final double latitude;
  final double longitude;
  final String formattedAddress;

  const GoongPlaceDetail({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
  });
}

class GoongGeocode {
  final double latitude;
  final double longitude;
  final String formattedAddress;

  const GoongGeocode({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
  });
}

class GoongService {
  static const _baseUrl = 'https://rsapi.goong.io';

  String get _apiKey => AppConfig.goongApiKey;

  Future<List<GoongPlace>> searchPlaces(String query) async {
    if (query.trim().isEmpty || _apiKey.isEmpty) return [];

    final uri = Uri.parse('$_baseUrl/Place/AutoComplete').replace(
      queryParameters: {
        'api_key': _apiKey,
        'input': query,
        'location': '21.028511,105.804817',
        'limit': '10',
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return [];

    final data = json.decode(response.body) as Map<String, dynamic>;
    final predictions = data['predictions'] as List<dynamic>? ?? [];

    return predictions
        .map((p) => GoongPlace.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  Future<GoongPlaceDetail?> getPlaceDetail(String placeId) async {
    if (placeId.isEmpty || _apiKey.isEmpty) return null;

    final uri = Uri.parse('$_baseUrl/Place/Detail').replace(
      queryParameters: {
        'api_key': _apiKey,
        'place_id': placeId,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    final result = data['result'] as Map<String, dynamic>?;
    if (result == null) return null;

    final geometry = result['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;
    if (location == null) return null;

    return GoongPlaceDetail(
      latitude: (location['lat'] as num).toDouble(),
      longitude: (location['lng'] as num).toDouble(),
      formattedAddress: result['formatted_address'] as String? ?? '',
    );
  }

  Future<GoongGeocode?> reverseGeocode(double lat, double lng) async {
    if (_apiKey.isEmpty) return null;

    final uri = Uri.parse('$_baseUrl/Geocode').replace(
      queryParameters: {
        'api_key': _apiKey,
        'latlng': '$lat,$lng',
      },
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>?;
    if (results == null || results.isEmpty) return null;

    final first = results.first as Map<String, dynamic>;
    final geometry = first['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;

    return GoongGeocode(
      latitude: (location?['lat'] as num?)?.toDouble() ?? lat,
      longitude: (location?['lng'] as num?)?.toDouble() ?? lng,
      formattedAddress: first['formatted_address'] as String? ?? '',
    );
  }

  static String getStyleUrl() {
    final key = AppConfig.goongMapTilesKey;
    return 'https://tiles.goong.io/assets/goong_map_web.json?api_key=$key';
  }

  static String getRasterTileUrl() {
    return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }
}
