// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusDetails _$BusDetailsFromJson(Map<String, dynamic> json) => BusDetails(
      currentPosition: Coordinates.fromJson(
          json['current_position'] as Map<String, dynamic>),
      vehiclePlateNumber: json['vehicle_plate_number'] as String,
      price: json['price'] as num,
      destination: json['destination'] as String,
      terminal: Coordinates.fromJson(json['terminal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BusDetailsToJson(BusDetails instance) =>
    <String, dynamic>{
      'current_position': instance.currentPosition,
      'vehicle_plate_number': instance.vehiclePlateNumber,
      'price': instance.price,
      'destination': instance.destination,
      'terminal': instance.terminal,
    };
