import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walk_it/misc/models.dart';

/// return user data
class UserProvider extends StateNotifier<WalkUser> {
  UserProvider() : super(WalkUser());

  Future<void> getData(String uid) async {
    final user = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (user.exists) {
      state = WalkUser.fromJson(user.data()!);
    }
  }
}

final userProvider = StateNotifierProvider<UserProvider, WalkUser>((ref) {
  return UserProvider();
});

// return referals
class GlobalDBProvider extends StateNotifier<GlobalDb> {
  GlobalDBProvider() : super(GlobalDb());

  getData() async {
    final db = await FirebaseFirestore.instance
        .collection('Constants')
        .doc("Constant")
        .get();
    state = GlobalDb.fromJson(db.data()!);
  }
}

final globalDBProvider =
    StateNotifierProvider<GlobalDBProvider, GlobalDb>((ref) {
  return GlobalDBProvider();
});

// return Invites
class InvitesProvider extends StateNotifier<Map<String, dynamic>> {
  InvitesProvider() : super({});

  getData(String inviteCode) async {
    final inviter = await FirebaseFirestore.instance
        .collection('Invites')
        .doc(inviteCode)
        .get();

    if (inviter.exists) {
      state = inviter.data()!;
    }

    // log("got invites");
  }
}

final invitesProvider =
    StateNotifierProvider<InvitesProvider, Map<String, dynamic>>((ref) {
  return InvitesProvider();
});

// return LeadrBoard
// class LeaderboardProvider extends StateNotifier<List<LeaderBoard>> {
//   LeaderboardProvider() : super(<LeaderBoard>[]);

//   Future<bool> getData() async {
//     final yesterday = DateTime.now().subtract(const Duration(days: 1));
//     List<LeaderBoard> leading = <LeaderBoard>[];

//     /// return 100 documents in order of desending steps, where date is yesterday
//     final leaders = await FirebaseFirestore.instance
//         .collection('LeaderBoard')
//         .where('year', isEqualTo: yesterday.year)
//         .where('month', isEqualTo: yesterday.month)
//         .where('day', isEqualTo: yesterday.day)
//         .orderBy('steps', descending: true)
//         .limit(100)
//         .get();

//     for (var leader in leaders.docs) {
//       leading.add(LeaderBoard.fromJson(leader.data()));
//     }

//     leading = leading.toSet().toList();
//     state.toSet().toList();

//     // state = leading;

//     log("got steps?");
//     return true;
//   }
// }

// final leaderboardProvider =
//     StateNotifierProvider<LeaderboardProvider, List<LeaderBoard>>((ref) {
//   return LeaderboardProvider();
// });
