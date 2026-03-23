import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> main() async {
  final envFile = File('.env');
  final envMap = <String, String>{};
  for (final line in envFile.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final idx = trimmed.indexOf('=');
    if (idx > 0) {
      envMap[trimmed.substring(0, idx)] = trimmed.substring(idx + 1);
    }
  }
  final tilesKey = envMap['GOONG_MAP_TILES_KEY'] ?? '';
  final url = 'https://raster.goong.io/roadmap/10/820/474@2x.png?api_key=$tilesKey';
  print('Testing: $url');
  try {
    final res = await http.get(Uri.parse(url));
    print('Status: ${res.statusCode}');
    print('Size: ${res.bodyBytes.length} bytes');
    print('Content-Type: ${res.headers['content-type']}');
    if (res.statusCode == 200 && res.bodyBytes.length > 1000) {
      print('✅ Raster tiles working!');
    } else {
      print('❌ Raster tiles not working');
      print('Body: ${res.body.substring(0, (res.body.length).clamp(0, 300))}');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}
