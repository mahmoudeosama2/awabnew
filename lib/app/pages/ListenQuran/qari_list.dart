import 'package:flutter/material.dart';
import 'package:awab/app/pages/ListenQuran/quran_list_audio.dart';
import 'package:provider/provider.dart';
import '../../customewidget/customtextField.dart';
import '../../models/model_quran_reader.dart';
import '../../statemanagment/quranProvider.dart';

List<Qari>? quranreader;
List<Qari>? filter;

class QariList extends StatefulWidget {
  const QariList({super.key});
  @override
  State<QariList> createState() => _QariListState();
}

class _QariListState extends State<QariList> {
  void updatelist(String value) {
    setState(() {
      filter = quranreader
          ?.where(
            (element) =>
                element.arabicName!.toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<Quran>(context);
    quranreader ??= model.quranreader;
    filter ??= quranreader;

    double height = MediaQuery.of(context).size.height - 230;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: CustomTextField(onchange: (value) => updatelist(value)),
            ),
            SizedBox(
              height: height,
              child: ListView.builder(
                itemCount: filter!.length,
                itemBuilder: (context, i) {
                  return ListTileQuranReader(
                    readerinformation: filter![i],
                    indx: i,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListTileQuranReader extends StatelessWidget {
  final Qari readerinformation;
  final int indx;
  const ListTileQuranReader({
    super.key,
    required this.readerinformation,
    required this.indx,
  });
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<Quran>(context);

    return Card(
      child: InkWell(
        onTap: () async {
          model.relvaationreader = "${readerinformation.relativePath}";
          model.qariname =
              readerinformation.arabicName ?? readerinformation.name;
          model.indexQari = indx;
          // model.listClear();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const QuranListAudio();
              },
            ),
          );
        },
        child: ListTile(
          tileColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "${readerinformation.arabicName ?? readerinformation.name}",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ),
    );
  }
}
