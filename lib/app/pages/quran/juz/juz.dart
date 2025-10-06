import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/model_complete_quran.dart';
import '../../../statemanagment/quranProvider.dart';

List<Surahs>? surahs;
List<Ayahs>? ayahs;
List<List<String>> agzaa = [];

class ListJuz extends StatefulWidget {
  final int num;
  const ListJuz({super.key, required this.num});

  @override
  State<ListJuz> createState() => _ListJuzState();
}

class _ListJuzState extends State<ListJuz> {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<Quran>(context);
    surahs = model.surahs;

    return InkWell(
      // onTap: () {
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) {
      //       return ViewJuz(surahs: surahs,ayahs : );
      //     },
      //   )
      //   );
      // },
      child: Container(
        height: 40,
        width: 40,
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Text(
            "$num",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: "Amiri",
            ),
          ),
        ),
      ),
    );
  }
}
