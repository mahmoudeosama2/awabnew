// import 'package:awab/app/statemanagment/otherProviders.dart';
// import 'package:arabic_numbers/arabic_numbers.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart%20';
// import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
// import '../../../models/model_complete_quran.dart';
// import '../../../services/control_audio.dart';

// List<Ayahs> ayahs = [];
// ArabicNumbers arabicNumber = ArabicNumbers();
// List<TextSpan>? textspan = [];
// bool? isplay = false;
// bool? skip = false;
// List<bool> chngCol = [];
// int perudic = 0;

// class ViewSurah extends StatefulWidget {
//   final surah;
//   const ViewSurah({super.key, required this.surah});
//   @override
//   State<ViewSurah> createState() => _ViewSurahtate();
// }

// class _ViewSurahtate extends State<ViewSurah> {
//   @override
//   void initState() {
//     audiodisbose();
//     chngCol.removeRange(0, chngCol.length);
//     ayahs = widget.surah.ayahs;
//     print("object");
//     super.initState();
//   }

//   totalayat() {
//     textspan = [];
//     bool test = false;
//     removebasmal(ayahs[0].text!) == null ? test = true : test = false;
//     for (int i = 0; i < ayahs.length; i++) {
//       chngCol.add(false);

//       if (test) {
//         if (i != 0) {
//           textspan!.add(
//             TextSpan(
//               text:
//                   " ${ayahs[i].text!}  \uFD3F ${arabicNumber.convert(i)} \uFD3E",
//               style: Theme.of(context).textTheme.displaySmall?.copyWith(
//                   color: chngCol[i] == true
//                       ? Colors.green
//                       : Theme.of(context).textTheme.displaySmall?.color),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   if (isplay == false) {
//                     chngcoloror = true;
//                     chngCol[i] = chngcoloror!;
//                     getaudio("${ayahs[i].audio}");
//                     setState(() {
//                       chngCol[i] = chngcoloror!;
//                     });

//                     isplay = true;
//                   } else if (isplay == true) {
//                     chngCol[i] = false;
//                     pauseaudio();
//                     isplay = false;
//                   }

//                   // callMyFunction();
//                 },
//             ),
//           );
//         }
//       } else {
//         if (i == 0) {
//           ayahs[i].text = removebasmal(ayahs[i].text!);
//         }
//         textspan!.add(
//           TextSpan(
//             text:
//                 " ${ayahs[i].text!}  \uFD3F ${arabicNumber.convert(i + 1)} \uFD3E",
//             style: Theme.of(context).textTheme.displaySmall?.copyWith(
//                 color: chngCol[i] == true
//                     ? Colors.green
//                     : Theme.of(context).textTheme.displaySmall?.color),
//             recognizer: TapGestureRecognizer()
//               ..onTap = () {
//                 if (isplay == false) {
//                   chngcoloror = true;
//                   chngCol[i] = chngcoloror!;
//                   getaudio("${ayahs[i].audio}");
//                   setState(() {
//                     chngCol[i] = chngcoloror!;
//                   });

//                   isplay = true;
//                 } else if (isplay == true) {
//                   chngCol[i] = false;
//                   pauseaudio();
//                   isplay = false;
//                 }

//                 // callMyFunction();
//               },
//           ),
//         );
//         if (test == true) {
//           textspan!.remove(0);
//         }
//       }
//     }
//     print("chngCol[1]");
//   }

//   @override
//   Widget build(BuildContext context) {
//     totalayat();
//     double width = MediaQuery.of(context).size.width;
//     return Hero(
//       tag: "surah${widget.surah.number}",
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: WillPopScope(
//           onWillPop: () async {
//             pauseaudio();
//             return true;
//           },
//           child: Scaffold(
//             backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//             body: Directionality(
//               textDirection: TextDirection.rtl,
//               child: Column(
//                 children: [
//                   Container(
//                     color: Theme.of(context).primaryColor,
//                     height: 30,
//                     width: width,
//                   ),
//                   Container(
//                     // margin: EdgeInsets.only(top: 30),
//                     height: 150,
//                     width: width,
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Theme.of(context).primaryColor,
//                             Theme.of(context).primaryColor,
//                           ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                         borderRadius: BorderRadius.only(
//                             bottomLeft: Radius.circular(18),
//                             bottomRight: Radius.circular(18))),

//                     child: Stack(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Container(
//                               margin: const EdgeInsets.only(right: 20),
//                               child: Image.asset("asset/images/quranRail.png",
//                                   color: Colors.grey.withOpacity(0.4),
//                                   colorBlendMode: BlendMode.modulate),
//                             )
//                           ],
//                         ),
//                         Column(children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                   margin: const EdgeInsets.only(
//                                       top: 15, bottom: 10),
//                                   child: Text("${widget.surah.name}",
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headlineLarge)),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "عدد الأيات : ${arabicNumber.convert(ayahs.length)}",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headlineMedium,
//                                       ),
//                                       const SizedBox(
//                                         width: 70,
//                                       ),
//                                       Text(
//                                         "الجزء : ${arabicNumber.convert(ayahs[1].juz)} ",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headlineMedium,
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "رقم السوره : ${arabicNumber.convert(widget.surah.number)}",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headlineMedium,
//                                       ),
//                                       const SizedBox(
//                                         width: 70,
//                                       ),
//                                       Text(
//                                         widget.surah.revelationType == "Meccan"
//                                             ? "نوع السوره : مكيه "
//                                             : "نوع السوره : مدنيه ",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headlineMedium,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ]),
//                         Container(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     pauseaudio();
//                                     Navigator.pop(context);
//                                   },
//                                   icon: Icon(
//                                     Icons.arrow_back,
//                                     color: Theme.of(context).scaffoldBackgroundColor,
//                                   ))
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: MediaQuery.of(context).size.height - 200,
//                     width: double.infinity,
//                     margin: const EdgeInsets.all(10),
//                     child: MediaQuery.removePadding(
//                       context: context,
//                       removeTop: true,
//                       child: ListView(children: [
//                         Container(
//                           alignment: Alignment.center,
//                           child: Text(
//                               widget.surah.number == 9
//                                   ? ""
//                                   : "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displaySmall
//                                   ?.copyWith(fontSize: 23)),
//                         ),
//                         Text.rich(TextSpan(
//                             style: Theme.of(context).textTheme.displaySmall,
//                             children: textspan as List<TextSpan>)),
//                       ]),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:awab/app/statemanagment/otherProviders.dart';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/model_complete_quran.dart';
import '../../../services/control_audio.dart';

List<Ayahs> ayahs = [];
ArabicNumbers arabicNumber = ArabicNumbers();
List<TextSpan>? textspan = [];
bool? isplay = false;
bool? skip = false;
List<bool> chngCol = [];
int perudic = 0;
double markoffset = 0.0;
bool onceone = false;

class ViewSurah extends StatefulWidget {
  final surah;

  const ViewSurah({super.key, required this.surah});
  @override
  State<ViewSurah> createState() => _ViewSurahtate();
}

class _ViewSurahtate extends State<ViewSurah> {
  @override
  void initState() {
    audiodisbose();
    chngCol.removeRange(0, chngCol.length);
    ayahs = widget.surah.ayahs;
    print("object");

    super.initState();
  }

  ScrollController scrollController = ScrollController();
  totalayat() {
    textspan = [];
    bool test = false;
    removebasmal(ayahs[0].text!) == null ? test = true : test = false;

    for (int i = 0; i < ayahs.length; i++) {
      chngCol.add(false);
      if (test) {
        if (i != 0) {
          textspan!.add(
            TextSpan(
              text:
                  " ${ayahs[i].text!}  \uFD3F ${arabicNumber.convert(i)} \uFD3E",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: chngCol[i] == true
                    ? Colors.green
                    : Theme.of(context).textTheme.displaySmall?.color,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (isplay == false) {
                    chngcoloror = true;
                    chngCol[i] = chngcoloror!;
                    getaudio("${ayahs[i].audio}");
                    setState(() {
                      chngCol[i] = chngcoloror!;
                    });

                    isplay = true;
                  } else if (isplay == true) {
                    chngCol[i] = false;
                    pauseaudio();
                    isplay = false;
                  }

                  // callMyFunction();
                },
            ),
          );
        }
      } else {
        if (i == 0) {
          ayahs[i].text = removebasmal(ayahs[i].text!);
        }
        textspan!.add(
          TextSpan(
            text:
                " ${ayahs[i].text!}  \uFD3F ${arabicNumber.convert(i + 1)} \uFD3E",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: chngCol[i] == true
                  ? Colors.green
                  : Theme.of(context).textTheme.displaySmall?.color,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (isplay == false) {
                  chngcoloror = true;
                  chngCol[i] = chngcoloror!;
                  getaudio("${ayahs[i].audio}");
                  setState(() {
                    chngCol[i] = chngcoloror!;
                  });

                  isplay = true;
                } else if (isplay == true) {
                  chngCol[i] = false;
                  pauseaudio();
                  isplay = false;
                }

                // callMyFunction();
              },
          ),
        );
        if (test == true) {
          textspan!.remove(0);
        }
      }
    }
    print("chngCol[1]");
  }

  @override
  Widget build(BuildContext context) {
    var other = Provider.of<Other>(context, listen: true);
    double width = MediaQuery.of(context).size.width;

    Future.delayed(const Duration(milliseconds: 500), () async {
      scrollController.animateTo(
        other.surahMark,
        duration: Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    });

    scrollController.addListener(() {
      Future.delayed(const Duration(seconds: 2), () async {
        other.surahMark = scrollController.offset;
        other.addSurahMark(widget.surah.name);
      });
    });

    totalayat();
    return Hero(
      tag: "surah${widget.surah.number}",
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: WillPopScope(
          onWillPop: () async {
            other.surahMark = 0.0;
            pauseaudio();
            return true;
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        Container(
                          color: Theme.of(context).primaryColor,
                          height: 30,
                          width: width,
                        ),
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                            ),
                          ),
                          width: width,
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 20),
                                    child: Image.asset(
                                      "asset/images/quranRail.png",
                                      color: Colors.grey.withOpacity(0.4),
                                      colorBlendMode: BlendMode.modulate,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 10,
                                        ),
                                        child: Text(
                                          "${widget.surah.name}",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "عدد الأيات : ${arabicNumber.convert(ayahs.length)}",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.headlineMedium,
                                              ),
                                              const SizedBox(width: 70),
                                              Text(
                                                "الجزء : ${arabicNumber.convert(ayahs[1].juz)} ",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.headlineMedium,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "رقم السوره : ${arabicNumber.convert(widget.surah.number)}",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.headlineMedium,
                                              ),
                                              const SizedBox(width: 70),
                                              Text(
                                                widget.surah.revelationType ==
                                                        "Meccan"
                                                    ? "نوع السوره : مكيه "
                                                    : "نوع السوره : مدنيه ",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.headlineMedium,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        other.surahMark = 0.0;
                                        pauseaudio();
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height - 200,
                          width: double.infinity,
                          margin: const EdgeInsets.all(10),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView(
                              controller: scrollController,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.surah.number == 9
                                        ? ""
                                        : "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(fontSize: 23),
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displaySmall,
                                    children: textspan as List<TextSpan>,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
