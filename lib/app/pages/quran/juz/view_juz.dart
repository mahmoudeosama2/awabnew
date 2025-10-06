// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart%20';
// import 'package:page_flip/page_flip.dart';
// import 'package:provider/provider.dart';
// import '../../../models/model_complete_quran.dart';
// import '../../../statemanagment/quranProvider.dart';
// import 'demppage.dart';

// List<Surahs>? _surah;
// GlobalKey _controller = GlobalKey();

// class ViewJuz extends StatefulWidget {
//   final surah;

//   const ViewJuz({super.key, this.surah});

//   @override
//   State<ViewJuz> createState() => _ViewJuztate();
// }

// class _ViewJuztate extends State<ViewJuz> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(widget.surah);
//     var model = Provider.of<Quran>(context);
//     _surah ??= model.surahs;

//     SystemChrome.setSystemUIOverlayStyle(
//         const SystemUiOverlayStyle(statusBarColor: Colors.white));
//     return Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//             appBar: AppBar(),
//             backgroundColor: Theme.of(context).colorScheme.background,
//             body: Container(
//                 margin: const EdgeInsets.all(10),
//                 child: PageFlipWidget(
//                   key: _controller,
//                   backgroundColor: Colors.white,
//                   showDragCutoff: false,
//                   lastPage: const Center(child: Text('Last Page!')),
//                   children: <Widget>[
//                     for (int i = 0; i < 5; i++)
//                       DemoPage(surah: _surah),
//                   ],
//                 ))));
//   }
// }
