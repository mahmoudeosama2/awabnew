import 'dart:convert';

import 'package:adhan/adhan.dart';
import 'package:flutter/services.dart%20';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model_governorate.dart';

class AthanTime with ChangeNotifier {
  List<String>? prayerstime = [
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00",
    "00:00",
  ];

  String? msgError = "";
  List<Governorate> governorate = [];
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  String? city;
  List<double>? coordinates = [];

  Future<bool> handlePermission(bool check) async {
    LocationPermission permission;
    // Test if location services are enabled.
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      if (check == false) {
        permission = await _geolocatorPlatform.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        msgError = "تم رفض صلاحيه الوصول للموقع";
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      msgError = "تم عمل رفض دائم لصلاحيه الوصول للمواقع";
      return false;
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    if (!await Geolocator.isLocationServiceEnabled()) {
      msgError = "يرجي تفعل زر الوصول للموقع";
      return false;
    }
    return true;
  }

  openloctionset() {
    Geolocator.openLocationSettings();
  }

  Future<List<Governorate>> ReadJsonGovernorateEgy() async {
    final jsondata =
        await rootBundle.loadString("asset/json/egypt_governorate.json");
    List<dynamic> json = jsonDecode(jsondata);
    for (var element in json) {
      if (governorate.length < json.length) {
        governorate.add(Governorate.fromJson(element));
      }
    }
    return governorate;
  }

  Future<void> getMylocationTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    msgError = "يرجي تفعل زر الوصول للموقع";

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final myCoordinates = Coordinates(position.latitude, position.longitude);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    final pT = PrayerTimes.today(myCoordinates, params);

    prayerstime = [
      DateFormat.jm().format(pT.fajr),
      DateFormat.jm().format(pT.sunrise),
      DateFormat.jm().format(pT.dhuhr),
      DateFormat.jm().format(pT.asr),
      DateFormat.jm().format(pT.maghrib),
      DateFormat.jm().format(pT.isha)
    ];
    prefs.setStringList("prayertime", prayerstime!);
    prefs.remove("city");
    print(prayerstime);
    notifyListeners();
  }

  Future<void> getTimesByLatAndlong(double lat, double long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final myCoordinates = Coordinates(lat, long);
    final params = CalculationMethod.egyptian.getParameters();
    params.madhab = Madhab.shafi;
    final pT = PrayerTimes.today(myCoordinates, params);
    prayerstime = [
      DateFormat.jm().format(pT.fajr),
      DateFormat.jm().format(pT.sunrise),
      DateFormat.jm().format(pT.dhuhr),
      DateFormat.jm().format(pT.asr),
      DateFormat.jm().format(pT.maghrib),
      DateFormat.jm().format(pT.isha)
    ];
    prefs.setStringList("prayertime", prayerstime!);
    prefs.setString("city", city!);
    print(prayerstime);
    notifyListeners();
  }

  lastprayertimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("prayertime")) {
      prayerstime = prefs.getStringList("prayertime");
      city = prefs.getString("city");
    }
    if (prefs.containsKey("city")) {
      city = prefs.getString("city");
    }
  }

  getlatlongbycity(String name) {
    for (var element in governorate) {
      if (element.governorateNameAr == name) {
        coordinates = [];
        coordinates?.add(element.lat!);
        coordinates?.add(element.long!);
      }
    }
  }


}
