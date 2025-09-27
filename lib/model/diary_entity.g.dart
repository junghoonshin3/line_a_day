// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiaryEntityAdapter extends TypeAdapter<DiaryEntity> {
  @override
  final int typeId = 0;

  @override
  DiaryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiaryEntity(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      date: fields[3] as DateTime,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      moodScore: fields[6] as int?,
      weather: fields[7] as String?,
      isFavorite: fields[8] as bool,
      isPrivate: fields[9] as bool,
      tags: (fields[10] as List).cast<String>(),
      imageUrls: (fields[11] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DiaryEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.moodScore)
      ..writeByte(7)
      ..write(obj.weather)
      ..writeByte(8)
      ..write(obj.isFavorite)
      ..writeByte(9)
      ..write(obj.isPrivate)
      ..writeByte(10)
      ..write(obj.tags)
      ..writeByte(11)
      ..write(obj.imageUrls);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
