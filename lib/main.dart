import 'dart:io';

import 'package:awab/app/statemanagment/otherProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import 'app/pages/navigationbar.dart';
import 'app/statemanagment/athanTimeProvider.dart';
import 'app/statemanagment/praiseProvider.dart';
import 'app/statemanagment/quranProvider.dart';
import 'app/statemanagment/radioprovider.dart';
import 'start/splashscreen.dart';

String languagecode = Platform.localeName.split('_')[0];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          theme: ThemeData.light().copyWith(
            brightness: Brightness.light,
            appBarTheme: AppBarTheme(backgroundColor: Color(0xff095263)),

            primaryColor: Color(0xff095263),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Color(0xff095263),
                ),
              ),
            ),

            // ignore: prefer_const_constructors
            textTheme: TextTheme(
              displayLarge: TextStyle(
                backgroundColor: Color(0xff095263),
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              displayMedium: TextStyle(
                //  fontFamily: "Cairo",
                fontSize: 30,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              displaySmall: TextStyle(
                height: 1.8,
                color: Colors.black87,
                fontSize: 20,
                // fontWeight: FontWeight.w500,
                fontFamily: "Med",
              ),
              headlineLarge: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                fontFamily: "Amiri",
                //   fontFamily: "Cairo",
              ),
              headlineMedium: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              titleLarge: TextStyle(
                color: Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: "Amiri",
              ),
              titleMedium: TextStyle(
                fontFamily: "Amiri",
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
              titleSmall: TextStyle(
                fontFamily: "Amiri",
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
              labelSmall: TextStyle(
                height: 1.8,
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: "Amiri",
              ),
              bodyMedium: TextStyle(
                //  fontFamily: "Cairo",
                fontSize: 30,
                color: Color(0xff095263),
                fontWeight: FontWeight.w600,
              ),
            ),

            //    colorScheme: ColorScheme(surface: Colors.white),
          ),
          darkTheme: ThemeData.dark().copyWith(
            brightness: Brightness.dark,
            appBarTheme: AppBarTheme(backgroundColor: Color(0xff18191A)),
            primaryColor: Color(0xff18191A),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Color(0xff095263),
                ),
              ),
            ),
            textTheme: TextTheme(
              displayLarge: TextStyle(
                backgroundColor: Color(0xff18191A),
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              displayMedium: TextStyle(
                //  fontFamily: "Cairo",
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              displaySmall: TextStyle(
                height: 1.8,
                fontSize: 20,
                // fontWeight: FontWeight.w500,
                color: Colors.white70,
                fontFamily: "Med",
              ),
              headlineLarge: TextStyle(
                color: Color(0xffB0BEC5),
                fontSize: 28,
                fontWeight: FontWeight.w500,
                fontFamily: "Amiri",
                //   fontFamily: "Cairo",
              ),
              headlineMedium: TextStyle(
                color: Color(0xffB0BEC5),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                //   fontFamily: "Cairo",
              ),
              titleLarge: TextStyle(
                fontFamily: "Amiri",
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              titleMedium: TextStyle(
                fontFamily: "Amiri",
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              titleSmall: TextStyle(
                fontFamily: "Amiri",
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              labelSmall: TextStyle(
                height: 1.8,
                color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: "Amiri",
              ),
              bodyMedium: TextStyle(
                //  fontFamily: "Cairo",
                fontSize: 30,
                color: Color.fromARGB(255, 170, 169, 169),
                fontWeight: FontWeight.w600,
              ),
            ),
            //  colorScheme: ColorScheme(surface: Color(0xff303030)),
          ),
          themeMode: other.themeMode == true ? ThemeMode.dark : ThemeMode.light,
        );
      },
    );
  }
}
