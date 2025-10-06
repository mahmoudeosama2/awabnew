import 'package:flutter/cupertino.dart';

class MyCustomBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 414;
    final double yScaling = size.height / 189.5;
    path.lineTo(414 * xScaling, 0.5 * yScaling);
    path.cubicTo(
      414 * xScaling,
      0.5 * yScaling,
      414 * xScaling,
      190 * yScaling,
      414 * xScaling,
      190 * yScaling,
    );
    path.cubicTo(
      414 * xScaling,
      190 * yScaling,
      0 * xScaling,
      190 * yScaling,
      0 * xScaling,
      190 * yScaling,
    );
    path.cubicTo(
      0 * xScaling,
      190 * yScaling,
      0 * xScaling,
      130.5 * yScaling,
      0 * xScaling,
      130.5 * yScaling,
    );
    path.cubicTo(
      0 * xScaling,
      127.333 * yScaling,
      11 * xScaling,
      112.6 * yScaling,
      55 * xScaling,
      79 * yScaling,
    );
    path.cubicTo(
      110 * xScaling,
      37 * yScaling,
      173 * xScaling,
      50.5 * yScaling,
      269.5 * xScaling,
      52 * yScaling,
    );
    path.cubicTo(
      346.7 * xScaling,
      53.2 * yScaling,
      398 * xScaling,
      18.1667 * yScaling,
      414 * xScaling,
      0.5 * yScaling,
    );
    path.cubicTo(
      414 * xScaling,
      0.5 * yScaling,
      414 * xScaling,
      0.5 * yScaling,
      414 * xScaling,
      0.5 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
