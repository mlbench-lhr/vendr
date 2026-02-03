import 'dart:ui';
import 'package:flutter/material.dart';

class SmallRPSCustomPainter extends CustomPainter {
  final double radius;

  SmallRPSCustomPainter({this.radius = 40.0});

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate scale factor based on the radius
    // For 40.r, badge size is 26x26
    // For 21.r, badge size should be proportionally smaller
    double scaleFactor = radius / 40.0;
    double badgeSize = 26.0 * scaleFactor;

    // Calculate the scale for the original coordinates (which go up to ~18.66)
    double scaleX = badgeSize / 20.0;
    double scaleY = badgeSize / 20.0;

    // Scale the canvas so your small coordinates fill the space
    canvas.scale(scaleX, scaleY);

    // Main Octagon Shape
    Path path_0 = Path();
    path_0.moveTo(2.34098, 6.6209);
    path_0.cubicTo(2.20966, 6.02912, 2.22983, 5.41375, 2.39961, 4.83185);
    path_0.cubicTo(2.56939, 4.24994, 2.88329, 3.72035, 3.31221, 3.29216);
    path_0.cubicTo(3.74112, 2.86397, 4.27117, 2.55105, 4.8532, 2.38242);
    path_0.cubicTo(5.43523, 2.21379, 6.05039, 2.19491, 6.64166, 2.32752);
    path_0.cubicTo(6.9671, 1.81835, 7.41543, 1.39933, 7.94532, 1.10908);
    path_0.cubicTo(8.47521, 0.818825, 9.06961, 0.666687, 9.67373, 0.666687);
    path_0.cubicTo(10.2779, 0.666687, 10.8723, 0.818825, 11.4021, 1.10908);
    path_0.cubicTo(11.932, 1.39933, 12.3804, 1.81835, 12.7058, 2.32752);
    path_0.cubicTo(13.298, 2.19433, 13.9142, 2.21313, 14.4971, 2.38217);
    path_0.cubicTo(15.0801, 2.55121, 15.6109, 2.865, 16.04, 3.29435);
    path_0.cubicTo(16.4692, 3.72369, 16.7829, 4.25466, 16.9518, 4.83784);
    path_0.cubicTo(17.1208, 5.42103, 17.1396, 6.03749, 17.0065, 6.6299);
    path_0.cubicTo(17.5154, 6.95546, 17.9343, 7.40397, 18.2244, 7.93407);
    path_0.cubicTo(18.5146, 8.46416, 18.6667, 9.0588, 18.6667, 9.66316);
    path_0.cubicTo(18.6667, 10.2675, 18.5146, 10.8622, 18.2244, 11.3923);
    path_0.cubicTo(17.9343, 11.9224, 17.5154, 12.3709, 17.0065, 12.6964);
    path_0.cubicTo(17.139, 13.2879, 17.1202, 13.9033, 16.9516, 14.4856);
    path_0.cubicTo(16.783, 15.0678, 16.4702, 15.5981, 16.0422, 16.0272);
    path_0.cubicTo(15.6142, 16.4563, 15.0848, 16.7703, 14.5031, 16.9401);
    path_0.cubicTo(13.9215, 17.11, 13.3063, 17.1302, 12.7148, 16.9988);
    path_0.cubicTo(12.3898, 17.5099, 11.9411, 17.9307, 11.4103, 18.2223);
    path_0.cubicTo(10.8795, 18.5138, 10.2838, 18.6667, 9.67823, 18.6667);
    path_0.cubicTo(9.07269, 18.6667, 8.47694, 18.5138, 7.94615, 18.2223);
    path_0.cubicTo(7.41535, 17.9307, 6.96668, 17.5099, 6.64166, 16.9988);
    path_0.cubicTo(6.05039, 17.1314, 5.43523, 17.1125, 4.8532, 16.9439);
    path_0.cubicTo(4.27117, 16.7753, 3.74112, 16.4624, 3.31221, 16.0342);
    path_0.cubicTo(2.88329, 15.606, 2.56939, 15.0764, 2.39961, 14.4945);
    path_0.cubicTo(2.22983, 13.9126, 2.20966, 13.2972, 2.34098, 12.7054);
    path_0.cubicTo(1.8281, 12.3807, 1.40564, 11.9315, 1.1129, 11.3996);
    path_0.cubicTo(0.820166, 10.8677, 0.666656, 10.2704, 0.666656, 9.66316);
    path_0.cubicTo(0.666656, 9.05596, 0.820166, 8.45862, 1.1129, 7.92672);
    path_0.cubicTo(1.40564, 7.39481, 1.8281, 6.9456, 2.34098, 6.6209);
    path_0.close();

    Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;

    canvas.drawPath(path_0, fillPaint);

    Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path_0, strokePaint);

    // Check Mark
    Path path_1 = Path();
    path_1.moveTo(6.32916, 9.62921);
    path_1.lineTo(8.95416, 12.2542);
    path_1.lineTo(14.2042, 6.62921);

    Paint checkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path_1, checkPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
