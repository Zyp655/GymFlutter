import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> main() async {
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    print('❌ .env file not found');
    exit(1);
  }

  final envMap = <String, String>{};
  for (final line in envFile.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final idx = trimmed.indexOf('=');
    if (idx > 0) {
      envMap[trimmed.substring(0, idx)] = trimmed.substring(idx + 1);
    }
  }

  final apiKey = envMap['GOONG_API_KEY'] ?? '';
  final tilesKey = envMap['GOONG_MAP_TILES_KEY'] ?? '';

  print('========================================');
  print('  GOONG API KEY TEST');
  print('========================================\n');

  // --- Test 1: Place AutoComplete (GOONG_API_KEY) ---
  print('🔍 Test 1: Place AutoComplete API');
  print('   Key: ${apiKey.substring(0, 8)}...${apiKey.substring(apiKey.length - 4)}');
  try {
    final uri = Uri.parse('https://rsapi.goong.io/Place/AutoComplete').replace(
      queryParameters: {
        'api_key': apiKey,
        'input': 'Hà Nội',
        'limit': '3',
      },
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      final predictions = data['predictions'] as List<dynamic>? ?? [];
      print('   ✅ Status: ${res.statusCode} OK');
      print('   📍 Results: ${predictions.length} places found');
      for (final p in predictions.take(3)) {
        print('      - ${p['description']}');
      }
    } else {
      print('   ❌ Status: ${res.statusCode}');
      print('   Response: ${res.body}');
    }
  } catch (e) {
    print('   ❌ Error: $e');
  }

  print('');

  // --- Test 2: Reverse Geocode (GOONG_API_KEY) ---
  print('🔍 Test 2: Reverse Geocode API');
  try {
    final uri = Uri.parse('https://rsapi.goong.io/Geocode').replace(
      queryParameters: {
        'api_key': apiKey,
        'latlng': '21.028511,105.804817',
      },
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>? ?? [];
      print('   ✅ Status: ${res.statusCode} OK');
      if (results.isNotEmpty) {
        print('   📍 Address: ${results.first['formatted_address']}');
      }
    } else {
      print('   ❌ Status: ${res.statusCode}');
      print('   Response: ${res.body}');
    }
  } catch (e) {
    print('   ❌ Error: $e');
  }

  print('');

  // --- Test 3: Map Tiles (GOONG_MAP_TILES_KEY) ---
  print('🗺️  Test 3: Map Tiles');
  print('   Key: ${tilesKey.substring(0, 8)}...${tilesKey.substring(tilesKey.length - 4)}');
  try {
    final tileUrl =
        'https://tiles.goong.io/assets/goong_map_web/15/26209/15192.png?api_key=$tilesKey';
    final res = await http.get(Uri.parse(tileUrl));
    if (res.statusCode == 200 && res.bodyBytes.length > 1000) {
      print('   ✅ Status: ${res.statusCode} OK');
      print('   🖼️  Tile size: ${res.bodyBytes.length} bytes (valid PNG)');
    } else if (res.statusCode == 200) {
      print('   ⚠️  Status: 200 but tile is very small (${res.bodyBytes.length} bytes)');
    } else {
      print('   ❌ Status: ${res.statusCode}');
      print('   Response: ${res.body.substring(0, (res.body.length).clamp(0, 200))}');
    }
  } catch (e) {
    print('   ❌ Error: $e');
  }

  print('\n========================================');
  print('  TEST COMPLETE');
  print('========================================');
}
