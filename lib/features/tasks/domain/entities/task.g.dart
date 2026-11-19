// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      dueDate: fields[5] as DateTime?,
      isCompleted: fields[6] as bool,
      isArchived: fields[7] as bool,
      isPinned: fields[8] as bool,
      priority: fields[9] as int,
      color: fields[10] as int,
      tags: (fields[11] as List).cast<String>(),
      subtasks: (fields[12] as List).cast<Subtask>(),
      categoryId: fields[13] as String?,
      categoryColor: fields[14] as int,
      categoryIconCodePoint: fields[15] as int,
      recurrence: fields[16] as String,
      reminderMinutesBefore: fields[17] as int,
      attachments: (fields[18] as List).cast<String>(),
      notes: fields[19] as String?,
      progress: fields[20] as double,
      categoryName: fields[21] as String?,
      deleted: fields[22] as bool,
      startTime: fields[23] as DateTime?,
      endTime: fields[24] as DateTime?,
      notificationId: fields[99] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.isCompleted)
      ..writeByte(7)
      ..write(obj.isArchived)
      ..writeByte(8)
      ..write(obj.isPinned)
      ..writeByte(9)
      ..write(obj.priority)
      ..writeByte(10)
      ..write(obj.color)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.subtasks)
      ..writeByte(13)
      ..write(obj.categoryId)
      ..writeByte(14)
      ..write(obj.categoryColor)
      ..writeByte(15)
      ..write(obj.categoryIconCodePoint)
      ..writeByte(16)
      ..write(obj.recurrence)
      ..writeByte(17)
      ..write(obj.reminderMinutesBefore)
      ..writeByte(18)
      ..write(obj.attachments)
      ..writeByte(19)
      ..write(obj.notes)
      ..writeByte(20)
      ..write(obj.progress)
      ..writeByte(21)
      ..write(obj.categoryName)
      ..writeByte(22)
      ..write(obj.deleted)
      ..writeByte(23)
      ..write(obj.startTime)
      ..writeByte(24)
      ..write(obj.endTime)
      ..writeByte(99)
      ..write(obj.notificationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
