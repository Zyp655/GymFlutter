import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GymImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const GymImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  bool get _isLocalFile =>
      imageUrl.startsWith('/') || imageUrl.startsWith('content://');

  bool get _isNetworkUrl =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLocalFile) {
      return Image.file(
        File(imageUrl),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _placeholder(colorScheme),
      );
    }

    if (_isNetworkUrl) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, __) => Container(
          color: colorScheme.surfaceContainerHighest,
          child: Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          ),
        ),
        errorWidget: (_, __, ___) => _placeholder(colorScheme),
      );
    }

    return _placeholder(colorScheme);
  }

  Widget _placeholder(ColorScheme colorScheme) {
    return Container(
      width: width,
      height: height,
      color: colorScheme.surfaceContainerHighest,
      child: Icon(Icons.fitness_center, size: 64, color: colorScheme.outline),
    );
  }
}
