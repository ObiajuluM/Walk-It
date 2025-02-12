import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/providers/home.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:walk_it/providers/dbconnect.dart';

class Explore extends ConsumerWidget {
  const Explore({
    super.key,
  });

  invite(String inviteCode) async {
    try {
      Share.share(
        'Hi, I am inviting you to Walk It. A web3 app that rewards you to walk - Use my code ${inviteCode} after you sign up to receive a bonus',
        subject: "Walk It Invite",
      );
    } catch (e) {
      log("an error occurred", error: e, name: "share plus package error ");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    final backendUser = ref.watch(backendUserProvider);
    final healthData = ref.watch(healthDataProvider);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 9),
      title: Text(
        "Explore",
        textAlign: TextAlign.start,
        style: GoogleFonts.montserratAlternates(
          color: const Color.fromRGBO(131, 131, 131, 1),
          fontSize: 14,
          fontWeight: FontWeight.w700,
          // height: 0,
        ),
      ),
      subtitle: GridView.builder(
        // crossAxisCount: 4,

        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // number of items in each row
          mainAxisSpacing: 0.0, // spacing between rows
          crossAxisSpacing: 0.0, // spacing between columns
        ),

        itemBuilder: (context, index) => Card(
          clipBehavior: Clip.antiAlias,
          color: (index == 0 && currentTheme == ThemeMode.light)
              ? const Color(0xFFC37030)
              : (index == 0 && currentTheme == ThemeMode.dark)
                  ? const Color(0xFF83350D)
                  : (index == 1 && currentTheme == ThemeMode.light)
                      ? const Color(0xFFC02E5A)
                      : (index == 1 && currentTheme == ThemeMode.dark)
                          ? const Color(0xFF830C3B)
                          : (index == 2 && currentTheme == ThemeMode.light)
                              ? const Color(0xFF7520CC)
                              : (index == 2 && currentTheme == ThemeMode.dark)
                                  ? const Color(0xFF3A028E)
                                  : (index == 3 &&
                                          currentTheme == ThemeMode.light)
                                      ? const Color(0xFF2183CD)
                                      : const Color(0xFF025E8E),
          child: InkWell(
            onTap: index == 0
                ? () {
                    try {
                      Share.share(
                        "I have walked ${healthData['steps']} steps today with @WalkItApp, How many have you? #WalkWithWalkIt",
                        subject: "Walk It Challenge",
                      );
                    } catch (e) {
                      log("an error occurred",
                          error: e, name: "share plus package error ");
                    }
                  }
                : index == 3
                    ? () async {
                        await invite(backendUser.invite_code!);
                      }
                    : () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Coming Soon!")));
                      },
            onTapDown: null,
            child: Icon(
              index == 0
                  ? LineIcons.running
                  : index == 1
                      ? Icons.wifi_calling_3_outlined
                      : index == 2
                          ? LineIcons.gifts
                          : Icons.group_add_outlined,
              color: currentTheme == ThemeMode.light
                  ? Colors.black87
                  : Colors.white70,
            ),
          ),
          // gift
          // airtime
          // earnmore // lucky (spin), ads
          // invite a friend
        ),
      ),
    );
  }
}
