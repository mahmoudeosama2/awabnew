import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class Praise with ChangeNotifier {
  String alreadyexis = "Error : This Praise Already Existing";
  int? total;
  int num = 0;
  List<List<String>>? praiseslist = [];
  List countLocMorningPraiseslist = [];
  List countlocNightPraiseslist = [];
  
  // القوائم الجديدة من JSON
  List<String> morningAzkarList = [];
  List<String> eveningAzkarList = [];
  List<String> intFirstPraiseList = [];
  
  bool isAzkarLoaded = false;

  // تحميل الأذكار من JSON
  Future<void> loadAzkarFromJson() async {
    if (isAzkarLoaded) return;
    
    try {
      final String response = await rootBundle.loadString('asset/json/azkar.json');
      final data = json.decode(response);
      
      // تحميل أذكار الصباح
      if (data['أذكار الصباح'] != null) {
        final morningData = data['أذكار الصباح'];
        if (morningData is List && morningData.isNotEmpty) {
          if (morningData[0] is List) {
            for (var item in morningData[0]) {
              if (item is Map && item['content'] != null) {
                String content = item['content'].toString()
                    .replaceAll('\\n', '')
                    .replaceAll('\\"', '"')
                    .replaceAll("'", '')
                    .trim();
                if (content.isNotEmpty && content != 'stop') {
                  morningAzkarList.add(content);
                }
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
                  .replaceAll("'", '')
                  .trim();
              if (content.isNotEmpty) {
                eveningAzkarList.add(content);
              }
            }
          }
        }
      }
      
      // تحميل تسابيح
      if (data['تسابيح'] != null) {
        final tasabeehData = data['تسابيح'];
        if (tasabeehData is List) {
          for (var item in tasabeehData) {
            if (item is Map && item['content'] != null) {
              String content = item['content'].toString()
                  .replaceAll('\\n', '')
                  .replaceAll('\\"', '"')
                  .replaceAll("'", '')
                  .trim();
              if (content.isNotEmpty && !intFirstPraiseList.contains(content)) {
                intFirstPraiseList.add(content);
              }
            }
          }
        }
      }
      
      // إذا كانت التسابيح فارغة، أضف بعض التسابيح الافتراضية
      if (intFirstPraiseList.isEmpty) {
        intFirstPraiseList = [
          'سبحان الله وبحمده سبحان الله العظيم',
          'لا إله إلا أنت سبحانك إني كنتُ من الظَّالمين',
          'لا إله إلا الله وحده لا شريك له له الملك وله الحمد وهو على كل شيء قدير',
          'اللهم اغفر لي وتب علي، إنك أنت التواب الرحيم',
          'أستغفر الله العظيم واتوب اليه',
        ];
      }
      
      isAzkarLoaded = true;
      notifyListeners();
      
      print('تم تحميل ${morningAzkarList.length} من أذكار الصباح');
      print('تم تحميل ${eveningAzkarList.length} من أذكار المساء');
      print('تم تحميل ${intFirstPraiseList.length} من التسابيح');
    } catch (e) {
      print('خطأ في تحميل الأذكار: $e');
      // في حالة الخطأ، استخدم القوائم الافتراضية
      _loadDefaultLists();
    }
  }

  void _loadDefaultLists() {
    intFirstPraiseList = [
      'سبحان الله وبحمده سبحان الله العظيم',
      'لا إله إلا أنت سبحانك إني كنتُ من الظَّالمين',
      'لا إله إلا الله وحده لا شريك له له الملك وله الحمد وهو على كل شيء قدير',
      'اللهم اغفر لي وتب علي، إنك أنت التواب الرحيم',
      'أستغفر الله العظيم واتوب اليه',
    ];
  }

  void count(String zekr, int index) async {
    try {
      total = (total ?? 0) + 1;
      num = num + 1;
      if (index < praiseslist!.length) {
        int currentCount = int.tryParse(praiseslist![index][1]) ?? 0;
        praiseslist![index][1] = (currentCount + 1).toString();
        await countpraise(zekr);
      }
      notifyListeners();
    } catch (e) {
      print('خطأ في العد: $e');
    }
  }

  Future<List<String>> countpraise2(String zekr) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> praise = prefs.getStringList(zekr) ?? [zekr, "0"];
      int temp = int.tryParse(praise[1]) ?? 0;
      temp = temp + 1;
      await prefs.remove(zekr);
      await prefs.setStringList(zekr, [zekr, temp.toString(), "0"]);
      notifyListeners();
      return praise;
    } catch (e) {
      print('خطأ في countpraise2: $e');
      return [zekr, "0"];
    }
  }

  void count2(String zekr, int index, bool islocal, bool ismorn) async {
    try {
      total = (total ?? 0) + 1;
      num = num + 1;
      
      if (!islocal) {
        if (index < praiseslist!.length) {
          int currentCount = int.tryParse(praiseslist![index][1]) ?? 0;
          praiseslist![index][1] = (currentCount + 1).toString();
          await countpraise2(zekr);
        }
      } else {
        if (ismorn) {
          if (index < countLocMorningPraiseslist.length) {
            countLocMorningPraiseslist[index] = 
                (countLocMorningPraiseslist[index] ?? 0) + 1;
            await countPraiseLocal(zekr);
          }
        } else {
          if (index < countlocNightPraiseslist.length) {
            countlocNightPraiseslist[index] = 
                (countlocNightPraiseslist[index] ?? 0) + 1;
            await countPraiseLocal(zekr);
          }
        }
      }
      notifyListeners();
    } catch (e) {
      print('خطأ في count2: $e');
    }
  }

  Future<void> initLocpriase() async {
    await loadAzkarFromJson();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    countLocMorningPraiseslist.clear();
    countlocNightPraiseslist.clear();
    
    for (int i = 0; i < morningAzkarList.length; i++) {
      int count = prefs.getInt(morningAzkarList[i]) ?? 0;
      await prefs.setInt(morningAzkarList[i], count);
      countLocMorningPraiseslist.add(count);
    }
    
    for (int i = 0; i < eveningAzkarList.length; i++) {
      int count = prefs.getInt(eveningAzkarList[i]) ?? 0;
      await prefs.setInt(eveningAzkarList[i], count);
      countlocNightPraiseslist.add(count);
    }
    
    notifyListeners();
  }

  Future<void> countPraiseLocal(String zekr) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int temp = prefs.getInt(zekr) ?? 0;
      await prefs.setInt(zekr, temp + 1);
      notifyListeners();
    } catch (e) {
      print('خطأ في countPraiseLocal: $e');
    }
  }

  void addPraisesName(String zekr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> praises = prefs.getStringList("praises") ?? [];
    if (!praises.contains(zekr)) {
      praises.add(zekr);
      await prefs.setStringList("praises", praises);
    }
  }

  Future<void> addPraise(String zekr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alreadyExistingPraises = prefs.getStringList("praises") ?? [];
    
    if (alreadyExistingPraises.contains(zekr)) {
      print(alreadyexis);
      return;
    }
    
    addPraisesName(zekr);
    praiseslist?.add([zekr, "0"]);
    await prefs.setStringList(zekr, [zekr, "0"]);
    notifyListeners();
  }

  Future<void> initsomeprefs() async {
    await loadAzkarFromJson();
    for (int i = 0; i < intFirstPraiseList.length; i++) {
      await addPraise(intFirstPraiseList[i]);
    }
  }

  Future<void> getLocpriase() async {
    await loadAzkarFromJson();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    countLocMorningPraiseslist.clear();
    countlocNightPraiseslist.clear();
    
    for (int i = 0; i < morningAzkarList.length; i++) {
      countLocMorningPraiseslist.add(prefs.getInt(morningAzkarList[i]) ?? 0);
    }
    
    for (int i = 0; i < eveningAzkarList.length; i++) {
      countlocNightPraiseslist.add(prefs.getInt(eveningAzkarList[i]) ?? 0);
    }
    
    notifyListeners();
  }

  Future<List<String>> countpraise(String zekr) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> praise = prefs.getStringList(zekr) ?? [zekr, "0"];
      int temp = int.tryParse(praise[1]) ?? 0;
      temp = temp + 1;
      await prefs.remove(zekr);
      await prefs.setStringList(zekr, [zekr, temp.toString(), "0"]);
      notifyListeners();
      return praise;
    } catch (e) {
      print('خطأ في countpraise: $e');
      return [zekr, "0"];
    }
  }

  void deletepraise(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listpraises = prefs.getStringList("praises") ?? [];
    listpraises.remove(key);
    await prefs.setStringList("praises", listpraises);
    praiseslist?.removeWhere((element) => element[0] == key);
    notifyListeners();
    await prefs.remove(key);
  }

  Future<List<List<String>>> showallpraises() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> praisesName = prefs.getStringList("praises") ?? [];
    List<List<String>> allpraises = [];
    
    for (var element in praisesName) {
      List<String> temp = prefs.getStringList(element) ?? [element, "0"];
      allpraises.add(temp);
    }
    
    praiseslist = allpraises;
    notifyListeners();
    return allpraises;
  }

  void reset2(String zekr, int index, bool isLocal, bool ismorning) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!isLocal) {
        await prefs.setStringList(zekr, [zekr, "0"]);
        if (index < praiseslist!.length) {
          praiseslist![index][1] = "0";
        }
      } else {
        await prefs.setInt(zekr, 0);
        if (ismorning) {
          if (index < countLocMorningPraiseslist.length) {
            countLocMorningPraiseslist[index] = 0;
          }
        } else {
          if (index < countlocNightPraiseslist.length) {
            countlocNightPraiseslist[index] = 0;
          }
        }
      }
      num = 0;
      total = 0;
      notifyListeners();
    } catch (e) {
      print('خطأ في reset2: $e');
    }
  }

  void reset(String zekr, int index) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(zekr, [zekr, "0"]);
      if (index < praiseslist!.length) {
        praiseslist![index][1] = "0";
      }
      num = 0;
      total = 0;
      notifyListeners();
    } catch (e) {
      print('خطأ في reset: $e');
    }
  }
}