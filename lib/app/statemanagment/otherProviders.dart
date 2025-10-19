import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Other with ChangeNotifier {
  int? countopen;
  bool themeMode = false;
  bool? isshowingrate;
  int? maxOpenToRate;
  bool isFmplay = true;
  bool isSwitchedNotificatio = true;
  bool? firstuse;
  bool? isplay = false;
  bool? justone = false;
  double surahMark = 0.0;
  void changeTheme() {
    if (themeMode == false) {
      themeMode = true;
    } else {
      themeMode = false;
    }
    notifyListeners();
  }

  Future<void> requestPermissionFirstUse() async {
    // print(firstuse);
    // if (firstuse == true) {

    Map<Permission, PermissionStatus> statuses = await [
      //  Permission.storage,
      Permission.notification,
      Permission.location,
    ].request();
  }

  //  }

  Future<void> FirstUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("firstuse") == false) {
      firstuse = true;
      prefs.setBool("firstuse", true);
    } else {
      firstuse = false;
    }
  }

  Future<void> RateFirstUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("rateapp")) {
      countopen = prefs.getInt("rateapp");
      prefs.setInt("rateapp", countopen! + 1);
    } else {
      prefs.setInt("rateapp", 1);
    }
  }

  Future<void> dontRateAgring() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("dontRateAgring", true);
    isshowingrate = true;
  }

  Future<bool> ifcontainsKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> ifCancelRate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isSetCancelRate", true);
  }

  Future<void> maxopenToRate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isSetCancelRate")) {
      maxOpenToRate = 10;
    } else {
      maxOpenToRate = 3;
    }
  }

  Future<bool> getBooslSwtch(String key, bool temp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(key.toString()) == true) {
      temp = true;
      print("$temp  --in is switch//////////////////");

      return true;
    } else if (prefs.getBool(key.toString()) == false) {
      temp = false;
      print("$temp  --in is switch//////////////////");

      return false;
    }
    return false;
  }

  Future<bool> getNotificationStatus(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(key.toString()) == true) {
      isSwitchedNotificatio = true;
      print("$isSwitchedNotificatio  --in is switch//////////////////");

      return true;
    } else if (prefs.getBool(key.toString()) == false) {
      isSwitchedNotificatio = false;
      print("$isSwitchedNotificatio  --in is switch//////////////////");

      return false;
    }
    return false;
  }

  Future getThemeStatus(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      themeMode = prefs.getBool(key.toString())!;
      // ignore: unnecessary_null_comparison
      if (themeMode == null) {
        return false;
      }
    } catch (e) {}
    if (justone == false) {
      notifyListeners();
      justone = true;
    }
  }

  void stest(bool temp) {
    temp != temp;
    notifyListeners();
  }

  Future<void> test() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("notificationSwitch", true);
    print("${prefs.getBool("notificationSwitch")} 55555555555555555555");
  }

  // getBoolThemeSwtch() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.getBool("thememode") == true) {
  //     isSwitchedNotificatio = true;
  //     return true;
  //   } else if (prefs.getBool("thememode") == false) {
  //     isSwitchedNotificatio = false;
  //     return false;
  //   }
  // }
  Future<void> clearAllPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  Future<void> getallprefs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final prefsMap = <String, dynamic>{};
    for (String key in keys) {
      prefsMap[key] = prefs.get(key);
      print(key);
    }

    //  print(prefsMap);
  }

  Future<void> getSurahMark(key) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      surahMark = prefs.getDouble(key)!;
    }
  }

  Future<void> addSurahMark(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, surahMark);
  }
}
