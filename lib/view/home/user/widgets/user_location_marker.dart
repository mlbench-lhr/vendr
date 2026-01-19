import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future<BitmapDescriptor> createCustomMarker(
  String? imageUrl,
  String label,
) async {
  ui.Image? image;

  // Try loading network image only if URL is provided
  if (imageUrl != null && imageUrl.trim().isNotEmpty) {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final codec = await ui.instantiateImageCodec(
          response.bodyBytes,
          targetWidth: 80,
        );
        final frame = await codec.getNextFrame();
        image = frame.image;
      }
    } catch (_) {
      // ignore — fallback icon will be used
    }
  }

  const double imageSize = 80;
  const double textHeight = 18;
  const double totalHeight = imageSize + textHeight;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  const double radius = imageSize / 2;
  const Offset center = Offset(radius, radius);

  // Border
  canvas.drawCircle(center, radius + 3, Paint()..color = Colors.white);

  // -------- CASE 1: network image available --------
  if (image != null) {
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    paintImage(
      canvas: canvas,
      rect: const Rect.fromLTWH(0, 0, imageSize, imageSize),
      image: image,
      fit: BoxFit.cover,
    );

    canvas.restore();
  }
  // -------- CASE 2: NO image -> draw user icon --------
  else {
    // background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = const Color(0xFFE5E7EB), // light grey
    );

    // Material user icon
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.person.codePoint),
        style: TextStyle(
          fontFamily: Icons.person.fontFamily,
          // fontPackage: Icons.person.fontPackage,
          fontSize: 46,
          color: const Color(0xFF6B7280), // grey icon
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final iconOffset = Offset(
      center.dx - (iconPainter.width / 2),
      center.dy - (iconPainter.height / 2),
    );

    iconPainter.paint(canvas, iconOffset);
  }

  // Truncate long labels
  final displayLabel = label.length > 12 ? '${label.substring(0, 12)}…' : label;

  // Label text
  final textPainter = TextPainter(
    text: TextSpan(
      text: displayLabel,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: imageSize, maxWidth: imageSize);

  textPainter.paint(canvas, const Offset(0, imageSize + 2));

  final markerImage = await recorder.endRecording().toImage(
    imageSize.ceil(),
    totalHeight.ceil(),
  );

  final byteData = await markerImage.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}
