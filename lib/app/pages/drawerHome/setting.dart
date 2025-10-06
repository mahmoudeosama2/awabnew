import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awab/app/statemanagment/otherProviders.dart';
import 'package:workmanager/workmanager.dart';
import '../../../start/splashscreen.dart';
import '../../customewidget/CustomAppBarwithIcon.dart';
import '../../services/sharedprefrances.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    var other = Provider.of<Other>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          CustomAppBarWithIcon(icon: Icons.settings),
          Container(
            //  color: Colors.red,
            child: ListTile(
              // isThreeLine: true,
              trailing: Text(
                "تشغيل الاشعارات",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontFamily: ""),
              ),

              leading: Switch(
                activeThumbColor: Colors.white,
                activeTrackColor: Theme.of(context).primaryColor,
                value: other.isSwitchedNotificatio,
                onChanged: (value) {
                  setState(() {
                    if (other.isSwitchedNotificatio == true) {
                      changeBoolPrefs("notificationSwitch", false);

                      Workmanager().cancelAll();
                      other.isSwitchedNotificatio = false;
                    } else if (other.isSwitchedNotificatio == false) {
                      Workmanager().initialize(callbackDispatcher);

                      Workmanager().registerPeriodicTask(
                        "1",
                        "",
                        frequency: const Duration(minutes: 15),
                      );
                      changeBoolPrefs("notificationSwitch", true);
                      other.isSwitchedNotificatio = true;
                    }
                  });
                },
              ),
            ),
          ),
          Container(
            //  color: Colors.red,
            child: ListTile(
              // isThreeLine: true,
              trailing: Text(
                "الوضع المظلم",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontFamily: ""),
              ),

              leading: Switch(
                activeThumbColor: Colors.white,
                activeTrackColor: Theme.of(context).primaryColor,
                value: other.themeMode,
                onChanged: (value) {
                  setState(() {
                    if (other.themeMode == true) {
                      changeBoolPrefs("thememode", false);
                      other.changeTheme();
                      other.themeMode = false;
                    } else if (other.themeMode == false) {
                      changeBoolPrefs("thememode", true);
                      other.changeTheme();
                      other.themeMode = true;
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
