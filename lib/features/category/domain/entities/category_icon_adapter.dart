import 'package:hive/hive.dart';

import 'category_icon.dart';

class CategoryIconAdapter extends TypeAdapter<CategoryIcon> {
  @override
  final int typeId = 4;

  @override
  CategoryIcon read(BinaryReader reader) {
    return CategoryIcon(
      name: reader.readString(),
      iconCodePoint: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryIcon obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.iconCodePoint);
  }
}
