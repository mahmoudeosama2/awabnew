part of 'daily_goal_model.dart';

class DailyGoalModelAdapter extends TypeAdapter<DailyGoalModel> {
  @override
  final int typeId = 0;

  @override
  DailyGoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyGoalModel(
      goalPages: fields[0] as int,
      goalAyahs: fields[1] as int,
      dailyProgress: (fields[2] as Map).cast<String, int>(),
      currentStreak: fields[3] as int,
      longestStreak: fields[4] as int,
      lastReadDate: fields[5] as String,
      totalPagesRead: fields[6] as int,
      totalAyahsRead: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyGoalModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.goalPages)
      ..writeByte(1)
      ..write(obj.goalAyahs)
      ..writeByte(2)
      ..write(obj.dailyProgress)
      ..writeByte(3)
      ..write(obj.currentStreak)
      ..writeByte(4)
      ..write(obj.longestStreak)
      ..writeByte(5)
      ..write(obj.lastReadDate)
      ..writeByte(6)
      ..write(obj.totalPagesRead)
      ..writeByte(7)
      ..write(obj.totalAyahsRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyGoalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReadingSessionAdapter extends TypeAdapter<ReadingSession> {
  @override
  final int typeId = 1;

  @override
  ReadingSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReadingSession(
      date: fields[0] as String,
      pagesRead: fields[1] as int,
      ayahsRead: fields[2] as int,
      durationMinutes: fields[3] as int,
      surahName: fields[4] as String,
      surahNumber: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReadingSession obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.pagesRead)
      ..writeByte(2)
      ..write(obj.ayahsRead)
      ..writeByte(3)
      ..write(obj.durationMinutes)
      ..writeByte(4)
      ..write(obj.surahName)
      ..writeByte(5)
      ..write(obj.surahNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
