// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalkUser _$WalkUserFromJson(Map<String, dynamic> json) => WalkUser(
      uid: json['uid'] as String?,
      firebaseName: json['firebaseName'] as String?,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      dob: (json['dob'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num?)?.toInt()),
      ),
      gender: json['gender'] as String?,
      signUpLocation: json['signUpLocation'] == null
          ? null
          : LocationSnapshot.fromJson(
              json['signUpLocation'] as Map<String, dynamic>),
      inviteCode: json['inviteCode'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      lastSeenLocation: json['lastSeenLocation'] == null
          ? null
          : LocationSnapshot.fromJson(
              json['lastSeenLocation'] as Map<String, dynamic>),
      invitedBy: json['invitedBy'] as String?,
      invites:
          (json['invites'] as List<dynamic>?)?.map((e) => e as String).toList(),
      dailyGoal: (json['dailyGoal'] as num?)?.toInt(),
      claims: (json['claims'] as List<dynamic>?)
          ?.map((e) => Claim.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalkUserToJson(WalkUser instance) => <String, dynamic>{
      'uid': instance.uid,
      'firebaseName': instance.firebaseName,
      'displayName': instance.displayName,
      'email': instance.email,
      'dob': instance.dob,
      'gender': instance.gender,
      'signUpLocation': instance.signUpLocation?.toJson(),
      'inviteCode': instance.inviteCode,
      'lastSeenLocation': instance.lastSeenLocation?.toJson(),
      'balance': instance.balance,
      'invitedBy': instance.invitedBy,
      'invites': instance.invites,
      'dailyGoal': instance.dailyGoal,
      'claims': instance.claims?.map((e) => e.toJson()).toList(),
    };

LocationSnapshot _$LocationSnapshotFromJson(Map<String, dynamic> json) =>
    LocationSnapshot(
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$LocationSnapshotToJson(LocationSnapshot instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
      'time': instance.time?.toIso8601String(),
    };

LeaderBoard _$LeaderBoardFromJson(Map<String, dynamic> json) => LeaderBoard(
      displayName: json['displayName'] as String?,
      steps: (json['steps'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
      month: (json['month'] as num?)?.toInt(),
      day: (json['day'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LeaderBoardToJson(LeaderBoard instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'steps': instance.steps,
      'year': instance.year,
      'month': instance.month,
      'day': instance.day,
    };

Claim _$ClaimFromJson(Map<String, dynamic> json) => Claim(
      date: DateTime.parse(json['date'] as String),
      stepsRecorded: (json['stepsRecorded'] as num).toInt(),
      stepsRewarded: (json['stepsRewarded'] as num).toInt(),
      amountRewarded: (json['amountRewarded'] as num).toDouble(),
      wpPerStep: (json['wpPerStep'] as num).toDouble(),
    );

Map<String, dynamic> _$ClaimToJson(Claim instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'stepsRecorded': instance.stepsRecorded,
      'stepsRewarded': instance.stepsRewarded,
      'amountRewarded': instance.amountRewarded,
      'wpPerStep': instance.wpPerStep,
    };

GlobalDb _$GlobalDbFromJson(Map<String, dynamic> json) => GlobalDb(
      wpPerStep: (json['wpPerStep'] as num?)?.toDouble(),
      inviteBonus: (json['inviteBonus'] as num?)?.toInt(),
      maxStepsToReward: (json['maxStepsToReward'] as num?)?.toInt(),
      signUpBonus: (json['signUpBonus'] as num?)?.toInt(),
      privacy: json['privacy'] as String?,
      X: json['X'] as String?,
      bugReportFeedback: json['bugReportFeedback'] as String?,
      telegram: json['telegram'] as String?,
      terms: json['terms'] as String?,
      website: json['website'] as String?,
    );

Map<String, dynamic> _$GlobalDbToJson(GlobalDb instance) => <String, dynamic>{
      'wpPerStep': instance.wpPerStep,
      'inviteBonus': instance.inviteBonus,
      'signUpBonus': instance.signUpBonus,
      'maxStepsToReward': instance.maxStepsToReward,
      'privacy': instance.privacy,
      'X': instance.X,
      'bugReportFeedback': instance.bugReportFeedback,
      'telegram': instance.telegram,
      'terms': instance.terms,
      'website': instance.website,
    };
