import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/widgets/mobile/referrals.dart/refer.dart';

class MobileReferralsAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const MobileReferralsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(319);

  invite(String inviteCode) async {
    try {
      await Share.share(
        'Hi, I am inviting you to Walk It. A web3 app that rewards you to walk - Use my code $inviteCode after you sign up to receive a bonus',
        subject: "Walk It Invite",
      );
    } catch (e) {
      log("an error occurred", error: e, name: "share plus package error ");
    }
  }

  String inviteCountify() {
    int referrals = 0;
    getUserInvites().then((onValue) {
      referrals = onValue.length;
    });

    final nreferrals = "0$referrals";
    return referrals > 9 && referrals <= 99
        ? nreferrals
        : referrals <= 10
            ? "00$referrals"
            : "$referrals";
  }

// // function to return the name of the person that invited the user
//   Future<String> userInvitedBy(String? invitecode) async {
//     if (invitecode == null) {}
//     final inviter = await FirebaseFirestore.instance
//         .collection('Invites')
//         .doc(invitecode)
//         .get();

//     final inviterData = inviter.data();

//     return inviterData?[invitecode] ?? "";
//   }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    // final user = ref.watch(userProvider);
    final backendUser = ref.watch(backendUserProvider);
    // final userInvites = ref.watch(invitesProvider);

    // Map<String, dynamic> cleanUserInvites = userInvites.remove('owner');

    ///
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: currentTheme == ThemeMode.light
                ? const Color(0xFF67A1C5)
                : const Color(0xFF394861),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(34),
              bottomRight: Radius.circular(34),
            ),
          ),
          child: Flex(
            direction: Axis.vertical,
            children: [
              ///
              AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                centerTitle: true,
                leading: BackButton(
                  color: currentTheme == ThemeMode.light
                      ? Colors.white
                      : const Color(0xFF22282B),
                ),
                title: Text(
                  "Referrals",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserratAlternates(
                    color: currentTheme == ThemeMode.light
                        ? Colors.white
                        : const Color.fromRGBO(221, 221, 221, 1),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                actions: [
                  backendUser.invited_by == null ||
                          backendUser.invited_by!.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => const ReferPopUp(),
                            );
                          },
                          child: LineIcon.wiredNetwork(
                            color: currentTheme == ThemeMode.light
                                ? Colors.white
                                : const Color.fromRGBO(34, 40, 43, 1),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (builder) => AlertDialog(
                                surfaceTintColor: Colors.transparent,
                                backgroundColor: currentTheme == ThemeMode.light
                                    ? const Color(0xFF67A1C5)
                                    : const Color(0xFF394861),
                                content: Text(
                                  "Invited by ${backendUser.invited_by}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserratAlternates(
                                    color: currentTheme == ThemeMode.light
                                        ? Colors.white
                                        : const Color.fromRGBO(
                                            221, 221, 221, 1),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const LineIcon.plusSquare(
                            color: Colors.black,
                          ),
                        )
                ],
              ),

              ///
              ListTile(
                title: Center(
                  child: Text(
                    inviteCountify(),
                    maxLines: 1,
                    // semanticsLabel: "100,000",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: currentTheme == ThemeMode.light
                          ? Colors.white
                          : const Color.fromRGBO(221, 221, 221, 1),
                      fontSize: 96,
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: -3.84,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              ///
              Card(
                clipBehavior: Clip.antiAlias,
                color: const Color.fromRGBO(133, 180, 209, 1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  // tileColor: Color(0xFF85B4D1),
                  leading: SizedBox(
                      height: 60,
                      width: 60,
                      child: RandomAvatar(backendUser.display_name ??
                          FirebaseAuth.instance.currentUser!.displayName!)),
                  title: Text(
                    backendUser.display_name ??
                        FirebaseAuth.instance.currentUser!.displayName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserratAlternates(
                      color: currentTheme == ThemeMode.light
                          ? Colors.white
                          : const Color(0xFF394861),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  subtitle: Text(backendUser.invite_code!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserratAlternates(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        height: 0,
                        letterSpacing: 0.50,
                      )),
                  trailing: InkWell(
                    onTap: () {
                      invite(backendUser.invite_code!);
                    },
                    child: Container(
                      width: 54,
                      height: 60,
                      padding: const EdgeInsets.all(13),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: currentTheme == ThemeMode.light
                            ? Colors.white
                            : const Color(0xFF22282B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Icon(
                        Icons.copy,
                        color: currentTheme == ThemeMode.light
                            ? Colors.black
                            : const Color.fromRGBO(221, 221, 221, 1),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        ///
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: double.infinity,
              color: Colors.white.withOpacity(0.1),
              width: 21,
              margin: const EdgeInsets.symmetric(horizontal: 21),
            ),
            Container(
              height: double.infinity,
              color: Colors.white.withOpacity(0.1),
              width: 21,
              // margin: EdgeInsets.symmetric(horizontal: 15),
            ),
            Container(
              height: double.infinity,
              color: Colors.white.withOpacity(0.1),
              width: 21,
              margin: const EdgeInsets.only(
                left: 21,
                right: 100,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
