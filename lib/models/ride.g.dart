// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RideAdapter extends TypeAdapter<Ride> {
  @override
  final int typeId = 1;

  @override
  Ride read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ride(
      rideId: fields[0] as String,
      pickup: fields[1] as String,
      destination: fields[2] as String,
      status: fields[3] as String,
      passengerName: fields[4] as String,
      price: (fields[5] as num).toDouble(),
      timestamp: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ride obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.rideId)
      ..writeByte(1)
      ..write(obj.pickup)
      ..writeByte(2)
      ..write(obj.destination)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.passengerName)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
