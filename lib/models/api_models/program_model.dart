import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';

part 'program_model.g.dart';

/// REQUEST
@JsonSerializable()
class ProgramRequest {
  final String name;
  final String? description;
  final String organizationId;
  final ProgramType type;
  final String? schoolId;

  ProgramRequest({
    required this.name,
    this.description,
    required this.organizationId,
    required this.type,
    this.schoolId,
  });

  factory ProgramRequest.fromJson(Map<String, dynamic> json) =>
      _$ProgramRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramRequestToJson(this);
}

/// RESPONSE
@JsonSerializable()
class ProgramResponse {
  final String id;
  final String name;
  final String? description;
  final String organizationId;
  final ProgramType type;
  final String? schoolId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProgramResponse({
    required this.id,
    required this.name,
    this.description,
    required this.organizationId,
    required this.type,
    this.schoolId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProgramResponse.fromJson(Map<String, dynamic> json) =>
      _$ProgramResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramResponseToJson(this);
}
