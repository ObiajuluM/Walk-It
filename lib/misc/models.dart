import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable(explicitToJson: true)
class WalkUser {
  /// read only
  final String? uid;
  final String? firebaseName;
  final String? displayName;
  final String? email;
  final Map<String, int?>? dob;
  final String? gender;
  final LocationSnapshot? signUpLocation;
  final String? inviteCode;

  /// read and write
  final LocationSnapshot? lastSeenLocation;
  final double? balance;
  // write once, no updates
  final String? invitedBy;
  final List<String>? invites;
  final int? dailyGoal;
  final List<Claim>? claims;

  WalkUser({
    this.uid,
    this.firebaseName,
    this.displayName,
    this.email,
    this.dob,
    this.gender,
    this.signUpLocation,
    this.inviteCode,

    ///
    this.balance,
    this.lastSeenLocation,
    this.invitedBy,
    this.invites,
    this.dailyGoal,
    this.claims,
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory WalkUser.fromJson(Map<String, dynamic> json) =>
      _$WalkUserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$WalkUserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LocationSnapshot {
  final double? lat;
  final double? long;
  final DateTime? time;

  LocationSnapshot({required this.lat, required this.long, required this.time});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory LocationSnapshot.fromJson(Map<String, dynamic> json) =>
      _$LocationSnapshotFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$LocationSnapshotToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LeaderBoard {
  final String? displayName;
  final int? steps;
  final int? year;
  final int? month;
  final int? day;

  LeaderBoard({
    this.displayName,
    this.steps,
    this.year,
    this.month,
    this.day,
  });

  factory LeaderBoard.fromJson(Map<String, dynamic> json) =>
      _$LeaderBoardFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderBoardToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Claim {
  final DateTime date;
  final int stepsRecorded;
  final int stepsRewarded;
  final double amountRewarded;
  final double wpPerStep;

  Claim({
    required this.date,
    required this.stepsRecorded,
    required this.stepsRewarded,
    required this.amountRewarded,
    required this.wpPerStep,
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Claim.fromJson(Map<String, dynamic> json) => _$ClaimFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ClaimToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GlobalDb {
  final double? wpPerStep;
  final int? inviteBonus;
  final int? signUpBonus;
  final int? maxStepsToReward;
  final String? privacy;
  final String? X;
  final String? bugReportFeedback;
  final String? telegram;
  final String? terms;
  final String? website;

  GlobalDb({
    this.wpPerStep,
    this.inviteBonus,
    this.maxStepsToReward,
    this.signUpBonus,
    this.privacy,
    this.X,
    this.bugReportFeedback,
    this.telegram,
    this.terms,
    this.website,
  });

  factory GlobalDb.fromJson(Map<String, dynamic> json) =>
      _$GlobalDbFromJson(json);

  Map<String, dynamic> toJson() => _$GlobalDbToJson(this);
}

isNewUser() async {
  bool newUser = false;

  if (FirebaseAuth.instance.currentUser?.metadata.creationTime ==
      FirebaseAuth.instance.currentUser?.metadata.lastSignInTime) {
    newUser = true;
    log("this is a new user");
  } else {
    newUser = false;
  }

  // final user =
  //     await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  // if (user.exists) {
  //   newUser = false;
  // }
  return newUser;
}

String generateInviteCode(String data) {
  var bytes = utf8.encode(data);
  var digest = sha1.convert(bytes);
  return '$digest'.substring(0, 9);
}
