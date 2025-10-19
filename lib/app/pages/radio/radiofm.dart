import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awab/app/services/control_audio.dart';
import 'package:siri_wave/siri_wave.dart';
import '../../statemanagment/otherProviders.dart';

class RadioFm extends StatefulWidget {
  const RadioFm({super.key});

  @override
  State<RadioFm> createState() => _ViewSurahtate();
}

class _ViewSurahtate extends State<RadioFm> with TickerProviderStateMixin {
  late AnimationController _controller;

  final waveController = IOS7SiriWaveformController();
  bool? _isplay;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    // other.radio_play_pause_icon != null
    //     ? _isplay = other.radio_play_pause_icon!
    //     : print("");

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> onBackPressed() {
    dispose();
    return Future.value(true);
  }

  void change_icon() {
    if (_isplay == false) {
      _controller.forward();
      getaudio("https://stream.radiojar.com/8s5u5tpdtwzuv");

      waveController.amplitude = 0.9;
      waveController.color = Theme.of(context).primaryColor;
      waveController.frequency = 20;
      waveController.speed = 0.2;
      isplayedfm = true;
      _isplay = true;
    } else {
      _controller.reverse();
      pauseaudio();
      waveController.amplitude = 0;
      waveController.color = Colors.transparent;
      waveController.frequency = 0;
      waveController.speed = 0.0;
      isplayedfm = false;
      _isplay = false;
    }
    setprefsbool("play_pause_choose", _isplay!);
  }

  final graidentcolor = List<Color>.from([
    Color(0xffff9e80),
    Color(0xffffe082),
  ]);
  @override
  Widget build(BuildContext context) {
    var other = Provider.of<Other>(context);
    _isplay = isplayedfm;
    if (_isplay == true) {
      _controller.forward();
      waveController.amplitude = 0.9;
      waveController.color = Theme.of(context).primaryColor;
      waveController.frequency = 20;
      waveController.speed = 0.2;
    }
    print("object");
    //  _isplay = other.isFmplay;
    // _isplay = other.isFmOn;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            padding: const EdgeInsets.only(top: 100, bottom: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 25),
                  child: Text(
                    "إذاعة القرءان الكريم",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 33),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Transform.rotate(
                    angle:
                        -pi /
                        2, // تدوير الـ Container بزاوية 90 درجة عكس عقارب الساعة
                    child: SiriWaveform.ios7(
                      controller: waveController,
                      options: IOS7SiriWaveformOptions(height: 120, width: 150),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ShaderMask(
                    shaderCallback: (rect) => LinearGradient(
                      colors: graidentcolor,
                      begin: Alignment.center,
                    ).createShader(rect),
                    child: other.themeMode == true
                        ? Image.asset(
                            "asset/images/radio-tower_9421452.png",
                            color: other.themeMode == true
                                ? Color.fromARGB(255, 10, 10, 10)
                                : Theme.of(context).primaryColor,
                          )
                        : Image.asset("asset/images/radio-tower_9421452.png"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    other.isFmplay = true;
                    print(other.isFmplay);
                    change_icon();
                  },
                  child: AnimatedIcon(
                    progress: _controller,
                    size: 80,
                    icon: AnimatedIcons.play_pause,
                    color: other.themeMode == true
                        ? Colors.black
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
