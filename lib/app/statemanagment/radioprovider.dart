import 'package:awab/app/services/control_audio.dart';
import 'package:flutter/material.dart';

class Radioprovider with ChangeNotifier {
  bool? radio_play_pause_icon;
  String twoDigits(int n) => n.toString().padLeft(n);
  // final TwoDigitsMinuite = twoDigits(Duration());

  void play_pause_choose() {
    radio_play_pause_icon = getprefs("play_pause_choose") as bool?;
  }
}
