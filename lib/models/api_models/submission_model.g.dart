// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmissionRequest _$SubmissionRequestFromJson(Map<String, dynamic> json) =>
    SubmissionRequest(
      content: json['content'] as String,
      studentId: json['studentId'] as String,
      assignmentId: json['assignmentId'] as String?,
      testId: json['testId'] as String?,
    );

Map<String, dynamic> _$SubmissionRequestToJson(SubmissionRequest instance) =>
    <String, dynamic>{
      'content': instance.content,
      'studentId': instance.studentId,
      'assignmentId': instance.assignmentId,
      'testId': instance.testId,
    };

SubmissionResponse _$SubmissionResponseFromJson(Map<String, dynamic> json) =>
    SubmissionResponse(
      id: json['id'] as String,
      content: json['content'] as String,
      score: (json['score'] as num?)?.toDouble(),
      status: $enumDecode(_$SubmissionStatusEnumMap, json['status']),
      studentId: json['studentId'] as String,
      assignmentId: json['assignmentId'] as String?,
      testId: json['testId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SubmissionResponseToJson(SubmissionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'score': instance.score,
      'status': _$SubmissionStatusEnumMap[instance.status]!,
      'studentId': instance.studentId,
      'assignmentId': instance.assignmentId,
      'testId': instance.testId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$SubmissionStatusEnumMap = {
  SubmissionStatus.SUBMITTED: 'SUBMITTED',
  SubmissionStatus.GRADED: 'GRADED',
};
