import 'package:json_annotation/json_annotation.dart';

part 'organization_model.g.dart';

/// REQUEST
@JsonSerializable()
class OrganizationRequest {
  final String name;
  final String email;
  final String? description;
  final String? logoUrl;

  OrganizationRequest({
    required this.name,
    required this.email,
    this.description,
    this.logoUrl,
  });

  factory OrganizationRequest.fromJson(Map<String, dynamic> json) =>
      _$OrganizationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationRequestToJson(this);
}

/// RESPONSE
@JsonSerializable()
class OrganizationResponse {
  final String id;
  final String name;
  final String email;
  final String? description;
  final String? logoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrganizationResponse({
    required this.id,
    required this.name,
    required this.email,
    this.description,
    this.logoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrganizationResponse.fromJson(Map<String, dynamic> json) =>
      _$OrganizationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationResponseToJson(this);
}
