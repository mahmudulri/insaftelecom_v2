import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;

final GlobalKey shareKey = GlobalKey();

Future<void> captureImageFromWidgetAsFile(GlobalKey shareKey) async {
  RenderRepaintBoundary boundary =
      shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  Uint8List unit8list = byteData!.buffer.asUint8List();

  Directory tempDir = await getTemporaryDirectory();
  final path = '${tempDir.path}/image.png';
  File(path).writeAsBytesSync(unit8list);
  await Share.shareXFiles([XFile(path)]);
}
