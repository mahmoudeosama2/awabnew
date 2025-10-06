import 'package:shared_preferences/shared_preferences.dart';

int? countopen;
String alreadyexis = "Erorr : This Praise Already Existing";
void addPraisesName(String zekr) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> praises = [];
  if (prefs.getStringList("praises") == null) {
    praises.add(zekr);
    prefs.setStringList("praises", praises);
  } else {
    praises = prefs.getStringList("praises")!;
    praises.add(zekr);
    await prefs.remove("praises");
    prefs.setStringList("praises", praises);
  }
}

addPraise(String zekr) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> alreadyExistingPraises = [];
  if (prefs.getStringList("praises") == null) {
    addPraisesName(zekr);
    await prefs.setStringList(zekr, [zekr, "0", "0"]);
  } else {
    alreadyExistingPraises = prefs.getStringList("praises")!;
    if (alreadyExistingPraises.contains(zekr)) {
      return print(alreadyexis);
    } else {
      addPraisesName(zekr);
      prefs.setStringList(zekr, [zekr, "0", "0"]);
    }
  }
}

countpraise(String zekr) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> praise = [];
  praise = prefs.getStringList(zekr)!;
  praise[2] = (int.parse(praise[2]) + 1).toString();
  praise[1] = (int.parse(praise[1]) + 1).toString();
  await prefs.remove(zekr);
  await prefs.setStringList(zekr, praise);
  return praise;
}

void deletepraise(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> listpraises = prefs.getStringList("praises")!;
  listpraises.remove(key);
  prefs.setStringList("praises", listpraises);
  await prefs.remove(key);
}

showpraises(zekr) async {
  List<String> praises = [];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // ignore: unnecessary_null_comparison
  if (prefs.getStringList(zekr)! == null) {
    return null;
  }
  praises = prefs.getStringList(zekr)!;
  return praises;
}

addStringPrefs(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString(key) == false) {
    prefs.setString(key, value);
  } else {
    print("the $key is already exist-------------------------");
  }
}

setBoolPrefs(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(key) == false) {
    prefs.setBool(key, value);
  } else {
    print("the $key is already exist-------------------------");
  }
}

getBoolPrefs(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(key) == true) {
    print("in function trueeeeeeeeeeeeeeeeeeeeee");
    return true;
  } else if (prefs.getBool(key) == false) {
    print("in function falseeeeeeeeeeeeeeeeeeeeeeeeeee");

    return false;
  }
}

changeBoolPrefs(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}


