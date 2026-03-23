import 'dart:convert';
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

  final styleUrl = 'https://tiles.goong.io/assets/goong_map_web.json?api_key=$tilesKey';
  print('Fetching: $styleUrl');

  try {
    final res = await http.get(Uri.parse(styleUrl)).timeout(Duration(seconds: 15));
    print('Status: ${res.statusCode}');

    if (res.statusCode == 200) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      File('goong_style.json').writeAsStringSync(
        JsonEncoder.withIndent('  ').convert(data),
      );
      print('Style JSON saved to goong_style.json');

      final sources = data['sources'] as Map<String, dynamic>?;
      if (sources != null) {
        print('\n=== SOURCES ===');
        for (final entry in sources.entries) {
          print('\nSource: ${entry.key}');
          final src = entry.value as Map<String, dynamic>;
          print('  Type: ${src['type']}');
          if (src['tiles'] != null) print('  Tiles: ${src['tiles']}');
          if (src['url'] != null) print('  URL: ${src['url']}');
        }
      }
    } else {
      print('Body: ${res.body.substring(0, res.body.length.clamp(0, 500))}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
