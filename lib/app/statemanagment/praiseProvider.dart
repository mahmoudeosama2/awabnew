// import 'package:flutter/widgets.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Praise with ChangeNotifier {
//   String alreadyexis = "Erorr : This Praise Already Existing";
//   int? total;
//   int num = 0;
//   List<List<String>>? praiseslist = [];

//   iniPraiseList() async {
//     for (String temp in intFirstPraiseList) {
//       addPraise("$temp");
//     }
//   }

//   void addPraisesName(String zekr) async {
//     SharedPreferences  prefs = await SharedPreferences.getInstance();
//     List<String> praises = await prefs.getStringList("praises")!;

//     if (praises == null) {
//       praises.add(zekr);
//       await prefs.setStringList("praises", praises);
//     } else {
//       praises.add(zekr);
//       await prefs.remove("praises");
//       await prefs.setStringList("praises", praises);
//     }
//   }

//   addPraise(String zekr) async {  print(zekr);
//     SharedPreferences  prefs = await SharedPreferences.getInstance();
//     List<String>? praises;
//     List<String> alreadyExistingPraises = [];
//     if (await prefs.containsKey("praises") == false) {

//       praises!.add(zekr);
//       await prefs.setStringList("praises", praises);
//       praiseslist?.add([zekr, "0"]);
//       await prefs.setStringList(zekr, [zekr, "0"]);
//     } else {
//       alreadyExistingPraises = await prefs.getStringList("praises")!;
//       if (alreadyExistingPraises.contains(zekr)) {
//         return print(alreadyexis);
//       } else {
//         praises = await prefs.getStringList("praises");
//         await prefs.remove("praises");
//         await prefs.setStringList("praises", praises!);
//         praiseslist?.add([zekr, "0"]);
//         await prefs.setStringList(zekr, [zekr, "0"]);
//       }
//       notifyListeners();
//     }
//   }

//   countpraise(String zekr) async {
//     SharedPreferences  prefs = await SharedPreferences.getInstance();
//     int temp;
//     temp = 0;
//     List<String> praise = [];
//     praise = await prefs.getStringList(zekr)!;
//     temp = int.parse(praise[1]) + 1;
//     await prefs.remove(zekr);
//     await prefs.setStringList(zekr, [zekr, temp.toString(), "0"]);
//     notifyListeners();
//     return praise;
//   }

//   void deletepraise(String key) async {
//     SharedPreferences  prefs = await SharedPreferences.getInstance();
//     List<String> listpraises = await prefs.getStringList("praises")!;
//     listpraises.remove(key);
//     await prefs.setStringList("praises", listpraises);
//     praiseslist?.removeWhere((element) => element[0] == key);
//     notifyListeners();
//     await prefs.remove(key);
//   }

//   Future<List<List<String>>> showallpraises() async {
//     List<String>? temp;
//     List<String> praisesName = [];
//     SharedPreferences  prefs = await SharedPreferences.getInstance();
//     List<List<String>> allpraises = [];
//     if (await prefs.getStringList("praises") != null) {
//       praisesName = await prefs.getStringList("praises")!;
//       // ignore: unnecessary_null_comparison
//       if (praisesName != null) {
//         for (var element in praisesName) {
//           temp = await prefs.getStringList(element)!;
//           allpraises.add(temp);
//           temp = null;
//         }
//       } else {
//         print("error get all prises name");
//       }
//       praiseslist = null;
//       praiseslist = allpraises;
//       notifyListeners();
//     }

//     return allpraises;
//   }

//   checkFoundawait prefs(key) async {
//     SharedPreferences  prefs = await SharedPreferences.getInstance();
//     print(await prefs.getStringList("praises"));
//     if (await prefs.containsKey(key)) {
//       print("yes it is found");
//     } else {
//       print("yes it is found");
//     }
//   }
// }

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Praise with ChangeNotifier {
  String alreadyexis = "Erorr : This Praise Already Existing";
  int? total;
  int num = 0;
  List<List<String>>? praiseslist = [];
  List countLocMorningPraiseslist = [];
  List countlocNightPraiseslist = [];

  List<String> intFirstPraiseList = [
    'سبحان الله وبحمده سبحان الله العظيم',
    'لا إله إلا أنت سبحانك إني كنتُ من الظَّالمين',
    'لا إله إلا الله وحده لا شريك له له الملك وله الحمد وهو على كل شيء قدير',
    'اللهم اغفر لي وتب علي، إنك أنت التواب الرحيم',
    'أستغفر الله العظيم واتوب اليه',
  ];

  List<String> locMorningPraiseslist = [
    'أصبَحنا على فطرةِ الإسلامِ وعلى وكلمةِ الإخلاصِ وعلى دينِ نبيِّنا محمَّدٍ صلَّى اللَّهُ عليْهِ وسلَّمَ وعلى ملَّةِ أبينا إبراهيمَ حنيفًا مسلمًا وما كان منَ المشرِكينَ',
    'رضيتُ باللهِ ربًّا وبالإسلامِ دينًا وبمحمَّدٍ صلَّى اللهُ عليه وسلَّم نبيًّا',
    'اللّهمّ ما أصبح بي من نعمة أو بأحد من خلقك، فمنك وحدك لا شريك لك، فلك الحمد ولك الشّكر',
    'بسم الله الذي لا يضرّ مع اسمه شيء في الأرض ولا في السّماء وهو السّميع العليم',
    'اللّهمّ بك أصبحنا وبك أمسينا، وبك نحيا وبك نموت وإليك النّشور',
    'أصبحنا وأصبح الملك لله والحمد لله، لا إله إلاّ اللّه وحده لا شريك له، له الملك وله الحمد وهو على كلّ شيء قدير ربّ أسألك خير ما في هذا اليوم وخير ما بعده، وأعوذ بك من شرّ ما في هذا اليوم وشرّ ما بعده، ربّ أعوذ بك من الكسل وسوء الكبر، ربّ أعوذ بك من عذاب في النّار وعذاب في القبر',
    'اللهم أنت ربي، لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت. أبوء لك بنعمتك علي وأبوء بذنبي فاغفر لي، فإنه لا يغفر الذنوب إلا أنت',
    'اللهمّ إنّي أسألك العافيةَ في الدُنيا والآخرة، اللهمّ إنّي أسألك العفوَ والعافيةَ في ديني ودُنياي وأهلي ومالي، اللهمّ استر عوراتي وآمن رَوْعَاتي، اللهمّ احفظني مِن بين يَدَيَّ ومِن خلفي وعن يميني وعن شمالي ومن فوقي وأعوذُ بعظمتِك أن أُغتاَل مِن تحتي',
    'سُبْحَانَ اللهِ وبِحَمْدِهِ',
    'سُبْحَان الله وبحمده عَدَدَ خَلْقِهِ، ورِضَا نفسه، وزِنَةَ عَرْشِهِ، ومِدَادَ كلماته',
    'يا حيُّ يا قيومُ برحمتك أستغيثُ، وأَصلِحْ لي شأني كلَّه ولا تَكِلْني إلى نفسي طرفَةَ عَينٍ',
    'اللهمّ عافِني في بدني، اللهمّ عافني في سمعي، اللهمّ عافني في بصري، لا إله إلّا أنت',
    'حَسْبِيَ اللَّهُ لَا إِلَٰهَ إِلَّا هو عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',
    'اللَّهُمَّ إنِّي أصبَحتُ أنِّي أُشهِدُك، وأُشهِدُ حَمَلةَ عَرشِكَ، ومَلائِكَتَك، وجميعَ خَلقِكَ: بأنَّك أنتَ اللهُ لا إلهَ إلَّا أنتَ، وَحْدَك لا شريكَ لكَ، وأنَّ مُحمَّدًا عبدُكَ ورسولُكَ',
    'لا إلَه إلَّا اللهُ وحدَه لا شَريكَ له، له المُلكُ وله الحمدُ يُحيِي ويُميتُ وهو على كلِّ شيءٍ قديرٌ',
  ];
  List<String> locNightPraiseslist = [
    "بسمِ اللهِ الذي لا يَضرُ مع اسمِه شيءٌ في الأرضِ ولا في السماءِ وهو السميعُ العليمِ",
    "اللَّهمَّ بِكَ أمسَينا وبِكَ أصبَحنا وبِكَ نحيا وبِكَ نموتُ وإليكَ النُّشورُ.",
    "اللهمَّ إنِّي أعوذُ بك من الهمِّ والحزنِ، والعجزِ والكسلِ، والبُخلِ والجُبنِ، وضَلَعِ الدَّينِ، وغَلَبَةِ الرجالِ.",
    "يا حيُّ يا قيُّومُ، برَحمتِكَ أستَغيثُ، أصلِح لي شأني كُلَّهُ، ولا تَكِلني إلى نَفسي طرفةَ عينٍ.",
    "سُبْحَانَ اللهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ",
    "اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ على نَبِيِّنَا مُحمَّد، فقد جاء في الحديث: مَن صلى عَلَيَّ حين يُصْبِحُ عَشْرًا، وحين يُمْسِي عَشْرًا، أَدْرَكَتْه شفاعتي يومَ القيامةِ",
    "اللَّهُمَّ إنِّي أمسيتُ أُشهِدُك، وأُشهِدُ حَمَلةَ عَرشِكَ، ومَلائِكَتَك، وجميعَ خَلقِكَ: أنَّكَ أنتَ اللهُ لا إلهَ إلَّا أنتَ، وأنَّ مُحمَّدًا عبدُكَ ورسولُكَ",
    " سُبْحَانَ اللهِ وَبِحَمْدِهِ، عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ",
    "اللَّهُمَّ أنْتَ رَبِّي لا إلَهَ إلَّا أنْتَ، خَلَقْتَنِي وأنا عَبْدُكَ، وأنا علَى عَهْدِكَ ووَعْدِكَ ما اسْتَطَعْتُ، أعُوذُ بكَ مِن شَرِّ ما صَنَعْتُ، أبُوءُ لكَ بنِعْمَتِكَ عَلَيَّ، وأَبُوءُ لكَ بذَنْبِي فاغْفِرْ لِي، فإنَّه لا يَغْفِرُ الذُّنُوبَ إلَّا أنْتَ",
    "اللهمَ ما أمسى بي من نعمةٍ أو بأحدٍ من خلقك فمنكَ وحدك لا شريكَ، لك فلك الحمد ولك الشكر",
    "حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم.",
    "أمسينا على فطرة الإسلام، وعلى كلمة الإخلاص، وعلى دين نبيّنا محمّدٍ صلّى الله عليه وسلم",
    "بِاسْمِكَ رَبِّي وَضَعْـت جَنْبي، وَبِكَ أَرْفَعـه، فَإِن أَمْسَـكْتَ نَفْسي فارْحَمْها",
  ];

  count(String zekr, int index) {
    total = total! + 1;
    num = num + 1;
    praiseslist![index][1] = (int.parse(praiseslist![index][1]) + 1).toString();
    countpraise(zekr);
    notifyListeners();
  }

  countpraise2(String zekr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int temp;
    temp = 0;
    List<String> praise = [];
    praise = prefs.getStringList(zekr)!;
    temp = int.parse(praise[1]) + 1;
    prefs.remove(zekr);
    prefs.setStringList(zekr, [zekr, temp.toString(), "0"]);
    notifyListeners();
    return praise;
  }

  count2(String zekr, int index, bool islocal, ismorn) {
    total = total! + 1;
    num = num + 1;
    if (islocal == false) {
      praiseslist![index][1] =
          (int.parse(praiseslist![index][1]) + 1).toString();

      countpraise2(zekr);
    } else {
      if (ismorn == true) {
        countLocMorningPraiseslist[index] =
            countLocMorningPraiseslist[index] + 1;
        countPraiseLocal(zekr);
      } else {
        countlocNightPraiseslist[index] = countlocNightPraiseslist[index] + 1;
        countPraiseLocal(zekr);
      }
    }
    notifyListeners();
  }

  void initLocpriase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (await prefs.containsKey(locNightPraiseslist[1]) == false) {
    for (int i = 0; i < locMorningPraiseslist.length; i++) {
      await prefs.setInt(locMorningPraiseslist[i], 0);
      countLocMorningPraiseslist.add(0);
    }
    for (int i = 0; i < locNightPraiseslist.length; i++) {
      await prefs.setInt(locNightPraiseslist[i], 0);
      countlocNightPraiseslist.add(0);
    }
    //}
  }

  countPraiseLocal(String zekr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int temp = 0;
    temp = await prefs.getInt(zekr)!;
    await prefs.setInt(zekr, temp + 1);
    print(await prefs.getInt(zekr));
    notifyListeners();
  }

  void addPraisesName(String zekr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> praises = [];
    if (await prefs.getStringList("praises") == null) {
      praises.add(zekr);
      await prefs.setStringList("praises", praises);
    } else {
      praises = await prefs.getStringList("praises")!;
      praises.add(zekr);
      await prefs.remove("praises");
      await prefs.setStringList("praises", praises);
    }
  }

  addPraise(String zekr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> alreadyExistingPraises = [];
    if (await prefs.containsKey("praises") == false) {
      addPraisesName(zekr);
      praiseslist?.add([zekr, "0"]);
      await prefs.setStringList(zekr, [zekr, "0"]);
    } else {
      alreadyExistingPraises = await prefs.getStringList("praises")!;
      if (alreadyExistingPraises.contains(zekr)) {
        return print(alreadyexis);
      } else {
        addPraisesName(zekr);
        praiseslist?.add([zekr, "0"]);
        await prefs.setStringList(zekr, [zekr, "0"]);
      }
      notifyListeners();
    }
  }

  void initsomeprefs() async {
    for (int i = 0; i < intFirstPraiseList.length; i++) {
      await addPraise(intFirstPraiseList[i]);
    }
  }

  void getLocpriase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < locMorningPraiseslist.length; i++) {
      countLocMorningPraiseslist
          .add(await prefs.getInt(locMorningPraiseslist[i]));
    }
    for (int i = 0; i < locNightPraiseslist.length; i++) {
      countlocNightPraiseslist.add(await prefs.getInt(locNightPraiseslist[i]));
    }
    print("**************************************");

    print(countLocMorningPraiseslist);
    print("**************************************");

    print(countlocNightPraiseslist);
    print("**************************************");
  }

  countpraise(String zekr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int temp;
    temp = 0;
    List<String> praise = [];
    praise = prefs.getStringList(zekr)!;
    temp = int.parse(praise[1]) + 1;
    prefs.remove(zekr);
    prefs.setStringList(zekr, [zekr, temp.toString(), "0"]);
    notifyListeners();
    return praise;
  }

  void deletepraise(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listpraises = await prefs.getStringList("praises")!;
    listpraises.remove(key);
    await prefs.setStringList("praises", listpraises);
    praiseslist?.removeWhere((element) => element[0] == key);
    notifyListeners();
    await prefs.remove(key);
  }

  Future<List<List<String>>> showallpraises() async {
    List<String>? temp;
    List<String> praisesName = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<List<String>> allpraises = [];
    if (await prefs.getStringList("praises") != null) {
      praisesName = await prefs.getStringList("praises")!;
      // ignore: unnecessary_null_comparison
      if (praisesName != null) {
        for (var element in praisesName) {
          temp = await prefs.getStringList(element)!;
          allpraises.add(temp);
          temp = null;
        }
      } else {
        print("error get all prises name");
      }
      praiseslist = null;
      praiseslist = allpraises;
      notifyListeners();
    }

    return allpraises;
  }

  void reset2(String zekr, int index, bool isLocal, bool ismorning) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isLocal == false) {
      await prefs.setStringList(zekr, [zekr, "0"]);
      praiseslist![index][1] = (0).toString();
    } else {
      await prefs.setInt(zekr, 0);
      if (ismorning == true) {
        countLocMorningPraiseslist[index] = 0;
      } else {
        countlocNightPraiseslist[index] = 0;
      }
    }
    num = 0;
    total = 0;
    notifyListeners();
  }

  void reset(String zekr, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(zekr, [zekr, "0"]);
    praiseslist![index][1] = (0).toString();
    num = 0;
    total = 0;
    notifyListeners();
  }
}

//---------------------------------------------------------------------------------
