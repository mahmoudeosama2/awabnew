import 'package:flutter/material.dart';
import 'package:awab/app/pages/quran/surah/quran_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // const HomePage({super.key});
  // data = getdata();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 245;
    return DefaultTabController(
      length: 1,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  child: Text(
                    "القرءان الكريم",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height,
              child: Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                appBar: AppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shadowColor: Colors.white,
                  elevation: 0,
                  toolbarHeight: 0,
                ),
                body: Container(
                  child: const TabBarView(children: [QuranScreen()]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
