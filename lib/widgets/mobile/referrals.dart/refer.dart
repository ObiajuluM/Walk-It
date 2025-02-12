import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/misc/backend_model.dart';
import 'package:walk_it/misc/models.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/providers/primary.dart';

class ReferPopUp extends ConsumerStatefulWidget {
  const ReferPopUp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReferPopUpState();
}

class _ReferPopUpState extends ConsumerState<ReferPopUp> {
  final inviterCodeControl = TextEditingController();

  @override
  void dispose() {
    inviterCodeControl.dispose();
    super.dispose();
  }

  getInvite(WalkUser user, GlobalDb globalDB, ThemeMode currentTheme) async {
    try {
      // clean code
      final trimmedCode = inviterCodeControl.value.text.toLowerCase().trim();

      // get invite list of the invite code
      final inviteList = await FirebaseFirestore.instance
          .collection('Invites')
          .doc(trimmedCode)
          .get();

      log("called get invited");

      // if invite list exist and the invite code is not yours
      if (inviteList.exists && user.inviteCode! != trimmedCode) {
        log("enter 1 refer");
        // get invite list data
        final inviteListData = inviteList.data() ?? {};

        if (inviteListData
                .containsValue(FirebaseAuth.instance.currentUser!.uid) ==
            false) {
          // add you as an invited to the code used in db
          FirebaseFirestore.instance
              .collection('Invites')
              .doc(trimmedCode)
              .update({
            user.displayName!: FirebaseAuth.instance.currentUser!.uid,
          });

          // reward you and update your invited by
          FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'invitedBy': trimmedCode,
            'balance': FieldValue.increment(globalDB.inviteBonus!)
          }).then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
          });
          log("done 3");
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getInvited(WalkUserBackend walkUser) async {
    // clean code
    final trimmedCode = inviterCodeControl.value.text.toLowerCase().trim();
    print("object 1");
    if (walkUser.invite_code != trimmedCode && walkUser.invited_by == null ||
        walkUser.invited_by!.isEmpty) {
      print("object2");
      log("called get invited");
      try {
        await modifyUser({"invited_by": trimmedCode}).then((onValue) {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } catch (e) {
        log(e.toString());
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    // final user = ref.watch(userProvider);

    final backendUser = ref.watch(backendUserProvider);

    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      surfaceTintColor: Colors.transparent,
      backgroundColor: currentTheme == ThemeMode.light
          ? Colors.white
          : const Color(0xFF242B2E),
      title: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          'Invited by someone?',
          style: GoogleFonts.montserratAlternates(
            color: currentTheme == ThemeMode.light
                ? const Color(0xFF67A1C5)
                : const Color.fromRGBO(221, 221, 221, 1),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
        trailing: CloseButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: currentTheme == ThemeMode.light
                ? const Color(0xFF67A1C5)
                : const Color(0xFF394861),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      content: TextField(
        controller: inviterCodeControl,
      ),
      actions: [
        Card(
          color: currentTheme == ThemeMode.light
              ? const Color(0xFF67A1C5)
              : const Color(0xFF394861),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          surfaceTintColor: Colors.transparent,
          child: InkWell(
            radius: 15,
            onTap: () async {
              if (inviterCodeControl.text.trim().isNotEmpty) {
                // getInvited(user, globalDb, currentTheme);
                await getInvited(backendUser);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 80,
                vertical: 20,
              ),
              child: Text(
                "Ok",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.montserratAlternates(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  height: 0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
