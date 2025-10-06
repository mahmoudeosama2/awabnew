import 'package:awab/app/statemanagment/otherProviders.dart';
import 'package:flutter/material.dart';
import 'package:awab/app/pages/quran/surah/view_surah.dart';
import 'package:provider/provider.dart';
import '../../../customewidget/custom_counter.dart';
import '../../../customewidget/customtextField.dart';
import '../../../models/model_complete_quran.dart';
import '../../../services/control_audio.dart';
import '../../../statemanagment/quranProvider.dart';

List<Surahs>? surah;
List<Surahs>? filter;

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});
  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  @override
  void initState() {
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
    var model = Provider.of<Quran>(context);
    var other = Provider.of<Other>(context);
    other.surahMark = 0.0;
    surah ??= model.surahs;
    filter ??= surah;

    double height = MediaQuery.of(context).size.height - 309;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            height: 50,
            margin: const EdgeInsets.only(
              top: 7,
              bottom: 7,
              left: 10,
              right: 10,
            ),
            child: CustomTextField(onchange: (value) => updatelist(value)),
          ),
          SizedBox(
            height: height,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: filter!.length,
                itemBuilder: (context, i) {
                  return List_of_surah(quran: filter![i]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class List_of_surah extends StatelessWidget {
  final quran;

  const List_of_surah({super.key, required this.quran});

  @override
  Widget build(BuildContext context) {
    var other = Provider.of<Other>(context, listen: true);
    return Hero(
      tag: "surah${quran.number}",
      child: Card(
        child: InkWell(
          onTap: () async {
            other.surahMark = 0.0;
            other.getSurahMark(quran.name);
            print(quran.name);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ViewSurah(surah: quran);
                },
              ),
            );
          },
          child: ListTile(
            tileColor: Theme.of(context).scaffoldBackgroundColor,
            trailing: Text(
              quran.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            title: Text(
              quran.englishName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              quran.revelationType,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            leading: CounterIcons(num: quran.number),
          ),
        ),
      ),
    );
  }
}
