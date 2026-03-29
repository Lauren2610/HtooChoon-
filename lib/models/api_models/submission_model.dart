import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';

part 'submission_model.g.dart';

/// REQUEST
@JsonSerializable()
class SubmissionRequest {
  final String content;
  final String studentId;
  final String? assignmentId;
  final String? testId;

  SubmissionRequest({
    required this.content,
    required this.studentId,
    this.assignmentId,
    this.testId,
  });

  factory SubmissionRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmissionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionRequestToJson(this);
}

/// RESPONSE
@JsonSerializable()
class SubmissionResponse {
  final String id;
  final String content;
  final double? score;
  final SubmissionStatus status;
  final String studentId;
  final String? assignmentId;
  final String? testId;
  final DateTime createdAt;

  SubmissionResponse({
    required this.id,
    required this.content,
    this.score,
    required this.status,
    required this.studentId,
    this.assignmentId,
    this.testId,
    required this.createdAt,
  });

  factory SubmissionResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmissionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmissionResponseToJson(this);
}
