import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/misc/models.dart';
import 'package:walk_it/pages/mobile/balance.dart';
import 'package:walk_it/pages/mobile/referrals.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/walk_it_icons_icons.dart';
import 'package:walk_it/widgets/mobile/profile/nameandemail.dart';

class MobileProfilePage extends ConsumerWidget {
  const MobileProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final user = ref.watch(userProvider);
    final backendUser = ref.watch(backendUserProvider);
    final currentTheme = ref.watch(ThemeModeStateProvider);

    ///
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,

      ///
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        toolbarHeight: 200,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(56),
            bottomRight: Radius.circular(56),
          ),
        ),
        title: ListTile(
          minVerticalPadding: 50,
          title: RandomAvatar(
            backendUser.display_name ??
                FirebaseAuth.instance.currentUser!.displayName!,
            height: 100,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text(
              backendUser.display_name ??
                  FirebaseAuth.instance.currentUser!.displayName!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserratAlternates(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
        ),
      ),

      ///

      body: ListView(
        children: [
          ///
          const NameandEmail(),

          ///
          const Divider(
            endIndent: 150,
            indent: 150,
            height: 0,
            color: Colors.white,
          ),

          ///
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // padding: EdgeInsets.only(top: 20),
            itemCount: 3,
            itemBuilder: ((context, index) => Card(
                  clipBehavior: Clip.antiAlias,
                  shadowColor: currentTheme == ThemeMode.light
                      ? const Color(0x5467A1C5)
                      : const Color(0xFF000000),
                  color: currentTheme == ThemeMode.light
                      ? Colors.white
                      : const Color(0xFF20262A),
                  surfaceTintColor: Colors.transparent,
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 20,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Icon(
                      index == 0
                          ? WalkItIcons.referrals
                          : index == 1
                              ? WalkItIcons.balance
                              : WalkItIcons.goals,
                      color: index == 0
                          ? const Color(0xFF67A1C5)
                          : index == 1
                              ? const Color(0xFF7FECB8)
                              : const Color(0xFFEFA058),
                    ),
                    onTap: () async {
                      // get page data

                      index == 0 || index == 1
                          ? ref
                              .read(backendUserProvider.notifier)
                              .getData()
                              .then((onValue) {
                              log("got backend user data");
                            })
                          : null;

                      // ref
                      //     .read(userProvider.notifier)
                      //     .getData(FirebaseAuth.instance.currentUser!.uid)
                      //     .then((onValue) {
                      //   log("got user data");
                      // });

                      index == 0
                          ? ref.read(globalDBProvider.notifier).getData()
                          : null;

                      index == 0
                          //  TODO: do proper invite code req to db
                          ? ref
                              .read(invitesProvider.notifier)
                              .getData(backendUser.invite_code!)
                          : null;

                      index == 0
                          ? Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MobileReferralsPage()),
                            )
                          : index == 1
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const MobileBalancePage()))
                              : null;
                      // go to goals page
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => MobileGoalPage()));
                    },
                    title: Text(
                      index == 0
                          ? "Referrals"
                          : index == 1
                              ? "Balance"
                              : "Goal",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserratAlternates(
                        color: currentTheme == ThemeMode.light
                            ? const Color(0xFF5E5E5E)
                            : const Color.fromRGBO(221, 221, 221, 1),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
