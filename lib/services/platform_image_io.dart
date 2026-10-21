import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

ImageProvider<Object>? imageProviderForPath(String? path) {
  if (path == null) return null;
  final file = File(path);
  return file.existsSync() ? FileImage(file) : null;
}

Future<Uint8List> readImageBytes(String path) {
  return File(path).readAsBytes();
}
