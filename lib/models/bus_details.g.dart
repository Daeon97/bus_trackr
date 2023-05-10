// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusDetails _$BusDetailsFromJson(Map<String, dynamic> json) => BusDetails(
      latitude: json['lat'] as num,
      longitude: json['lng'] as num,
      plateNumber: json['plate_no'] as String,
      cardAccess: json['card_access'] as String,
      occupiedSeat: json['occupied_seat'] as num,
      availableSeat: json['available_seat'] as num,
    );

Map<String, dynamic> _$BusDetailsToJson(BusDetails instance) =>
    <String, dynamic>{
      'lat': instance.latitude,
      'lng': instance.longitude,
      'plate_no': instance.plateNumber,
      'card_access': instance.cardAccess,
      'occupied_seat': instance.occupiedSeat,
      'available_seat': instance.availableSeat,
    };
