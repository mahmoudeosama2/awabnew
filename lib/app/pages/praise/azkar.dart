import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:awab/app/pages/praise/zekr.dart';
import 'package:awab/app/statemanagment/otherProviders.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../statemanagment/praiseProvider.dart';

var whereempty;
String? newpraise;
ArabicNumbers arabicNumber = ArabicNumbers();

class AzkarHome extends StatefulWidget {
  final totalzekr;
  const AzkarHome({super.key, this.totalzekr});

  @override
  State<AzkarHome> createState() => _PraiseState();
}

class _PraiseState extends State<AzkarHome> {
  final GlobalKey<FormState> _globalKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Praise>(context, listen: false).loadAzkarFromJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<Praise>(context);
    var other = Provider.of<Other>(context);

    String? selectedValue;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              backgroundColor: Colors.white,
              context: context,
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Form(
                  key: _globalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 3),
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: TextFormField(
                          style: Theme.of(
                            context,
                          ).textTheme.displaySmall?.copyWith(fontFamily: ""),
                          cursorColor: const Color(0xff095263),
                          onSaved: (newValue) {
                            newpraise = newValue!;
                          },
                          textAlign: TextAlign.center,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: '   أسم الإستغفار   ',

                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xff095263),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xff095263),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            _globalKey.currentState!.save();

                            model.addPraise(newpraise!);

                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text(
                            "حفظ",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 90),
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          SizedBox(width: 4),
                          Container(
                            child: Text(
                              'اذكار المساء',
                              style: Theme.of(context).textTheme.displayLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: model.eveningAzkarList
                          .map(
                            (String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width) -
                                          100,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                ),
                                          ),
                                          onPressed: () {
                                            // model.total = int.parse(
                                            //     model.praiseslist![1][1]);
                                            model.num = 0;
                                            model.total =
                                                model
                                                    .countlocNightPraiseslist[model
                                                    .eveningAzkarList
                                                    .indexOf(item)];

                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return ContZekr(
                                                    ismor: false,
                                                    zekr: item,
                                                    index: model
                                                        .eveningAzkarList
                                                        .indexOf(item),
                                                    locOrOnlin: true,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Text(
                                            item,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.headlineMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 40,
                                      child: Text(
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontFamily: "",
                                        ),
                                        arabicNumber.convert(
                                          model.countlocNightPraiseslist[model
                                              .eveningAzkarList
                                              .indexOf(item)],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 160,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black26),
                          color: Theme.of(context).primaryColor,
                        ),
                        elevation: 2,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          size: 20,
                          Icons.keyboard_arrow_down_outlined,
                        ),
                        iconSize: 14,
                        iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 350,
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Theme.of(context).primaryColor,
                        ),
                        offset: const Offset(-20, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: WidgetStateProperty.all(6),
                          thumbVisibility: WidgetStateProperty.all(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 50,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ),
                // InkWell(
                //     onTap: () async {
                //       //model.checkFoundPrefs("praises");
                //       //ge();
                //      // other.clearAllPrefs();
                //     },
                //     child: Container(
                //         color: Colors.red,
                //         width: 50,
                //         height: 50,
                //         child: Text(
                //           "sda",
                //           style: TextStyle(color: Colors.black),
                //         ))),
                Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          SizedBox(width: 4),
                          Container(
                            child: Text(
                              'اذكار الصباح',
                              style: Theme.of(context).textTheme.displayLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      items: model.morningAzkarList
                          .map(
                            (String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width) -
                                          100,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                ),
                                          ),
                                          onPressed: () {
                                            // model.total = int.parse(
                                            //     model.praiseslist![1][1]);
                                            model.num = 0;
                                            model.total =
                                                model
                                                    .countLocMorningPraiseslist[model
                                                    .morningAzkarList
                                                    .indexOf(item)];

                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return ContZekr(
                                                    ismor: true,
                                                    zekr: item,
                                                    index: model
                                                        .morningAzkarList
                                                        .indexOf(item),
                                                    locOrOnlin: true,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Text(
                                            item,
                                            textAlign: TextAlign.start,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.headlineMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 40,
                                      child: Text(
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontFamily: "",
                                        ),
                                        arabicNumber.convert(
                                          model.countLocMorningPraiseslist[model
                                              .morningAzkarList
                                              .indexOf(item)],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 160,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black26),
                          color: Theme.of(context).primaryColor,
                        ),
                        elevation: 2,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          size: 20,
                          Icons.keyboard_arrow_down_outlined,
                        ),
                        iconSize: 14,
                        iconEnabledColor: Color.fromARGB(255, 255, 255, 255),
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 350,
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Theme.of(context).primaryColor,
                        ),
                        offset: const Offset(-20, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(14),
                          thickness: WidgetStateProperty.all(6),
                          thumbVisibility: WidgetStateProperty.all(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 50,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height - 70 - 150,
            alignment: Alignment.topCenter,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: model.praiseslist!.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: double.infinity,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        onLongPress: () {
                          AwesomeDialog(
                            descTextStyle: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(fontFamily: ""),
                            context: context,
                            btnOkColor: Theme.of(context).primaryColor,
                            dialogType: DialogType.question,
                            btnCancelText: "لا",
                            btnOkText: "نعم",
                            animType: AnimType.scale,
                            desc: 'هل تريد حذف التسبيح ؟',
                            btnOkOnPress: () {
                              model.deletepraise(model.praiseslist![index][0]);
                            },
                            btnCancelOnPress: () {},
                          ).show();
                        },
                        onTap: () {
                          model.num = 0;
                          model.total = int.parse(model.praiseslist![index][1]);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return ContZekr(
                                  zekr: model.praiseslist![index],
                                  index: index,
                                  locOrOnlin: false,
                                  ismor: true,
                                );
                              },
                            ),
                          );
                        },
                        tileColor: Theme.of(context).primaryColor,
                        title: Text(
                          textDirection: TextDirection.rtl,
                          model.praiseslist![index][0],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge?.copyWith(fontSize: 13),
                        ),
                        leading: Text(
                          arabicNumber.convert(model.praiseslist![index][1]),
                          style: Theme.of(
                            context,
                          ).textTheme.displayLarge!.copyWith(fontFamily: ""),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
