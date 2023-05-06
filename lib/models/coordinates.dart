// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

part 'coordinates.g.dart';

@JsonSerializable()
class Coordinates {
  const Coordinates({
    required this.lat,
    required this.lng,
  });
  
  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);

  final double lat;
  final double lng;

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}
