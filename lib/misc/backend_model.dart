import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'backend_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WalkUserBackend {
  final String? uuid;

  final String? username;
  final String? display_name;
  final String? email;
  final double? balance;
  final String? invite_code;
  final String? invited_by;

  WalkUserBackend({
    this.uuid,
    this.username,
    this.display_name,
    this.email,
    this.balance,
    this.invite_code,
    this.invited_by,
  });

  factory WalkUserBackend.fromJson(Map<String, dynamic> json) =>
      _$WalkUserBackendFromJson(json);

  Map<String, dynamic> toJson() => _$WalkUserBackendToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LeaderBoardBackend {
  final String? display_name;
  final int? steps;
  final DateTime? time;

  LeaderBoardBackend({
    this.display_name,
    this.steps,
    this.time,
  });

  factory LeaderBoardBackend.fromJson(Map<String, dynamic> json) =>
      _$LeaderBoardBackendFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderBoardBackendToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ClaimBackend {
  final DateTime? time;
  final int? steps_recorded;
  final int? steps_rewarded;
  final double? amount_rewarded;
  final double? points_per_step;

  ClaimBackend({
    this.time,
    this.steps_recorded,
    this.steps_rewarded,
    this.amount_rewarded,
    this.points_per_step,
  });

  factory ClaimBackend.fromJson(Map<String, dynamic> json) =>
      _$ClaimBackendFromJson(json);

  Map<String, dynamic> toJson() => _$ClaimBackendToJson(this);
}

toDate(dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
  // DateFormat formatter = DateFormat('yyyy-MM-dd');
  // return formatter.parse(dateString);
}
