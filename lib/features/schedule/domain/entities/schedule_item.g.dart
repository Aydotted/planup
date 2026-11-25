// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleItemAdapter extends TypeAdapter<ScheduleItem> {
  @override
  final int typeId = 21;

  @override
  ScheduleItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleItem(
      id: fields[0] as String,
      type: fields[1] as ScheduleItemType,
      title: fields[2] as String,
      notes: fields[3] as String,
      subtype: fields[4] as String,
      dateTime: fields[5] as DateTime,
      completed: fields[6] as bool,
      notificationsEnabled: fields[7] as bool,
      reminderMinutesBefore: fields[8] as int,
      notificationId: fields[9] as int?,
      recurring: fields[10] as bool?,
      recurrenceType: fields[11] as String?,
      recurrenceSeriesId: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleItem obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.subtype)
      ..writeByte(5)
      ..write(obj.dateTime)
      ..writeByte(6)
      ..write(obj.completed)
      ..writeByte(7)
      ..write(obj.notificationsEnabled)
      ..writeByte(8)
      ..write(obj.reminderMinutesBefore)
      ..writeByte(9)
      ..write(obj.notificationId)
      ..writeByte(10)
      ..write(obj.recurring)
      ..writeByte(11)
      ..write(obj.recurrenceType)
      ..writeByte(12)
      ..write(obj.recurrenceSeriesId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ScheduleItemTypeAdapter extends TypeAdapter<ScheduleItemType> {
  @override
  final int typeId = 20;

  @override
  ScheduleItemType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ScheduleItemType.task;
      case 1:
        return ScheduleItemType.reminder;
      case 2:
        return ScheduleItemType.subscription;
      case 3:
        return ScheduleItemType.personalEvent;
      default:
        return ScheduleItemType.task;
    }
  }

  @override
  void write(BinaryWriter writer, ScheduleItemType obj) {
    switch (obj) {
      case ScheduleItemType.task:
        writer.writeByte(0);
        break;
      case ScheduleItemType.reminder:
        writer.writeByte(1);
        break;
      case ScheduleItemType.subscription:
        writer.writeByte(2);
        break;
      case ScheduleItemType.personalEvent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleItemTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
