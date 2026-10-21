import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

ImageProvider<Object>? imageProviderForPath(String? path) {
  if (path == null) return null;
  return NetworkImage(path);
}

Future<Uint8List> readImageBytes(String path) async {
  final response = await http.get(Uri.parse(path));
  if (response.statusCode != 200) {
    throw Exception('Failed to load image: HTTP ${response.statusCode}');
  }
  return response.bodyBytes;
}
