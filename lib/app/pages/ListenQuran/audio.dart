import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:awab/app/statemanagment/otherProviders.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

List<AudioSource> audioSourceList = [];
var playList;

class AudioPlayerScreen extends StatefulWidget {
  final index;
  final audioSourceList;
  const AudioPlayerScreen({
    super.key,
    required this.audioSourceList,
    required this.index,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late AudioPlayer _audioPlayer;

  void playListAudioSource() {
    playList = [];
    playList = ConcatenatingAudioSource(
      children: widget.audioSourceList as List<AudioSource>,
    );
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  void initState() {
    playListAudioSource();

    _audioPlayer = AudioPlayer();
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(playList);
    setState(() {
      _audioPlayer.seek(Duration.zero, index: widget.index);
    });
  }

  void disbose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          toolbarHeight: height,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              height: height,
              width: width,
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10, top: 5),
                            child: IconButton(
                              onPressed: () {
                                disbose();
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                          // Container(
                          //     margin: EdgeInsets.symmetric(horizontal: 15),
                          //     child: Text("data")),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder(
                              stream: _audioPlayer.sequenceStateStream,
                              builder: (context, snapshot) {
                                final state = snapshot.data;

                                if (state?.sequence.isEmpty ?? true) {
                                  return const SizedBox();
                                }

                                final metaData =
                                    state!.currentSource!.tag as MediaItem;
                                return MediaMetadata(
                                  surahname: metaData.title,
                                  qariname: metaData.album,
                                );
                              },
                            ),
                            StreamBuilder<PositionData>(
                              stream: _positionDataStream,
                              builder: (context, snapshot) {
                                final PositionData = snapshot.data;
                                return Container(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ProgressBar(
                                    barHeight: 8,
                                    baseBarColor: Colors.grey[600],
                                    bufferedBarColor: Colors.grey,
                                    progressBarColor: Colors.red,
                                    thumbColor: Colors.red,
                                    timeLabelTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    progress:
                                        PositionData?.position ?? Duration.zero,
                                    buffered:
                                        PositionData?.bufferedPosition ??
                                        Duration.zero,
                                    total:
                                        PositionData?.duration ?? Duration.zero,
                                    onSeek: _audioPlayer.seek,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Controls(audioPlayer: _audioPlayer),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onBackPressed() {
    disbose();
    return Future.value(true);
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    var other = Provider.of<Other>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: audioPlayer.seekToNext,
          icon: Icon(
            Icons.skip_next_rounded,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          iconSize: 60,
        ),
        const SizedBox(width: 25),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return ElevatedButton(
                onPressed: audioPlayer.play,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: const CircleBorder(), //<-- SEE HERE
                  padding: const EdgeInsets.all(10),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: other.themeMode == true
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  size: 54,
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return ElevatedButton(
                onPressed: audioPlayer.pause,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: const CircleBorder(), //<-- SEE HERE
                  padding: const EdgeInsets.all(10),
                ),
                child: Icon(
                  Icons.pause_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 54,
                ),
              );
            }
            return ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: const CircleBorder(), //<-- SEE HERE
                padding: const EdgeInsets.all(10),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: Theme.of(context).primaryColor,
                size: 54,
              ),
            );
          },
        ),
        const SizedBox(width: 25),
        IconButton(
          onPressed: audioPlayer.seekToPrevious,
          icon: Icon(
            Icons.skip_previous_rounded,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          iconSize: 60,
        ),
      ],
    );
  }
}

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

String? correctindex(int? index) {
  if (index! < 10) {
    return "00$index";
  } else if (index < 100) {
    return "0$index";
  } else if (index == 100) {
    return (index.toString());
  } else if (index > 100) {
    return (index.toString());
  }
}

class MediaMetadata extends StatelessWidget {
  const MediaMetadata({super.key, this.qariname, this.surahname});
  final qariname;
  final surahname;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: surahname,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(2, 4),
                  blurRadius: 4,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "asset/images/grad_logo.png",
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            surahname,
            style: const TextStyle(
              fontFamily: "Amiri",
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "اسم القارئ : $qariname",
            style: const TextStyle(
              fontFamily: "Amiri",
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
