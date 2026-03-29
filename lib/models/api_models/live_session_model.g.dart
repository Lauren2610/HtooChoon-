// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveSessionRequest _$LiveSessionRequestFromJson(Map<String, dynamic> json) =>
    LiveSessionRequest(
      topic: json['topic'] as String,
      roomId: json['roomId'] as String,
      hostId: json['hostId'] as String,
      classId: json['classId'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
    );

Map<String, dynamic> _$LiveSessionRequestToJson(LiveSessionRequest instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'roomId': instance.roomId,
      'hostId': instance.hostId,
      'classId': instance.classId,
      'startTime': instance.startTime.toIso8601String(),
    };

UpdateLiveSessionRequest _$UpdateLiveSessionRequestFromJson(
  Map<String, dynamic> json,
) => UpdateLiveSessionRequest(
  topic: json['topic'] as String?,
  status: $enumDecodeNullable(_$LiveSessionStatusEnumMap, json['status']),
  startTime: json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
);

Map<String, dynamic> _$UpdateLiveSessionRequestToJson(
  UpdateLiveSessionRequest instance,
) => <String, dynamic>{
  'topic': ?instance.topic,
  'status': ?_$LiveSessionStatusEnumMap[instance.status],
  'startTime': ?instance.startTime?.toIso8601String(),
  'endTime': ?instance.endTime?.toIso8601String(),
};

const _$LiveSessionStatusEnumMap = {
  LiveSessionStatus.SCHEDULED: 'SCHEDULED',
  LiveSessionStatus.LIVE: 'LIVE',
  LiveSessionStatus.ENDED: 'ENDED',
};

LiveSessionResponse _$LiveSessionResponseFromJson(Map<String, dynamic> json) =>
    LiveSessionResponse(
      id: json['id'] as String,
      topic: json['topic'] as String,
      roomId: json['roomId'] as String,
      hostId: json['hostId'] as String,
      classId: json['classId'] as String?,
      status: $enumDecode(_$LiveSessionStatusEnumMap, json['status']),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$LiveSessionResponseToJson(
  LiveSessionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'topic': instance.topic,
  'roomId': instance.roomId,
  'hostId': instance.hostId,
  'classId': instance.classId,
  'status': _$LiveSessionStatusEnumMap[instance.status]!,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
