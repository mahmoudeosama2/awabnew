import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../services/notification_service.dart';

class ReminderModel {
  final int id;
  final String type;
  final TimeOfDay time;
  bool isActive;

  ReminderModel({
    required this.id,
    required this.type,
    required this.time,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'time': '${time.hour}:${time.minute}',
        'isActive': isActive,
      };

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    final timeParts = json['time'].split(':');
    return ReminderModel(
      id: json['id'],
      type: json['type'],
      time: TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1])),
      isActive: json['isActive'] ?? true,
    );
  }
}

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _quranReminderEnabled = false;
  bool _adhanEnabled = false;

  TimeOfDay _quranReminderTime = const TimeOfDay(hour: 20, minute: 0);

  List<ReminderModel> morningReminders = [];
  List<ReminderModel> eveningReminders = [];

  final Map<String, bool> _prayerAdhanSettings = {
    'الفجر': true,
    'الظهر': true,
    'العصر': true,
    'المغرب': true,
    'العشاء': true,
  };

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _quranReminderEnabled = prefs.getBool('quran_reminder_enabled') ?? false;
      _adhanEnabled = prefs.getBool('adhan_enabled') ?? false;

      final quranHour = prefs.getInt('quran_reminder_hour') ?? 20;
      final quranMinute = prefs.getInt('quran_reminder_minute') ?? 0;
      _quranReminderTime = TimeOfDay(hour: quranHour, minute: quranMinute);

      final morningData = prefs.getString('morning_reminders');
      if (morningData != null) {
        final List decoded = json.decode(morningData);
        morningReminders =
            decoded.map((e) => ReminderModel.fromJson(e)).toList();
      }

      final eveningData = prefs.getString('evening_reminders');
      if (eveningData != null) {
        final List decoded = json.decode(eveningData);
        eveningReminders =
            decoded.map((e) => ReminderModel.fromJson(e)).toList();
      }

      _prayerAdhanSettings.forEach((key, value) {
        _prayerAdhanSettings[key] = prefs.getBool('adhan_$key') ?? true;
      });
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('quran_reminder_enabled', _quranReminderEnabled);
    await prefs.setBool('adhan_enabled', _adhanEnabled);

    await prefs.setInt('quran_reminder_hour', _quranReminderTime.hour);
    await prefs.setInt('quran_reminder_minute', _quranReminderTime.minute);

    await prefs.setString('morning_reminders',
        json.encode(morningReminders.map((e) => e.toJson()).toList()));
    await prefs.setString('evening_reminders',
        json.encode(eveningReminders.map((e) => e.toJson()).toList()));

    _prayerAdhanSettings.forEach((key, value) async {
      await prefs.setBool('adhan_$key', value);
    });

    _scheduleNotifications();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'تم حفظ الإعدادات بنجاح ✓',
            style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.all(20),
        ),
      );
    }
  }

  void _scheduleNotifications() {
    if (_quranReminderEnabled) {
      _notificationService.scheduleDailyQuranReminder(
        _quranReminderTime.hour,
        _quranReminderTime.minute,
      );
    } else {
      _notificationService.cancelNotification(0);
    }

    for (var reminder in morningReminders) {
      if (reminder.isActive) {
        _notificationService.scheduleMorningAzkarReminder(
          reminder.time.hour,
          reminder.time.minute,
          reminder.id,
        );
      }
    }

    for (var reminder in eveningReminders) {
      if (reminder.isActive) {
        _notificationService.scheduleEveningAzkarReminder(
          reminder.time.hour,
          reminder.time.minute,
          reminder.id,
        );
      }
    }
  }

  void _showAddReminderDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => _AddReminderDialog(
        type: type,
        onAdd: (time) {
          setState(() {
            if (type == 'morning') {
              final id = 100 + morningReminders.length;
              morningReminders
                  .add(ReminderModel(id: id, type: type, time: time));
              _notificationService.scheduleMorningAzkarReminder(
                  time.hour, time.minute, id);
            } else {
              final id = 200 + eveningReminders.length;
              eveningReminders
                  .add(ReminderModel(id: id, type: type, time: time));
              _notificationService.scheduleEveningAzkarReminder(
                  time.hour, time.minute, id);
            }
          });
          _saveSettings();
        },
      ),
    );
  }

  void _toggleReminder(ReminderModel reminder) async {
    setState(() {
      reminder.isActive = !reminder.isActive;
    });

    if (reminder.isActive) {
      if (reminder.type == 'morning') {
        await _notificationService.scheduleMorningAzkarReminder(
          reminder.time.hour,
          reminder.time.minute,
          reminder.id,
        );
      } else {
        await _notificationService.scheduleEveningAzkarReminder(
          reminder.time.hour,
          reminder.time.minute,
          reminder.id,
        );
      }
    } else {
      await _notificationService.cancelNotification(reminder.id);
    }
    _saveSettings();
  }

  void _deleteReminder(ReminderModel reminder) async {
    await _notificationService.cancelNotification(reminder.id);
    setState(() {
      if (reminder.type == 'morning') {
        morningReminders.remove(reminder);
      } else {
        eveningReminders.remove(reminder);
      }
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor,
              primaryColor.withOpacity(0.8),
              primaryColor.withOpacity(0.6),
              primaryColor.withOpacity(0.4),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildQuranReminderCard(),
                      const SizedBox(height: 20),
                      _buildAzkarRemindersCard(),
                      const SizedBox(height: 20),
                      _buildAdhanSettingsCard(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveSettings,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.save, color: Colors.white),
        label: Text(
          'حفظ الإعدادات',
          style: theme.textTheme.displayLarge?.copyWith(fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          Expanded(
            child: Text(
              'إعدادات التذكيرات',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineLarge,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildQuranReminderCard() {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(isDark ? 0.2 : 0.1),
            theme.scaffoldBackgroundColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.book, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'تذكير قراءة القرآن',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Switch(
                value: _quranReminderEnabled,
                onChanged: (value) {
                  setState(() {
                    _quranReminderEnabled = value;
                  });
                },
                activeColor: primaryColor,
              ),
            ],
          ),
          if (_quranReminderEnabled) ...[
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _quranReminderTime,
                  builder: (context, child) {
                    return Theme(
                      data: theme.copyWith(
                        colorScheme: ColorScheme.light(
                          primary: primaryColor,
                          onPrimary: Colors.white,
                        ),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: child!,
                      ),
                    );
                  },
                );
                if (time != null) {
                  setState(() => _quranReminderTime = time);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: primaryColor,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, color: primaryColor, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      '${_quranReminderTime.hour.toString().padLeft(2, '0')}:${_quranReminderTime.minute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAzkarRemindersCard() {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(isDark ? 0.2 : 0.1),
            theme.scaffoldBackgroundColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_stories,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Text(
                'تذكيرات الأذكار',
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAzkarSection('أذكار الصباح ☀️', 'morning', morningReminders),
          const SizedBox(height: 20),
          _buildAzkarSection('أذكار المساء 🌙', 'evening', eveningReminders),
        ],
      ),
    );
  }

  Widget _buildAzkarSection(
      String title, String type, List<ReminderModel> reminders) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
            InkWell(
              onTap: () => _showAddReminderDialog(type),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 16),
                    SizedBox(width: 5),
                    Text(
                      'إضافة',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (reminders.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'لا توجد تذكيرات',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.textTheme.titleMedium?.color?.withOpacity(0.5),
                ),
              ),
            ),
          )
        else
          ...reminders.map((reminder) => _buildReminderItem(reminder)),
      ],
    );
  }

  Widget _buildReminderItem(ReminderModel reminder) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: reminder.isActive
            ? theme.scaffoldBackgroundColor
            : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: reminder.isActive
              ? primaryColor.withOpacity(0.3)
              : Colors.grey.shade400,
        ),
      ),
      child: Row(
        children: [
          Icon(
            reminder.type == 'morning' ? Icons.wb_sunny : Icons.nights_stay,
            color: reminder.isActive
                ? primaryColor
                : Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${reminder.time.hour.toString().padLeft(2, '0')}:${reminder.time.minute.toString().padLeft(2, '0')}',
              style: theme.textTheme.titleLarge?.copyWith(
                color: reminder.isActive
                    ? null
                    : Colors.grey.shade500,
              ),
            ),
          ),
          Switch(
            value: reminder.isActive,
            onChanged: (_) => _toggleReminder(reminder),
            activeColor: primaryColor,
          ),
          IconButton(
            onPressed: () => _deleteReminder(reminder),
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildAdhanSettingsCard() {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(isDark ? 0.2 : 0.1),
            theme.scaffoldBackgroundColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.mosque, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'إعدادات الأذان',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Switch(
                value: _adhanEnabled,
                onChanged: (value) {
                  setState(() {
                    _adhanEnabled = value;
                  });
                },
                activeColor: primaryColor,
              ),
            ],
          ),
          if (_adhanEnabled) ...[
            const SizedBox(height: 20),
            Text(
              'تفعيل الأذان للصلوات:',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ..._prayerAdhanSettings.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: entry.value
                      ? primaryColor.withOpacity(isDark ? 0.2 : 0.1)
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: entry.value,
                      onChanged: (value) {
                        setState(() {
                          _prayerAdhanSettings[entry.key] = value ?? false;
                        });
                      },
                      activeColor: primaryColor,
                    ),
                    Text(
                      entry.key,
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.volume_up, color: primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'سيتم تشغيل الأذان تلقائيًا من الملف الصوتي المسجل',
                      style: theme.textTheme.titleSmall?.copyWith(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddReminderDialog extends StatefulWidget {
  final String type;
  final Function(TimeOfDay) onAdd;

  const _AddReminderDialog({required this.type, required this.onAdd});

  @override
  State<_AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<_AddReminderDialog> {
  TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withOpacity(isDark ? 0.3 : 0.2),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.7)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.type == 'morning' ? Icons.wb_sunny : Icons.nights_stay,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.type == 'morning'
                  ? 'إضافة تذكير صباحي'
                  : 'إضافة تذكير مسائي',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                  builder: (context, child) {
                    return Theme(
                      data: theme.copyWith(
                        colorScheme: ColorScheme.light(
                          primary: primaryColor,
                          onPrimary: Colors.white,
                        ),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: child!,
                      ),
                    );
                  },
                );
                if (time != null) {
                  setState(() => selectedTime = time);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: primaryColor, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, color: primaryColor, size: 30),
                    const SizedBox(width: 15),
                    Text(
                      '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'إلغاء',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onAdd(selectedTime);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'إضافة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Amiri',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}