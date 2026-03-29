import 'package:json_annotation/json_annotation.dart';
import 'enums.dart';

part 'live_session_model.g.dart';

/// ======================
/// REQUESTS
/// ======================

@JsonSerializable()
class LiveSessionRequest {
  final String topic;
  final String roomId;
  final String hostId;
  final String? classId;
  final DateTime startTime;

  LiveSessionRequest({
    required this.topic,
    required this.roomId,
    required this.hostId,
    this.classId,
    required this.startTime,
  });

  factory LiveSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$LiveSessionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LiveSessionRequestToJson(this);
}

/// Partial update (very common for sessions)
@JsonSerializable(includeIfNull: false)
class UpdateLiveSessionRequest {
  final String? topic;
  final LiveSessionStatus? status;
  final DateTime? startTime;
  final DateTime? endTime;

  UpdateLiveSessionRequest({
    this.topic,
    this.status,
    this.startTime,
    this.endTime,
  });

  factory UpdateLiveSessionRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateLiveSessionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateLiveSessionRequestToJson(this);
}

/// ======================
/// RESPONSE
/// ======================

@JsonSerializable()
class LiveSessionResponse {
  final String id;
  final String topic;
  final String roomId;
  final String hostId;
  final String? classId;
  final LiveSessionStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  LiveSessionResponse({
    required this.id,
    required this.topic,
    required this.roomId,
    required this.hostId,
    this.classId,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LiveSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$LiveSessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LiveSessionResponseToJson(this);
}
