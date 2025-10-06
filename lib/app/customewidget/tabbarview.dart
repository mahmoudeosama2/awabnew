import 'package:flutter/material.dart';

class TabBarV extends StatelessWidget {
  const TabBarV({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        child: const TabBarView(
          children: [
            Center(child: Text("data")),
            Center(child: Text("data")),
            Center(child: Text("data"))
          ],
        ),
      ),
    );
  }
}
