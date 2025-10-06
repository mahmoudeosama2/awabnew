import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart%20';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/model_complete_quran.dart';
import '../models/model_quran_reader.dart';
import '../pages/ListenQuran/audio.dart';
import 'package:path/path.dart' as path;

class Quran with ChangeNotifier {
  List<Surahs> surahs = [];
  List<Qari> quranreader = [];
  List<AudioSource>? audioSourceList;

  List<FileSystemEntity>? _files;
  List<Map<String, List<Map<String, double>>>> isDownloading = [];
  List<Map<String, double>> temp = [];
  List folders = [];
  List songs = [];
  String? url = "";
  var relvaationreader;
  var qariname;
  var indexQari;

  Future<List<Surahs>> ReadJsonCompleteQuran() async {
    final jsondata =
        await rootBundle.loadString("asset/json/complete_quran.json");
    Map<String, dynamic> json = jsonDecode(jsondata);
    json['data']['surahs'].forEach((element) {
      if (surahs.length < json['data']['surahs'].length) {
        surahs.add(Surahs.fromJson(element));
      }
    });

    return surahs;
  }

  Future<List<Surahs>> ReadJsonCompleteAwab() async {
    final jsondata =
        await rootBundle.loadString("asset/json/hafs_smart_v8.json");
    Map<String, dynamic> json = jsonDecode(jsondata);
    json['data']['surahs'].forEach((element) {
      if (surahs.length < json['data']['surahs'].length) {
        surahs.add(Surahs.fromJson(element));
      }
    });
    return surahs;
  }

  Future<List<Qari>> ReadJsonQuranReader() async {
    final jsondata = await rootBundle.loadString("asset/json/quranreader.json");
    List<dynamic> json = jsonDecode(jsondata);
    for (var element in json) {
      if (quranreader.length < json.length) {
        quranreader.add(Qari.fromJson(element));
      }
    }
    quranreader.sort(
      (a, b) => a.name!.compareTo(b.name!),
    );
    return quranreader;
  }

  List<AudioSource> getList() {
    print("get list is on ========================================");
    audioSourceList = [];
    for (var element in surahs) {
      print(
          "https://download.quranicaudio.com/quran/$relvaationreader${correctindex(element.number)}.mp3");
      audioSourceList!.add(
        AudioSource.uri(
            Uri.parse(
                "https://download.quranicaudio.com/quran/$relvaationreader${correctindex(element.number)}.mp3"),
            tag: MediaItem(
                id: "${element.number}",
                title: "${element.name}",
                album: qariname)),
      );
    }

    print(audioSourceList!.length);
    return audioSourceList!;
  }

  geturl(number) {
    url =
        "https://download.quranicaudio.com/quran/$relvaationreader${correctindex(number)}.mp3";

    return url;
  }

  // Downloadfile(quranName, quranNumber, index) {
  //   FileDownloader.downloadFile(
  //     onDownloadRequestIdReceived: (downloadId) {},
  //     url: geturl(quranNumber),
  //     name: "${relvaationreader}-${quranName}.mp3",
  //     headers: {'Header': 'Test'},
  //     onProgress: (fileName, progress) {
  //       percentage[index] = progress;
  //     },
  //     downloadDestination: DownloadDestinations.appFiles,
  //     onDownloadCompleted: (path) => print(path),
  //   );
  // }

  void downloadFile(quranName, quranNumber, index) async {
    Dio dio = Dio();
    try {
      await dio.download(geturl(114),
          "/storage/emulated/0/Awab/Sounds/${relvaationreader}${quranName}.mp3",
          onReceiveProgress: (receivedBytes, totalBytes) {
        if (totalBytes != -1) {
          isDownloading[indexQari][relvaationreader]![index]['progress'] =
              ((receivedBytes / totalBytes) * 100);
          print(isDownloading[indexQari][relvaationreader]![index]['progress']);
          notifyListeners();

          if ((receivedBytes / totalBytes) * 100 == 100) {
            isDownloading[indexQari]
                [relvaationreader]![index] = {"$quranName": 2};
            notifyListeners();
          }
        }
      });
      print('File downloaded successfully');
    } catch (e) {
      print('Error occurred during file download: $e');
    }
  }

  // void downloadFile(quranName, quranNumber, index, progress) async {
  //   Dio dio = Dio();
  //   print(
  //       "/storage/emulated/0/Awab/Sounds/${relvaationreader}${quranName}.mp3");
  //   try {
  //     await await dio.download(geturl(quranNumber),
  //         "/storage/emulated/0/Awab/Sounds/${relvaationreader}${quranName}.mp3",
  //       if (totalBytes != -1) {
  //         progress = (receivedBytes / totalBytes) * 100;
  //         print('Download progress: ${progress[index].toStringAsFixed(0)}%');
  //       }
  //     });
  //     // isDownloading[relvaationreader]![index]["check"] = 2;
  //     print('File downloaded successfully');
  //   } catch (e) {
  //     print('Error occurred during file download: $e');
  //   }
  // }

  void getSoundsFolderName() {
    try {
      folders = [];
      Directory dir = Directory("/storage/emulated/0/Awab/Sounds");
      _files = dir.listSync(followLinks: false, recursive: true);
      dir.create();
      for (FileSystemEntity entity in _files!) {
        folders.add((entity.parent)
            .toString()
            .replaceAll("/storage/emulated/0/Awab/Sounds", ""));
      }
      //print(folders); } catch (e)
    } catch (e) {
      print("error getLocalSurahs: $e ");
    }
  }

  void getLocalSurahs() {
    try {
      if (relvaationreader != null) {
        songs = [];
        _files = [];
        print(relvaationreader);
        print(qariname);
        Directory dir =
            Directory("/storage/emulated/0/Awab/Sounds/$relvaationreader");
        dir.create();
        print(dir.path);
        _files = dir.listSync(followLinks: false, recursive: true);
        for (FileSystemEntity entity in _files!) {
          String fileName = path.basename(entity.path);
          songs.add(fileName);
        }
        print(songs);
      }
    } catch (e) {
      print("error getLocalSurahs: $e");
    }
  }

  // listQurasnsFilled() {
  //   isDownloading = [];
  //   temp = [];
  //   for (int x = 0; x < 114; x++) {
  //     temp.add({surahs[x].name.toString(): 0});
  //   }
  //   for (int i = 0; i < quranreader.length; i++) {
  //     isDownloading.add({quranreader[i].relativePath!: temp});
  //   }
  // }
  listQurasnsFilled() {
    isDownloading = [];
    for (int x = 0; x < 114; x++) {
      Map<String, double> tempMap = {
        surahs[x].name.toString(): 0,
        "progress": 0.0
      };
      temp.add(tempMap);
    }
    for (int i = 0; i < quranreader.length; i++) {
      isDownloading.add({quranreader[i].relativePath!: List.from(temp)});
    }
  }

  listClear() {
    temp = [];
    for (int x = 0; x < 114; x++) {
      temp.add({surahs[x].name.toString(): 0});
    }
    print(indexQari);
    print(relvaationreader);
    isDownloading[indexQari][relvaationreader] = [];
    isDownloading[indexQari][relvaationreader] = temp;
  }

  setdata() {
    isDownloading[1]
        ["abdulmun3im_abdulmubdi2/"]![1] = {"سُورَةُ البَقَرَةِ": 2};
  }

  printdata() {
    // isDownloading[1]["abdulmun3im_abdulmubdi2/"]![0]["سُورَةُ ٱلْفَاتِحَةِ"] =
    //     5;
    print("/////////////////////////////////////////////");
    //print(isDownloading[0]);
    print("*********************************************");
    print(isDownloading[1]);
    print("*********************************************");
    // print(isDownloading[2]);
    // print("*********************************************");
    // print(isDownloading[3]);
    print("/////////////////////////////////////////////");
  }
  
}
