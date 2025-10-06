// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:provider/provider.dart';
// import '../../models/model_complete_quran.dart';
// import '../../services/control_audio.dart';
// import '../../statemanagment/quranProvider.dart';

// List<Ayahs> ayahs = [];
// bool videoPlaying = false;
// String? url;
// String? qari;

// class ViewAudio extends StatefulWidget {
//   final url;

//   const ViewAudio({super.key, this.url});

//   @override
//   State<ViewAudio> createState() => _ViewSurahtate();
// }

// class _ViewSurahtate extends State<ViewAudio>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late AudioPlayer _audioPlayer;
//   @override
//   void initState() {
//     _animationController =
//         AnimationController(vsync: this, duration: const Duration(seconds: 1));

//     super.initState();
//   }

//   // correctindex(int index) {
//   //   if (index < 10) {
//   //     return "00$index";
//   //   } else if (index < 100) {
//   //     return "0$index";
//   //   } else if (index == 100) {
//   //    return "100";
//   //   } else if (index > 100) {
//   //     return (index.toString());
//   //   }
//   // }

//   _disbose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var model = Provider.of<Quran>(context);
//     double width = MediaQuery.of(context).size.width;
//     return Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               automaticallyImplyLeading: false,
//               actions: [
//                 Directionality(
//                   textDirection: TextDirection.rtl,
//                   child: SizedBox(
//                     width: width,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         IconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: const Icon(Icons.arrow_back))
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//               toolbarHeight: 50,
//               backgroundColor: Theme.of(context).primaryColor,
//               elevation: 0,
//             ),
//             body: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: const BoxDecoration(
//                           color: Theme.of(context).primaryColor,
//                           borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(100),
//                               bottomRight: Radius.circular(100))),
//                       child: Container(
//                           margin: const EdgeInsets.all(30),
//                           decoration: const BoxDecoration(),
//                           child: Image.asset(
//                             "asset/images/grad_logo.png",
//                             width: 250,
//                             height: 250,
//                           )),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: Container(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Container(
//                                 height: 50,
//                                 width: 50,
//                                 margin: const EdgeInsets.only(),
//                                 child: IconButton(
//                                     padding: const EdgeInsets.all(0),
//                                     alignment: Alignment.center,
//                                     onPressed: () {},
//                                     icon: Icon(
//                                       Icons.skip_next,
//                                       size: 50.0,
//                                       color: Theme.of(context).primaryColor,
//                                     )),
//                               ),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(15)),
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                                 margin: const EdgeInsets.only(),
//                                 child: GestureDetector(
//                                   onTap: () async {
//                                     model.quranreader;

//                                     _disbose();
//                                     _iconTapped();
//                                     url = widget.url;
//                                     videoPlaying == true
//                                         ? getaudio(url)
//                                         : pauseaudio();
//                                   },
//                                   child: AnimatedIcon(
//                                     color: Colors.white,
//                                     icon: AnimatedIcons.play_pause,
//                                     progress: _animationController,
//                                     size: 70,
//                                     semanticLabel: 'Show menu',
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 margin: const EdgeInsets.only(),
//                                 child: IconButton(
//                                     padding: const EdgeInsets.all(0),
//                                     onPressed: () {
//                                       pauseaudio();
//                                     },
//                                     icon: Icon(
//                                       Icons.skip_previous,
//                                       size: 50,
//                                       color: Theme.of(context).primaryColor,
//                                     )),
//                               ),
//                               Container(
//                                 margin: const EdgeInsets.only(),
//                                 child: IconButton(
//                                     padding: const EdgeInsets.all(0),
//                                     onPressed: () {
//                                       pauseaudio();
//                                     },
//                                     icon: Icon(
//                                       Icons.skip_previous,
//                                       size: 50,
//                                       color: Theme.of(context).primaryColor,
//                                     )),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             )));
//   }

//   void _iconTapped() {
//     if (videoPlaying == false) {
//       _animationController.forward();
//       videoPlaying = true;
//     } else {
//       _animationController.reverse();
//       videoPlaying = false;
//     }
//   }
// }
