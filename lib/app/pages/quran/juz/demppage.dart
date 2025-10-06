import 'package:flutter/material.dart';

import '../../../models/model_complete_quran.dart';

List<Ayahs> ayahs = [];

class DemoPage extends StatefulWidget {
  final surah;
  const DemoPage({super.key, this.surah});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    // ayahs = widget.surah.ayahs;

    return Container(
      child: const Text("s", style: TextStyle(fontFamily: "Amiri")),
    );
  }
}
