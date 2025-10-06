import 'package:flutter/material.dart';

class CustomeGradientDecoration extends StatelessWidget {
  final child;
  final hsize;
  final wsize;
  final List<Color> listOfColors;

  const CustomeGradientDecoration(
      {super.key,
      this.hsize,
      this.wsize,
      this.child,
      required this.listOfColors});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hsize,
      width: wsize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: listOfColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: child,
    );
  }
}
