import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awab/app/statemanagment/quranProvider.dart';

class QusickHelp with ChangeNotifier {
  String? msgError = "";
  List<double> downloadPercentage = [0.0];

  BuildContext? get context => null;
}
