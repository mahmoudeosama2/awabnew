import 'package:flutter/cupertino.dart';

class MyCustomTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 414;
    final double yScaling = size.height / 189.5;
    path.lineTo(0 * xScaling, 189.5 * yScaling);
    path.cubicTo(
      0 * xScaling,
      189.5 * yScaling,
      0 * xScaling,
      0 * yScaling,
      0 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      0 * xScaling,
      0 * yScaling,
      414 * xScaling,
      0 * yScaling,
      414 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      414 * xScaling,
      0 * yScaling,
      414 * xScaling,
      59.5 * yScaling,
      414 * xScaling,
      59.5 * yScaling,
    );
    path.cubicTo(
      414 * xScaling,
      62.6667 * yScaling,
      403 * xScaling,
      77.4 * yScaling,
      359 * xScaling,
      111 * yScaling,
    );
    path.cubicTo(
      304 * xScaling,
      153 * yScaling,
      241 * xScaling,
      139.5 * yScaling,
      144.5 * xScaling,
      138 * yScaling,
    );
    path.cubicTo(
      67.3 * xScaling,
      136.8 * yScaling,
      16 * xScaling,
      171.833 * yScaling,
      0 * xScaling,
      189.5 * yScaling,
    );
    path.cubicTo(
      0 * xScaling,
      189.5 * yScaling,
      0 * xScaling,
      189.5 * yScaling,
      0 * xScaling,
      189.5 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
