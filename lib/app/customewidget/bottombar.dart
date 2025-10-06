import 'package:flutter/material.dart';

import 'my_custom_clip _bottombar.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ClipPath(
        clipper: MyCustomBottomClipper(),
        child: Container(
          color: Theme.of(context).primaryColor,
          height: 300,
        ),
      ),
    );
  }
}
