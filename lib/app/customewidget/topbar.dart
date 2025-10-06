import 'package:flutter/material.dart';
import 'my_custuom_clip_topbar.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ClipPath(
        clipper: MyCustomTopClipper(),
        child: Container(color: Theme.of(context).primaryColor, height: 300),
      ),
    );
  }
}
