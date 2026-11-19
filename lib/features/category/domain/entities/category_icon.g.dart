// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_icon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryIconAdapter extends TypeAdapter<CategoryIcon> {
  @override
  final int typeId = 4;

  @override
  CategoryIcon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryIcon(
      name: fields[0] as String,
      iconCodePoint: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryIcon obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.iconCodePoint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryIconAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
