
import 'package:flutter/widgets.dart';

class AnimationWidget extends StatelessWidget {
  final Widget widget;
  const AnimationWidget({super.key, required this.widget,});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 1),
        builder: (BuildContext context, double value, Widget? child) {
          return Opacity(
            opacity: value,
            child: Padding(
              padding: EdgeInsets.only(top: value * 30),
              child: child,
            ),
          );
        },
        child: widget,
      ),
    );
  }
}
