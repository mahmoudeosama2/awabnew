import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:awab/app/pages/athan/prayertime.dart';
import 'package:awab/app/statemanagment/athanTimeProvider.dart';
import 'package:awab/app/statemanagment/otherProviders.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../../statemanagment/Provider.dart';

Prayertime prayertime = Prayertime();
LocationPermission? permission;
bool IsSmallSize = false;
bool? IsRationgNow;
double? customBodyHeight;
List<String> salawat = [
  "صلاة الفجر",
  "صلاة الشروق",
  "صلاة الظهر",
  "صلاة العصر",
  "صلاة المغرب",
  "صلاة العشاء",
];
String? city;

// حالات الصوت
enum AthanSoundMode {
  silent, // صامت
  vibrate, // اهتزاز
  sound, // صوت
}

class Athan extends StatefulWidget {
  final firsttime;
  const Athan({super.key, this.firsttime});

  @override
  State<Athan> createState() => _AthanState();
}

class _AthanState extends State<Athan> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();
  Stream<LocationStatus> get stream => _locationStreamController.stream;

  // Controller للبحث عن المواقع
  final TextEditingController _searchController = TextEditingController();
  List<Location> _searchResults = [];
  bool _isSearching = false;
  Location? _selectedLocation;

  // للأذان
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AthanSoundMode _currentSoundMode = AthanSoundMode.sound;
  bool _isAthanEnabled = true;

  // لكل صلاة حالة صوت خاصة (اختياري)
  final Map<int, AthanSoundMode> _prayerSoundModes = {
    0: AthanSoundMode.sound, // الفجر
    1: AthanSoundMode.sound, // الشروق
    2: AthanSoundMode.sound, // الظهر
    3: AthanSoundMode.sound, // العصر
    4: AthanSoundMode.sound, // المغرب
    5: AthanSoundMode.sound, // العشاء
  };

  @override
  void initState() {
    super.initState();
    _initializeAthan();

    Future.delayed(const Duration(seconds: 1), () async {
      var model = Provider.of<Other>(context, listen: false);
      var athanProv = Provider.of<AthanTime>(context, listen: false);
      print("${model.firstuse}***************************first  use athan");

      if (model.firstuse == true) {
        await model.requestPermissionFirstUse();
        await AppSettings.openAppSettings(type: AppSettingsType.notification);
        await AppSettings.openAppSettings(type: AppSettingsType.location);
        model.firstuse = false;
      }

      if (await Permission.location.isGranted == true &&
          await Geolocator.isLocationServiceEnabled() == true) {
        await _getCurrentLocationWithReverseGeocoding(athanProv);
      }
    });
  }

  // تهيئة إعدادات الأذان
  Future<void> _initializeAthan() async {
    // تهيئة الإشعارات
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );
    await _notificationsPlugin.initialize(initSettings);

    // طلب صلاحية الإشعارات
    await Permission.notification.request();

    // تحميل الإعدادات المحفوظة
    await _loadSoundSettings();

    // بدء مراقبة أوقات الصلاة
    _startPrayerTimeMonitoring();
  }

  // تحميل إعدادات الصوت المحفوظة
  Future<void> _loadSoundSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAthanEnabled = prefs.getBool('athan_enabled') ?? true;
      int soundModeIndex =
          prefs.getInt('sound_mode') ?? AthanSoundMode.sound.index;
      _currentSoundMode = AthanSoundMode.values[soundModeIndex];

      // تحميل إعدادات كل صلاة
      for (int i = 0; i < 6; i++) {
        int? mode = prefs.getInt('prayer_sound_$i');
        if (mode != null) {
          _prayerSoundModes[i] = AthanSoundMode.values[mode];
        }
      }
    });
  }

  // حفظ إعدادات الصوت
  Future<void> _saveSoundSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('athan_enabled', _isAthanEnabled);
    await prefs.setInt('sound_mode', _currentSoundMode.index);

    // حفظ إعدادات كل صلاة
    for (var entry in _prayerSoundModes.entries) {
      await prefs.setInt('prayer_sound_${entry.key}', entry.value.index);
    }
  }

  // تبديل حالة الصوت
  void _toggleSoundMode() {
    setState(() {
      switch (_currentSoundMode) {
        case AthanSoundMode.sound:
          _currentSoundMode = AthanSoundMode.vibrate;
          break;
        case AthanSoundMode.vibrate:
          _currentSoundMode = AthanSoundMode.silent;
          break;
        case AthanSoundMode.silent:
          _currentSoundMode = AthanSoundMode.sound;
          break;
      }
    });
    _saveSoundSettings();

    String message = _currentSoundMode == AthanSoundMode.sound
        ? "تم تفعيل الصوت"
        : _currentSoundMode == AthanSoundMode.vibrate
        ? "تم تفعيل الاهتزاز"
        : "تم تفعيل الوضع الصامت";

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  // تبديل حالة صوت صلاة معينة
  void _togglePrayerSoundMode(int prayerIndex) {
    setState(() {
      AthanSoundMode currentMode = _prayerSoundModes[prayerIndex]!;
      switch (currentMode) {
        case AthanSoundMode.sound:
          _prayerSoundModes[prayerIndex] = AthanSoundMode.vibrate;
          break;
        case AthanSoundMode.vibrate:
          _prayerSoundModes[prayerIndex] = AthanSoundMode.silent;
          break;
        case AthanSoundMode.silent:
          _prayerSoundModes[prayerIndex] = AthanSoundMode.sound;
          break;
      }
    });
    _saveSoundSettings();
  }

  // أيقونة حسب حالة الصوت
  IconData _getSoundIcon(AthanSoundMode mode) {
    switch (mode) {
      case AthanSoundMode.sound:
        return Icons.volume_up;
      case AthanSoundMode.vibrate:
        return Icons.vibration;
      case AthanSoundMode.silent:
        return Icons.volume_off;
    }
  }

  // لون الأيقونة
  Color _getSoundIconColor(AthanSoundMode mode, BuildContext context) {
    switch (mode) {
      case AthanSoundMode.sound:
        return Colors.green;
      case AthanSoundMode.vibrate:
        return Colors.orange;
      case AthanSoundMode.silent:
        return Colors.red;
    }
  }

  // مراقبة أوقات الصلاة
  void _startPrayerTimeMonitoring() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkPrayerTime();
    });
  }

  // فحص وقت الصلاة
  Future<void> _checkPrayerTime() async {
    if (!_isAthanEnabled) return;

    var athanProv = Provider.of<AthanTime>(context, listen: false);
    if (athanProv.prayerstime == null) return;

    DateTime now = DateTime.now();
    String currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    for (int i = 0; i < athanProv.prayerstime!.length; i++) {
      if (athanProv.prayerstime![i] == currentTime) {
        await _playAthan(i);
        break;
      }
    }
  }

  // تشغيل الأذان
  Future<void> _playAthan(int prayerIndex) async {
    AthanSoundMode mode = _prayerSoundModes[prayerIndex] ?? _currentSoundMode;

    // عرض إشعار
    await _showAthanNotification(prayerIndex);

    switch (mode) {
      case AthanSoundMode.sound:
        await _playAthanSound();
        break;
      case AthanSoundMode.vibrate:
        await _vibratePhone();
        break;
      case AthanSoundMode.silent:
        // إشعار فقط بدون صوت أو اهتزاز
        break;
    }
  }

  // تشغيل صوت الأذان
  Future<void> _playAthanSound() async {
    try {
      // ضع ملف الأذان في assets/sounds/athan.mp3
      await _audioPlayer.setAsset('assets/sounds/athan.mp3');
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play();
    } catch (e) {
      print("Error playing athan: $e");
    }
  }

  // اهتزاز الهاتف
  Future<void> _vibratePhone() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      // نمط اهتزاز: 500ms تشغيل، 200ms توقف، مكرر 3 مرات
      Vibration.vibrate(
        pattern: [0, 500, 200, 500, 200, 500],
        intensities: [0, 255, 0, 255, 0, 255],
      );
    }
  }

  // عرض إشعار الأذان
  Future<void> _showAthanNotification(int prayerIndex) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'athan_channel',
          'أذان الصلاة',
          channelDescription: 'إشعارات أوقات الصلاة',
          importance: Importance.high,
          priority: Priority.high,
          playSound: false, // نتحكم في الصوت يدوياً
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      prayerIndex,
      'حان الآن موعد ${salawat[prayerIndex]}',
      'الله أكبر الله أكبر',
      notificationDetails,
    );
  }

  // دالة للحصول على الموقع الحالي مع Reverse Geocoding
  Future<void> _getCurrentLocationWithReverseGeocoding(
    AthanTime athanProv,
  ) async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // استخدام Reverse Geocoding من الحزمة - التصحيح هنا
      Location? location = MuslimDataFlutter.reverseGeocoding(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _selectedLocation = location;
        city = location.name; // استخدام name بدلاً من cityAr/cityEn
      });

      // الحصول على أوقات الصلاة باستخدام الإحداثيات
      await _getPrayerTimesByCoordinates(
        athanProv,
        position.latitude,
        position.longitude,
      );

      Fluttertoast.showToast(
        msg: "تم تحديد موقعك: ${location.name}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print("Error in reverse geocoding: $e");
      await _getDefaultPrayerTimes(athanProv);
    }
  }

  // الحصول على أوقات الصلاة باستخدام الإحداثيات
  Future<void> _getPrayerTimesByCoordinates(
    AthanTime athanProv,
    double lat,
    double lng,
  ) async {
    try {
      // استخدام MuslimDataFlutter للحصول على أوقات الصلاة - التصحيح هنا
      PrayerTimes prayerTimes = MuslimDataFlutter.prayerTimes(
        lat: lat,
        lng: lng,
        date: DateTime.now(),
        calculationMethod: CalculationMethod.egypt, // يمكن تغيير طريقة الحساب
      );

      // تحويل أوقات الصلاة إلى قائمة
      List<String> times = [
        _formatTime(prayerTimes.fajr!),
        _formatTime(prayerTimes.sunrise!),
        _formatTime(prayerTimes.dhuhr!),
        _formatTime(prayerTimes.asr!),
        _formatTime(prayerTimes.maghrib!),
        _formatTime(prayerTimes.isha!),
      ];

      // تحديث الـ Provider
      athanProv.updatePrayerTimes(times);
    } catch (e) {
      print("Error getting prayer times: $e");
      await _getDefaultPrayerTimes(athanProv);
    }
  }

  // تنسيق الوقت
  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  // الحصول على أوقات الصلاة الافتراضية
  Future<void> _getDefaultPrayerTimes(AthanTime athanProv) async {
    try {
      // استخدام موقع افتراضي (مكة المكرمة)
      await _getPrayerTimesByCoordinates(athanProv, 21.4225, 39.8262);
    } catch (e) {
      print("Error getting default prayer times: $e");
    }
  }

  // دالة البحث عن المواقع
  void _searchLocation(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      // استخدام وظيفة البحث من الحزمة - التصحيح هنا
      _searchResults = MuslimDataFlutter.searchLocation(query);
    });
  }

  // دالة اختيار موقع من نتائج البحث
  void _selectLocation(Location location, AthanTime model) {
    setState(() {
      _selectedLocation = location;
      city = location.name; // استخدام name بدلاً من cityAr/cityEn
      _searchResults = [];
      _isSearching = false;
      _searchController.clear();
    });

    // الحصول على أوقات الصلاة للموقع المختار
    _getPrayerTimesByCoordinates(model, location.latitude, location.longitude);

    Fluttertoast.showToast(
      msg: "تم اختيار: ${location.name}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("object");
    var model = Provider.of<AthanTime>(context);
    var other = Provider.of<Other>(context);
    double customBodyHeight = MediaQuery.of(context).size.height - 150;
    MediaQuery.sizeOf(context).width < 300.0 ||
            MediaQuery.sizeOf(context).height < 600.0
        ? IsSmallSize = true
        : IsSmallSize = false;
    other.countopen == 1 ? IsRationgNow = true : IsRationgNow = false;

    if (other.countopen == other.maxOpenToRate &&
        other.isshowingrate == false) {
      other.dontRateAgring();
      Future.delayed(const Duration(seconds: 3), () {
        showAwesomeDialog(context, inappreview, other.ifCancelRate);
      });
    }

    floatingFunction() async {
      if (await model.handlePermission(false) == false) {
        if (model.msgError == "يرجي تفعل زر الوصول للموقع") {
          AwesomeDialog(
            context: context,
            btnOkColor: Theme.of(context).primaryColor,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            descTextStyle: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontFamily: ""),
            desc: 'هل تريد تشغيل خدمة تحديد المواقع؟',
            btnCancelOnPress: () {
              Fluttertoast.showToast(
                msg: "${model.msgError}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.grey[800],
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            btnOkOnPress: () {
              model.openloctionset();
            },
          ).show();
        } else {
          Fluttertoast.showToast(
            msg: "${model.msgError}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[800],
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        await _getCurrentLocationWithReverseGeocoding(model);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // زر التحكم في الصوت العام
            FloatingActionButton(
              heroTag: "sound",
              onPressed: _toggleSoundMode,
              backgroundColor: _getSoundIconColor(_currentSoundMode, context),
              child: Icon(
                _getSoundIcon(_currentSoundMode),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            // زر تحديد الموقع
            FloatingActionButton(
              heroTag: "location",
              onPressed: floatingFunction,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.gps_fixed, color: Colors.white),
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 70,
        child: Container(
          margin: const EdgeInsets.only(
            top: 100,
            left: 10,
            right: 10,
            bottom: 10,
          ),
          padding: const EdgeInsets.only(bottom: 40),
          height: customBodyHeight,
          child: Column(
            children: [
              // شريط البحث
              if (_isSearching || _searchResults.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: _searchLocation,
                        style: TextStyle(color: Colors.grey[200]),
                        decoration: InputDecoration(
                          hintText: "ابحث عن مدينة...",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close, color: Colors.grey[400]),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchResults = [];
                                _isSearching = false;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(15),
                        ),
                      ),
                      if (_searchResults.isNotEmpty)
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              Location loc = _searchResults[index];
                              return ListTile(
                                dense: true,
                                title: Text(
                                  loc.name,
                                  style: TextStyle(color: Colors.grey[200]),
                                ),
                                subtitle: Text(
                                  loc.countryName,
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                ),
                                onTap: () => _selectLocation(loc, model),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),

              Flexible(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Opacity(
                    opacity: 1,
                    child: other.themeMode == true
                        ? Image.asset(
                            "asset/images/prayertimeMosque.png",
                            color: Theme.of(context).primaryColor,
                            fit: BoxFit.fill,
                            width: double.infinity,
                          )
                        : Image.asset(
                            "asset/images/prayertimeMosque.png",
                            fit: BoxFit.fill,
                            width: double.infinity,
                          ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      colors: other.themeMode == true
                          ? [
                              Theme.of(context).primaryColor,
                              Color.fromARGB(209, 35, 38, 39),
                              Theme.of(context).scaffoldBackgroundColor,
                            ]
                          : [
                              Color(0xff095263),
                              Color.fromARGB(209, 9, 82, 99),
                              Color.fromARGB(255, 194, 194, 194),
                            ],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                  child: model.prayerstime == null
                      ? const Center(child: CircularProgressIndicator())
                      : Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          child: Column(
                            children: [
                              // صف يحتوي على اسم المدينة وزر البحث
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        city ?? "الموقع الحالي",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[200],
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.grey[200],
                                        size: 28,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isSearching = !_isSearching;
                                          if (!_isSearching) {
                                            _searchResults = [];
                                            _searchController.clear();
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.builder(
                                    itemCount: salawat.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        dense: true,
                                        leading: IconButton(
                                          icon: Icon(
                                            _getSoundIcon(
                                              _prayerSoundModes[index]!,
                                            ),
                                            color: _getSoundIconColor(
                                              _prayerSoundModes[index]!,
                                              context,
                                            ),
                                          ),
                                          onPressed: () =>
                                              _togglePrayerSoundMode(index),
                                        ),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              model.prayerstime![index],
                                              style: TextStyle(
                                                color: Colors.grey[200],
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Amiri",
                                              ),
                                            ),
                                            Text(
                                              salawat[index],
                                              style: TextStyle(
                                                color: Colors.grey[200],
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Amiri",
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAwesomeDialog(BuildContext context, var btnOk, var btnCancel) {
    AwesomeDialog(
      btnOkColor: Theme.of(context).primaryColor,
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: '! هل يمكنك تقييم تطبيقنا سوف يدعمنا ذلك',
      desc: '♥ نسعي لتطوير أفضل',
      titleTextStyle: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontFamily: ""),
      descTextStyle: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontFamily: ""),
      btnCancelOnPress: btnCancel,
      btnOkOnPress: btnOk,
    ).show();
  }

  Future<void> inappreview() async {
    //LaunchReview.launch(androidAppId: "com.onatcipli.awab");
  }
}
