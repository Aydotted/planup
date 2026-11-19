// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShiftTemplateAdapter extends TypeAdapter<ShiftTemplate> {
  @override
  final int typeId = 7;

  @override
  ShiftTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShiftTemplate(
      id: fields[0] as String,
      name: fields[1] as String,
      abbreviation: fields[2] as String,
      colourValue: fields[3] as int,
      startHour: fields[4] as int,
      startMinute: fields[5] as int,
      endHour: fields[6] as int,
      endMinute: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ShiftTemplate obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.abbreviation)
      ..writeByte(3)
      ..write(obj.colourValue)
      ..writeByte(4)
      ..write(obj.startHour)
      ..writeByte(5)
      ..write(obj.startMinute)
      ..writeByte(6)
      ..write(obj.endHour)
      ..writeByte(7)
      ..write(obj.endMinute);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
