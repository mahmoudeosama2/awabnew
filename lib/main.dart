import 'dart:io';

import 'package:awab/app/statemanagment/otherProviders.dart';
import 'package:awab/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:workmanager/workmanager.dart';

import 'app/models/daily_goal_model.dart';
import 'app/models/tasbeeh_model.dart';
import 'app/pages/navigationbar.dart';
import 'app/services/notification_service.dart';
import 'app/statemanagment/athanTimeProvider.dart';
import 'app/statemanagment/praiseProvider.dart';
import 'app/statemanagment/quranProvider.dart';
import 'app/statemanagment/radioprovider.dart';
import 'start/splashscreen.dart';

String languagecode = Platform.localeName.split('_')[0];

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(DailyGoalModelAdapter());
  Hive.registerAdapter(ReadingSessionAdapter());
  Hive.registerAdapter(TasbeehSessionAdapter());
  Hive.registerAdapter(TasbeehStatsAdapter());

  tz.initializeTimeZones();

  await NotificationService().initialize();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Praise()),
        ChangeNotifierProvider(create: (context) => Quran()),
        ChangeNotifierProvider(create: (context) => AthanTime()),
        ChangeNotifierProvider(create: (context) => Radioprovider()),
        ChangeNotifierProvider(create: (context) => Other()),
      ],
      child: const StartApp(),
    ),
  );
  // Pass the custom BinaryMessenger instance to MethodChannel()
}

class StartApp extends StatefulWidget {
  const StartApp({super.key});
  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {
  @override
  Widget build(BuildContext context) {
    print("aaaaaaaa");
    var other = Provider.of<Other>(context);
    other.getThemeStatus("thememode");
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return MaterialApp(
          initialRoute: 'splashscreen',
          debugShowCheckedModeBanner: false,
          routes: {
            'splashscreen': ((context) => const splashscreen()),
            'NavigatorBar': ((context) => const NavigatorBar()),

            // 'test': ((context) => const test()),
          },
          theme: customlightTheme,

          darkTheme: customDarkTheme,
          themeMode: other.themeMode == true ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
