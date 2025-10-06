part of 'tasbeeh_model.dart';

class TasbeehSessionAdapter extends TypeAdapter<TasbeehSession> {
  @override
  final int typeId = 2;

  @override
  TasbeehSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasbeehSession(
      id: fields[0] as String,
      date: fields[1] as String,
      count: fields[2] as int,
      zekrType: fields[3] as String,
      timestamp: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TasbeehSession obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.zekrType)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasbeehSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TasbeehStatsAdapter extends TypeAdapter<TasbeehStats> {
  @override
  final int typeId = 3;

  @override
  TasbeehStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasbeehStats(
      totalCount: fields[0] as int,
      dailyStats: (fields[1] as Map).cast<String, int>(),
      weeklyStats: (fields[2] as Map).cast<String, int>(),
      monthlyStats: (fields[3] as Map).cast<String, int>(),
      lastUpdateDate: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TasbeehStats obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.totalCount)
      ..writeByte(1)
      ..write(obj.dailyStats)
      ..writeByte(2)
      ..write(obj.weeklyStats)
      ..writeByte(3)
      ..write(obj.monthlyStats)
      ..writeByte(4)
      ..write(obj.lastUpdateDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasbeehStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
