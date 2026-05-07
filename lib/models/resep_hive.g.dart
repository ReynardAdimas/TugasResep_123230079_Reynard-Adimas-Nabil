// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resep_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResepHiveAdapter extends TypeAdapter<ResepHive> {
  @override
  final int typeId = 0;

  @override
  ResepHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResepHive(
      id: fields[0] as String,
      name: fields[1] as String,
      Image: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ResepHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.Image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResepHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
