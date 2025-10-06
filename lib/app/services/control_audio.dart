import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

AudioPlayer player = AudioPlayer();

//AudioElement? audio;

bool status = false;
bool tempThen = false;
bool? chngcoloror;
bool? isplayedfm;
removebasmal(String word) {
  String result = word.replaceAll("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "");
  result = word.replaceAll("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "");
  if (result.length < 2) {
    return null;
  } else {
    return result;
  }
}

void onEnded() {
  print('The sound has ended.');
}

Future getaudio(url) async {
  await player
      .play(UrlSource(url))
      .whenComplete(() => print("whennn completeeeeeeeeeeeeeeeeeee"));
  // await player
  //     .play(UrlSource(url))
  //     .then((value) => print("then completeeeeeeeeeeeeeeeeeee"));
}

chngcol() {
  chngcoloror = false;
}

void audiodisbose() async {
  if (status == true) {
    await player.dispose();
    status = false;
  }
}

void disboseForce() async {
  await player.dispose();
}

Future pauseaudio() async {
  await player.pause();
}

removetachkil(var str) {
  List tachkil = ['ِ', 'ُ', 'ٓ', 'ٰ', 'ْ', 'ٌ', 'ٍ', 'ً', 'ّ', 'َ', ' ّ'];

  for (var element in tachkil) {
    str = str.replaceAll(element, "");
  }
  return str;
}

setprefs(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

setprefsbool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

getprefs(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(key)) {
    return prefs.getBool(key);
  }
}
