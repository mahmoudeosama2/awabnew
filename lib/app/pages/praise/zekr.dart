import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../../statemanagment/praiseProvider.dart';

int? num;
int? totalcount;
String? _text;
ArabicNumbers arabicNumbers = ArabicNumbers();

class ContZekr extends StatefulWidget {
  final zekr;
  final index;
  final bool locOrOnlin;
  final bool? ismor;
  const ContZekr({
    super.key,
    required this.zekr,
    this.index,
    required this.locOrOnlin,
    this.ismor,
  });

  @override
  State<ContZekr> createState() => _ContZekrtate();
}

class _ContZekrtate extends State<ContZekr> {
  @override
  @override
  @override
  void initState() {
    super.initState();
    if (widget.locOrOnlin == false) {
      totalcount = int.tryParse(widget.zekr[1].toString()) ?? 0;
    }
    // تأكد من تحميل البيانات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Praise>(context, listen: false).loadAzkarFromJson();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var model = Provider.of<Praise>(context);
    return WillPopScope(
      onWillPop: () async {
        model.num = 0;
        return true;
      },
      child: WillPopScope(
        onWillPop: () async {
          if (widget.locOrOnlin == true) {
            Navigator.pop(context);
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop();
          }
          return true;
        },
        child: Scaffold(
          floatingActionButton: SpeedDial(
            closedForegroundColor: Theme.of(context).primaryColor,
            openForegroundColor: Colors.white,
            closedBackgroundColor: Colors.white,
            openBackgroundColor: Theme.of(context).primaryColor,
            labelsBackgroundColor: Colors.white,
            labelsStyle: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontFamily: ""),
            speedDialChildren: <SpeedDialChild>[
              SpeedDialChild(
                child: Icon(Icons.restore_rounded),
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                label: 'البدء من جديد',
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    btnOkColor: Theme.of(context).primaryColor,
                    dialogType: DialogType.infoReverse,
                    animType: AnimType.scale,
                    descTextStyle: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontFamily: ""),
                    title: "تنبيه",
                    desc: "هل تريد إعاده البدء من جديد",
                    btnCancelText: "لا",
                    btnOkText: "نعم",
                    btnOkOnPress: () {
                      widget.locOrOnlin == false
                          ? model.reset(widget.zekr[0], widget.index)
                          : model.reset2(widget.zekr, widget.index, true, true);
                    },
                    btnCancelOnPress: () {},
                  ).show();
                },
                closeSpeedDialOnPressed: false,
              ),

              //  Your other SpeedDialChildren go here.
            ],
            child: const Icon(Icons.settings),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            toolbarHeight: height,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              SizedBox(
                width: width,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Image.asset(
                                "asset/icons/prayer.png",
                                color: Colors.grey.withOpacity(0.5),
                                colorBlendMode: BlendMode.modulate,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                          bottom: 210,
                          left: 15,
                          right: 15,
                          top: 15,
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            widget.locOrOnlin == false
                                ? widget.zekr[0]
                                : widget.zekr,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              height: 1.8,
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (widget.locOrOnlin == true) {
                                  Navigator.pop(context);
                                  Navigator.of(context).pop();
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                              ),
                            ),
                            Text(
                              "العدد  : ${arabicNumbers.convert(model.num)}",
                              style: Theme.of(context).textTheme.headlineMedium!
                                  .copyWith(fontFamily: "", fontSize: 16),
                            ),
                            Text(
                              "إجمالي العدد : ${arabicNumbers.convert(model.total)}",
                              style: Theme.of(context).textTheme.headlineMedium!
                                  .copyWith(fontFamily: "", fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        width: width,
                        height: height,
                        child: InkWell(
                          onTap: () {
                            widget.locOrOnlin == false
                                ? model.count(widget.zekr[0], widget.index)
                                : model.count2(
                                    widget.zekr,
                                    widget.index,
                                    true,
                                    widget.ismor!,
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
