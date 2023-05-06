// ignore_for_file: public_member_api_docs

import 'package:bus_trackr/models/coordinates.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bus_details.g.dart';

@JsonSerializable()
class BusDetails {
  const BusDetails({
    required this.currentPosition,
    required this.vehiclePlateNumber,
    required this.price,
    required this.destination,
    required this.terminal,
  });

  factory BusDetails.fromJson(Map<String, dynamic> json) =>
      _$BusDetailsFromJson(json);

  @JsonKey(name: 'current_position')
  final Coordinates currentPosition;

  @JsonKey(name: 'vehicle_plate_number')
  final String vehiclePlateNumber;

  final num price;
  final String destination;
  final Coordinates terminal;

  Map<String, dynamic> toJson() => _$BusDetailsToJson(this);
}
