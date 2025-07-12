import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareController {
  static Future<void> shareChart(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/shared_chart.png').create();
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)], text: 'Shared Chart');
    } catch (e) {
      Get.snackbar('Error', 'Failed to share screenshot');
    }
  }
}
