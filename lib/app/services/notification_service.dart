import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  List<String> morningAzkar = [];
  List<String> eveningAzkar = [];
  List<String> quranVerses = [];

  Future<void> initialize() async {
    tz.initializeTimeZones();
    await _loadAzkarAndVerses();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
  }

  Future<void> _loadAzkarAndVerses() async {
    try {
      final String response = await rootBundle.loadString('asset/json/azkar.json');
      final data = json.decode(response);
      
      // تحميل أذكار الصباح
      if (data['أذكار الصباح'] != null) {
        final morningData = data['أذكار الصباح'];
        if (morningData is List && morningData.isNotEmpty && morningData[0] is List) {
          for (var item in morningData[0]) {
            if (item is Map && item['content'] != null) {
              String content = item['content'].toString()
                  .replaceAll('\\n', '')
                  .replaceAll('\\"', '"')
                  .trim();
              if (content.isNotEmpty && content != 'stop') {
                morningAzkar.add(content);
              }
            }
          }
        }
      }
      
      // تحميل أذكار المساء
      if (data['أذكار المساء'] != null) {
        final eveningData = data['أذكار المساء'];
        if (eveningData is List) {
          for (var item in eveningData) {
            if (item is Map && item['content'] != null) {
              String content = item['content'].toString()
                  .replaceAll('\\n', '')
                  .replaceAll('\\"', '"')
                  .trim();
              if (content.isNotEmpty) {
                eveningAzkar.add(content);
              }
            }
          }
        }
      }

      // آيات قرآنية للتذكير
      quranVerses = [
        'وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ فَهَلْ مِن مُّدَّكِرٍ',
        'إِنَّ الَّذِينَ يَتْلُونَ كِتَابَ اللَّهِ وَأَقَامُوا الصَّلَاةَ',
        'شَهْرُ رَمَضَانَ الَّذِي أُنزِلَ فِيهِ الْقُرْآنُ',
        'وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا',
        'الَّذِينَ آتَيْنَاهُمُ الْكِتَابَ يَتْلُونَهُ حَقَّ تِلَاوَتِهِ',
        'كِتَابٌ أَنزَلْنَاهُ إِلَيْكَ مُبَارَكٌ لِّيَدَّبَّرُوا آيَاتِهِ',
        'وَنُنَزِّلُ مِنَ الْقُرْآنِ مَا هُوَ شِفَاءٌ وَرَحْمَةٌ لِّلْمُؤْمِنِينَ',
      ];
      
      print('تم تحميل ${morningAzkar.length} من أذكار الصباح');
      print('تم تحميل ${eveningAzkar.length} من أذكار المساء');
    } catch (e) {
      print('خطأ في تحميل البيانات: $e');
    }
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('تم الضغط على الإشعار: ${response.payload}');
  }

  // تذكير القرآن بآية عشوائية
  Future<void> scheduleDailyQuranReminder(int hour, int minute) async {
    final randomVerse = quranVerses[Random().nextInt(quranVerses.length)];
    
    await _notifications.zonedSchedule(
      0,
      'تذكير بقراءة القرآن الكريم 📖',
      randomVerse,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'quran_reminder',
          'تذكير القرآن',
          channelDescription: 'تذكير يومي لقراءة القرآن الكريم',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF14b0f9),
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // تذكير أذكار الصباح بذكر عشوائي
  Future<void> scheduleMorningAzkarReminder(int hour, int minute, int notificationId) async {
    if (morningAzkar.isEmpty) await _loadAzkarAndVerses();
    
    final randomZekr = morningAzkar.isNotEmpty 
        ? morningAzkar[Random().nextInt(morningAzkar.length)]
        : 'ابدأ يومك بذكر الله ☀️';
    
    await _notifications.zonedSchedule(
      notificationId,
      'أذكار الصباح ☀️',
      randomZekr.length > 100 ? randomZekr.substring(0, 100) + '...' : randomZekr,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'azkar_morning',
          'أذكار الصباح',
          channelDescription: 'تذكير بأذكار الصباح',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF276aa9),
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // تذكير أذكار المساء بذكر عشوائي
  Future<void> scheduleEveningAzkarReminder(int hour, int minute, int notificationId) async {
    if (eveningAzkar.isEmpty) await _loadAzkarAndVerses();
    
    final randomZekr = eveningAzkar.isNotEmpty 
        ? eveningAzkar[Random().nextInt(eveningAzkar.length)]
        : 'اختم يومك بذكر الله 🌙';
    
    await _notifications.zonedSchedule(
      notificationId,
      'أذكار المساء 🌙',
      randomZekr.length > 100 ? randomZekr.substring(0, 100) + '...' : randomZekr,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'azkar_evening',
          'أذكار المساء',
          channelDescription: 'تذكير بأذكار المساء',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF0b5367),
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // إشعار الأذان مع تشغيل الصوت من الملف المحفوظ
  Future<void> showAdhanNotification(String prayerName) async {
    await _notifications.show(
      3,
      'حان وقت صلاة $prayerName 🕌',
      'الله أكبر - حي على الصلاة',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'adhan_channel',
          'الأذان',
          channelDescription: 'إشعارات الأذان',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          playSound: false, // سنشغل الصوت يدوياً من الملف
          enableVibration: true,
          color: Color(0xFF2c99f2),
          fullScreenIntent: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
    
    // تشغيل صوت الأذان من الملف المحفوظ
    await playAdhan();
  }

  // تشغيل صوت الأذان من assets
  Future<void> playAdhan() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.play(AssetSource('sounds/athan.mp3'));
      print('تم تشغيل الأذان');
    } catch (e) {
      print('خطأ في تشغيل الأذان: $e');
    }
  }

  // إيقاف الأذان
  Future<void> stopAdhan() async {
    try {
      await _audioPlayer.stop();
      print('تم إيقاف الأذان');
    } catch (e) {
      print('خطأ في إيقاف الأذان: $e');
    }
  }

  // التحقق من حالة تشغيل الأذان
  bool isAdhanPlaying() {
    return _audioPlayer.state == PlayerState.playing;
  }

  // إشعار الإنجازات
  Future<void> showStreakNotification(int streakDays) async {
    await _notifications.show(
      4,
      'مبروك! 🎉',
      'لقد حافظت على قراءة القرآن لمدة $streakDays يوم متتالي!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_channel',
          'الإنجازات',
          channelDescription: 'إشعارات الإنجازات',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF4083e9),
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  // إشعار تذكير عام
  Future<void> showGeneralReminder(String title, String body) async {
    await _notifications.show(
      Random().nextInt(1000) + 5,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'general_reminders',
          'تذكيرات عامة',
          channelDescription: 'تذكيرات عامة',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF14b0f9),
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  // الحصول على قائمة الإشعارات المجدولة
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // dispose للـ audio player
  void dispose() {
    _audioPlayer.dispose();
  }
} 