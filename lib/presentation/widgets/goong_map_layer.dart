import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../data/services/goong_service.dart';

class GoongMapLayer extends StatelessWidget {
  const GoongMapLayer({super.key});

  static Future<Style> _loadStyle() async {
    return StyleReader(uri: GoongService.getStyleUrl()).read();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Style>(
      future: _loadStyle(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return VectorTileLayer(
            tileProviders: snapshot.data!.providers,
            theme: snapshot.data!.theme,
            sprites: snapshot.data!.sprites,
            maximumZoom: 18,
            tileOffset: TileOffset.mapbox,
          );
        }
        return TileLayer(
          urlTemplate: GoongService.getRasterTileUrl(),
          userAgentPackageName: 'com.example.btlmobile',
        );
      },
    );
  }
}
