import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/notification_service.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _quranReminderEnabled = false;
  bool _morningAzkarEnabled = false;
  bool _eveningAzkarEnabled = false;
  bool _adhanEnabled = false;

  TimeOfDay _quranReminderTime = const TimeOfDay(hour: 20, minute: 0);
  TimeOfDay _morningAzkarTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _eveningAzkarTime = const TimeOfDay(hour: 18, minute: 0);

  Map<String, bool> _prayerAdhanSettings = {
    'الفجر': true,
    'الظهر': true,
    'العصر': true,
    'المغرب': true,
    'العشاء': true,
  };

  String _selectedMuezzin = 'الحصري';
  final List<String> _muezzinList = [
    'الحصري',
    'عبد الباسط',
    'العفاسي',
    'السديس',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _quranReminderEnabled = prefs.getBool('quran_reminder_enabled') ?? false;
      _morningAzkarEnabled = prefs.getBool('morning_azkar_enabled') ?? false;
      _eveningAzkarEnabled = prefs.getBool('evening_azkar_enabled') ?? false;
      _adhanEnabled = prefs.getBool('adhan_enabled') ?? false;

      final quranHour = prefs.getInt('quran_reminder_hour') ?? 20;
      final quranMinute = prefs.getInt('quran_reminder_minute') ?? 0;
      _quranReminderTime = TimeOfDay(hour: quranHour, minute: quranMinute);

      final morningHour = prefs.getInt('morning_azkar_hour') ?? 7;
      final morningMinute = prefs.getInt('morning_azkar_minute') ?? 0;
      _morningAzkarTime = TimeOfDay(hour: morningHour, minute: morningMinute);

      final eveningHour = prefs.getInt('evening_azkar_hour') ?? 18;
      final eveningMinute = prefs.getInt('evening_azkar_minute') ?? 0;
      _eveningAzkarTime = TimeOfDay(hour: eveningHour, minute: eveningMinute);

      _selectedMuezzin = prefs.getString('selected_muezzin') ?? 'الحصري';

      _prayerAdhanSettings.forEach((key, value) {
        _prayerAdhanSettings[key] =
            prefs.getBool('adhan_$key') ?? true;
      });
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('quran_reminder_enabled', _quranReminderEnabled);
    await prefs.setBool('morning_azkar_enabled', _morningAzkarEnabled);
    await prefs.setBool('evening_azkar_enabled', _eveningAzkarEnabled);
    await prefs.setBool('adhan_enabled', _adhanEnabled);

    await prefs.setInt('quran_reminder_hour', _quranReminderTime.hour);
    await prefs.setInt('quran_reminder_minute', _quranReminderTime.minute);
    await prefs.setInt('morning_azkar_hour', _morningAzkarTime.hour);
    await prefs.setInt('morning_azkar_minute', _morningAzkarTime.minute);
    await prefs.setInt('evening_azkar_hour', _eveningAzkarTime.hour);
    await prefs.setInt('evening_azkar_minute', _eveningAzkarTime.minute);

    await prefs.setString('selected_muezzin', _selectedMuezzin);

    _prayerAdhanSettings.forEach((key, value) async {
      await prefs.setBool('adhan_$key', value);
    });

    _scheduleNotifications();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم حفظ الإعدادات بنجاح ✓',
          style: TextStyle(fontFamily: 'Amiri'),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _scheduleNotifications() {
    final notificationService = NotificationService();

    if (_quranReminderEnabled) {
      notificationService.scheduleDailyQuranReminder(
        _quranReminderTime.hour,
        _quranReminderTime.minute,
      );
    } else {
      notificationService.cancelNotification(0);
    }

    if (_morningAzkarEnabled) {
      notificationService.scheduleMorningAzkarReminder(
        _morningAzkarTime.hour,
        _morningAzkarTime.minute,
      );
    } else {
      notificationService.cancelNotification(1);
    }

    if (_eveningAzkarEnabled) {
      notificationService.scheduleEveningAzkarReminder(
        _eveningAzkarTime.hour,
        _eveningAzkarTime.minute,
      );
    } else {
      notificationService.cancelNotification(2);
    }
  }

  Future<void> _selectTime(BuildContext context, String type) async {
    TimeOfDay currentTime;

    switch (type) {
      case 'quran':
        currentTime = _quranReminderTime;
        break;
      case 'morning':
        currentTime = _morningAzkarTime;
        break;
      case 'evening':
        currentTime = _eveningAzkarTime;
        break;
      default:
        currentTime = TimeOfDay.now();
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        switch (type) {
          case 'quran':
            _quranReminderTime = picked;
            break;
          case 'morning':
            _morningAzkarTime = picked;
            break;
          case 'evening':
            _eveningAzkarTime = picked;
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'إعدادات التذكيرات',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildQuranReminderCard(),
          const SizedBox(height: 16),
          _buildAzkarRemindersCard(),
          const SizedBox(height: 16),
          _buildAdhanSettingsCard(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildQuranReminderCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.book,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'تذكير قراءة القرآن',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: _quranReminderEnabled,
                  onChanged: (value) {
                    setState(() {
                      _quranReminderEnabled = value;
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
            if (_quranReminderEnabled) ...[
              const Divider(height: 32),
              ListTile(
                title: const Text(
                  'الوقت',
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _quranReminderTime.format(context),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                onTap: () => _selectTime(context, 'quran'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAzkarRemindersCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.wb_sunny, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                const Text(
                  'تذكير الأذكار',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAzkarReminderItem(
              'أذكار الصباح',
              Icons.wb_sunny_outlined,
              Colors.amber,
              _morningAzkarEnabled,
              (value) {
                setState(() {
                  _morningAzkarEnabled = value;
                });
              },
              _morningAzkarTime,
              () => _selectTime(context, 'morning'),
            ),
            const Divider(height: 32),
            _buildAzkarReminderItem(
              'أذكار المساء',
              Icons.nightlight_round,
              Colors.indigo,
              _eveningAzkarEnabled,
              (value) {
                setState(() {
                  _eveningAzkarEnabled = value;
                });
              },
              _eveningAzkarTime,
              () => _selectTime(context, 'evening'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAzkarReminderItem(
    String title,
    IconData icon,
    Color color,
    bool enabled,
    Function(bool) onChanged,
    TimeOfDay time,
    VoidCallback onTimeTap,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                ),
              ),
            ),
            Switch(
              value: enabled,
              onChanged: onChanged,
              activeColor: color,
            ),
          ],
        ),
        if (enabled)
          Padding(
            padding: const EdgeInsets.only(right: 36, top: 8),
            child: GestureDetector(
              onTap: onTimeTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 16, color: color),
                    const SizedBox(width: 8),
                    Text(
                      time.format(context),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAdhanSettingsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.mosque, color: Colors.green),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'إعدادات الأذان',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: _adhanEnabled,
                  onChanged: (value) {
                    setState(() {
                      _adhanEnabled = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
            if (_adhanEnabled) ...[
              const Divider(height: 32),
              const Text(
                'تفعيل الأذان للصلوات:',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ..._prayerAdhanSettings.entries.map((entry) {
                return CheckboxListTile(
                  title: Text(
                    entry.key,
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 16),
                  ),
                  value: entry.value,
                  onChanged: (value) {
                    setState(() {
                      _prayerAdhanSettings[entry.key] = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }),
              const Divider(height: 32),
              const Text(
                'اختيار المؤذن:',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _muezzinList.map((muezzin) {
                  final isSelected = _selectedMuezzin == muezzin;
                  return ChoiceChip(
                    label: Text(
                      muezzin,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedMuezzin = muezzin;
                      });
                    },
                    selectedColor: Colors.green,
                    backgroundColor: Colors.grey.shade200,
                    elevation: isSelected ? 4 : 0,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
