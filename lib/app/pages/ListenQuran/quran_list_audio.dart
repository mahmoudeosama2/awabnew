import 'dart:io' show Directory, Platform;
import 'package:activity_ring/activity_ring.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:awab/app/customewidget/custom_counter.dart';
import 'package:awab/app/customewidget/customtextField.dart';
import 'package:awab/app/models/model_complete_quran.dart';
import 'package:awab/app/pages/ListenQuran/audio.dart';
import 'package:awab/app/services/control_audio.dart';
import 'package:awab/app/statemanagment/quranProvider.dart';
import 'package:permission_handler/permission_handler.dart';

String languagecode = Platform.localeName.split('_')[0];
List<Surahs>? surah;
List<Surahs>? filter;
PermissionStatus _permissionStatus = PermissionStatus.denied;
Permission? permission;
String? msgError = "";
List<int> isDownsloading = [0];

class QuranListAudio extends StatefulWidget {
  const QuranListAudio({super.key});
  @override
  State<QuranListAudio> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranListAudio> {
  @override
  void initState() {
    var model = Provider.of<Quran>(context, listen: false);
    model.getLocalSurahs();
    print(languagecode);
    super.initState();
  }

  void updatelist(String value) {
    setState(() {
      filter = surah
          ?.where(
            (element) => removetachkil(
              element.name,
            ).toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<Quran>(context, listen: false);

    surah ??= model.surahs;
    filter ??= surah;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Text("data"),
      // ),
      appBar: AppBar(
        title: Text(
          "${model.qariname}",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Directionality(
            textDirection: languagecode == "en"
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //  width: width,
              children: [
                Container(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 7, left: 10, right: 10),
              child: CustomTextField(onchange: (value) => updatelist(value)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filter!.length,
                itemBuilder: (context, i) {
                  // print(filter![i]);
                  return List_of_surah(index: i, quran: filter![i]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class List_of_surah extends StatefulWidget {
  final Surahs quran;
  final index;
  const List_of_surah({super.key, required this.quran, required this.index});

  @override
  State<List_of_surah> createState() => _List_of_surahState();
}

class _List_of_surahState extends State<List_of_surah> {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<Quran>(context, listen: false);

    //print(model.songs[0].toString() =='سُورَةُ ٱلْفَاتِحَةِ.mp3');
    // print("${widget.quran.name}.mp3");

    // if (model.songs.contains("${widget.quran.name}.mp3")) {
    //   model.isDownloading[model.indexQari]
    //       [model.relvaationreader]![widget.index] = {widget.quran.name!: 2};
    // }
    CheckPermissionStatus() async {
      PermissionStatus status;
      status = await Permission.storage.request();
      if (status.isDenied) {
        Fluttertoast.showToast(
          msg: "لا يمكن تحميل السوره بدون صلاحية الوصول للملفات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
          textColor: Colors.white,
          fontSize: 16.0,
        );
        await openAppSettings();
        return false;
      } else {
        // Downloadfile();
        // model.Downloadfile(widget.quran.name, widget.quran.number, index);

        setState(() {
          model.isDownloading[model.indexQari][model.relvaationreader]![widget
              .index] = {
            widget.quran.name.toString(): 1,
          };
        });

        model.downloadFile(
          widget.quran.name,
          widget.quran.number,
          widget.index,
        );
      }
    }

    DownloadIcon() {
      if (model.isDownloading[model.indexQari][model.relvaationreader]![widget
              .index][widget.quran.name.toString()] ==
          0) {
        return IconButton(
          icon: Icon(Icons.download),
          onPressed: () {
            setState(() {
              CheckPermissionStatus();
            });
          },
        );
      } else if (model.isDownloading[model.indexQari][model
              .relvaationreader]![widget.index][widget.quran.name] ==
          1) {
        return Ring(
          percent:
              model.isDownloading[model.indexQari][model
                  .relvaationreader]![widget.index]["progress"]!,
          color: RingColorScheme(
            backgroundColor: Colors.transparent,
            ringGradient: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ],
          ),
          radius: 20,
          width: 6,
          child: Center(
            child: Text(
              '${model.isDownloading[model.indexQari][model.relvaationreader]![widget.index]["progress"]!.toStringAsPrecision(3)}%',
              style: TextStyle(fontSize: 7),
            ),
          ),
        );
      } else if (model.isDownloading[model.indexQari][model
              .relvaationreader]![widget.index][widget.quran.name] ==
          2) {
        return IconButton(
          icon: Icon(
            Icons.download_done_outlined,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            // if (_CheckPermissionStatus(widget.index) == true) {
            //   // model.isDownloading[model.relvaationreader]![widget.index]
            //   //     ["check"] = 1;
            // }
          },
        );
      }
    }

    return Hero(
      tag: widget.quran.name!,
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  model.getList();
                  return AudioPlayerScreen(
                    index: widget.index,
                    audioSourceList: model.audioSourceList,
                  );
                },
              ),
            );
          },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListTile(
              tileColor: Theme.of(context).scaffoldBackgroundColor,

              //trailing:Container(height: 30, width: 30, child: DownloadIcon()),
              title: Text(
                "${widget.quran.name}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subtitle: Text(
                widget.quran.revelationType!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: CounterIcons(num: widget.quran.number!),
            ),
          ),
        ),
      ),
    );
  }
}
