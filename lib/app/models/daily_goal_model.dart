import 'package:hive/hive.dart';

part 'daily_goal_model.g.dart';

@HiveType(typeId: 0)
class DailyGoalModel extends HiveObject {
  @HiveField(0)
  late int goalPages;

  @HiveField(1)
  late int goalAyahs;

  @HiveField(2)
  late Map<String, int> dailyProgress;

  @HiveField(3)
  late int currentStreak;

  @HiveField(4)
  late int longestStreak;

  @HiveField(5)
  late String lastReadDate;

  @HiveField(6)
  late int totalPagesRead;

  @HiveField(7)
  late int totalAyahsRead;

  DailyGoalModel({
    this.goalPages = 5,
    this.goalAyahs = 50,
    Map<String, int>? dailyProgress,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastReadDate = '',
    this.totalPagesRead = 0,
    this.totalAyahsRead = 0,
  }) : dailyProgress = dailyProgress ?? {};
}

@HiveType(typeId: 1)
class ReadingSession extends HiveObject {
  @HiveField(0)
  late String date;

  @HiveField(1)
  late int pagesRead;

  @HiveField(2)
  late int ayahsRead;

  @HiveField(3)
  late int durationMinutes;

  @HiveField(4)
  late String surahName;

  @HiveField(5)
  late int surahNumber;

  ReadingSession({
    required this.date,
    required this.pagesRead,
    required this.ayahsRead,
    required this.durationMinutes,
    required this.surahName,
    required this.surahNumber,
  });
}
