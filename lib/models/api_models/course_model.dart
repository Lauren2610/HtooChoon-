import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';

part 'course_model.g.dart';

/// REQUEST
@JsonSerializable()
class CourseRequest {
  final String name;
  final String? description;
  final String organizationId;
  final CourseType type;
  final String? campaignId;
  final String? schoolId;

  CourseRequest({
    required this.name,
    this.description,
    required this.organizationId,
    required this.type,
    this.campaignId,
    this.schoolId,
  });

  factory CourseRequest.fromJson(Map<String, dynamic> json) =>
      _$CourseRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CourseRequestToJson(this);
}

/// RESPONSE
@JsonSerializable()
class CourseResponse {
  final String id;
  final String name;
  final String? description;
  final String organizationId;
  final CourseType type;
  final String? campaignId;
  final String? schoolId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseResponse({
    required this.id,
    required this.name,
    this.description,
    required this.organizationId,
    required this.type,
    this.campaignId,
    this.schoolId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) =>
      _$CourseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseResponseToJson(this);
}
