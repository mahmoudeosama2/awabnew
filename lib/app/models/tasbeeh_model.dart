import 'package:hive/hive.dart';

part 'tasbeeh_model.g.dart';

@HiveType(typeId: 2)
class TasbeehSession extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String date;

  @HiveField(2)
  late int count;

  @HiveField(3)
  late String zekrType;

  @HiveField(4)
  late String timestamp;

  TasbeehSession({
    required this.id,
    required this.date,
    required this.count,
    required this.zekrType,
    required this.timestamp,
  });
}

@HiveType(typeId: 3)
class TasbeehStats extends HiveObject {
  @HiveField(0)
  late int totalCount;

  @HiveField(1)
  late Map<String, int> dailyStats;

  @HiveField(2)
  late Map<String, int> weeklyStats;

  @HiveField(3)
  late Map<String, int> monthlyStats;

  @HiveField(4)
  late String lastUpdateDate;

  TasbeehStats({
    this.totalCount = 0,
    Map<String, int>? dailyStats,
    Map<String, int>? weeklyStats,
    Map<String, int>? monthlyStats,
    this.lastUpdateDate = '',
  })  : dailyStats = dailyStats ?? {},
        weeklyStats = weeklyStats ?? {},
        monthlyStats = monthlyStats ?? {};
}
