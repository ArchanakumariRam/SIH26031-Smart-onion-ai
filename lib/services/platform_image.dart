import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'platform_image_io.dart'
    if (dart.library.html) 'platform_image_web.dart' as platform;

ImageProvider<Object>? imageProviderForPath(String? path) {
  return platform.imageProviderForPath(path);
}

Future<Uint8List> readImageBytes(String path) {
  return platform.readImageBytes(path);
}

Widget imageOrPlaceholder(
  String? path, {
  required Widget placeholder,
  BoxFit fit = BoxFit.cover,
}) {
  final imageProvider = imageProviderForPath(path);
  if (imageProvider == null) return placeholder;

  return Image(
    image: imageProvider,
    fit: fit,
    errorBuilder: (context, error, stackTrace) => placeholder,
  );
}
