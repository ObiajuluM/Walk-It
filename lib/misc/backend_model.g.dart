// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalkUserBackend _$WalkUserBackendFromJson(Map<String, dynamic> json) =>
    WalkUserBackend(
      uuid: json['uuid'] as String?,
      username: json['username'] as String?,
      display_name: json['display_name'] as String?,
      email: json['email'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      invite_code: json['invite_code'] as String?,
      invited_by: json['invited_by'] as String?,
    );

Map<String, dynamic> _$WalkUserBackendToJson(WalkUserBackend instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'username': instance.username,
      'display_name': instance.display_name,
      'email': instance.email,
      'balance': instance.balance,
      'invite_code': instance.invite_code,
      'invited_by': instance.invited_by,
    };

LeaderBoardBackend _$LeaderBoardBackendFromJson(Map<String, dynamic> json) =>
    LeaderBoardBackend(
      display_name: json['display_name'] as String?,
      steps: (json['steps'] as num?)?.toInt(),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$LeaderBoardBackendToJson(LeaderBoardBackend instance) =>
    <String, dynamic>{
      'display_name': instance.display_name,
      'steps': instance.steps,
      'time': instance.time?.toIso8601String(),
    };

ClaimBackend _$ClaimBackendFromJson(Map<String, dynamic> json) => ClaimBackend(
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      steps_recorded: (json['steps_recorded'] as num?)?.toInt(),
      steps_rewarded: (json['steps_rewarded'] as num?)?.toInt(),
      amount_rewarded: (json['amount_rewarded'] as num?)?.toDouble(),
      points_per_step: (json['points_per_step'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ClaimBackendToJson(ClaimBackend instance) =>
    <String, dynamic>{
      'time': instance.time?.toIso8601String(),
      'steps_recorded': instance.steps_recorded,
      'steps_rewarded': instance.steps_rewarded,
      'amount_rewarded': instance.amount_rewarded,
      'points_per_step': instance.points_per_step,
    };
