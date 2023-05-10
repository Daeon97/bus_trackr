// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

part 'bus_details.g.dart';

@JsonSerializable()
class BusDetails {
  const BusDetails({
    required this.latitude,
    required this.longitude,
    required this.plateNumber,
    required this.cardAccess,
    required this.occupiedSeat,
    required this.availableSeat,
  });

  factory BusDetails.fromJson(Map<String, dynamic> json) =>
      _$BusDetailsFromJson(json);

  @JsonKey(name: 'lat')
  final num latitude;

  @JsonKey(name: 'lng')
  final num longitude;

  @JsonKey(name: 'plate_no')
  final String plateNumber;

  @JsonKey(name: 'card_access')
  final String cardAccess;

  @JsonKey(name: 'occupied_seat')
  final num occupiedSeat;

  @JsonKey(name: 'available_seat')
  final num availableSeat;

  Map<String, dynamic> toJson() => _$BusDetailsToJson(this);
}
