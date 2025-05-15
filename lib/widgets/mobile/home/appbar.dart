import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:random_avatar/random_avatar.dart';

import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/providers/home.dart';
import 'package:walk_it/providers/primary.dart';

class MobileHomeAppBar extends ConsumerStatefulWidget {
  const MobileHomeAppBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileHomeAppBarState();
}

class _MobileHomeAppBarState extends ConsumerState<MobileHomeAppBar> {
  final confettiControl = ConfettiController();
  bool isPlaying = false;

  @override
  void dispose() {
    super.dispose();
    confettiControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(Duration(minutes: 15), (timer) {
    //   ref.read(healthDataProvider.notifier).getData();
    // });

    final currentTheme = ref.watch(ThemeModeStateProvider);
    final healthData = ref.watch(healthDataProvider);
    final greeting = ref.watch(greetingProvider);
    // final user = ref.watch(userProvider);
    final backendUser = ref.watch(backendUserProvider);
    //
    return Container(
      height: 319,
      padding: const EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
        // bottom: 24,
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: currentTheme == ThemeMode.light
            ? const Color.fromRGBO(103, 161, 197, 1)
            : const Color(0xFF394760),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(56),
          bottomRight: Radius.circular(56),
        ),
      ),
      child: Flex(
        direction: Axis.vertical,
        // direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 0,
            title: Text(
              greeting,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserratAlternates(
                color: const Color.fromRGBO(255, 255, 255, 0.5),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              backendUser.display_name ??
                  FirebaseAuth.instance.currentUser!.displayName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserratAlternates(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: SizedBox(
              height: 60,
              width: 60,
              child: RandomAvatar(
                backendUser.display_name ??
                    FirebaseAuth.instance.currentUser!.displayName!,
                alignment: Alignment.centerRight,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          ///
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                " ${DateFormat.yMMMMEEEEd().format(DateTime.now())} ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserratAlternates(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          Row(
            // direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///
              Flexible(
                flex: 4,
                child: Container(
                  // height: 180,
                  // height: 180,
                  padding: const EdgeInsets.only(bottom: 13),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    color: currentTheme == ThemeMode.light
                        ? const Color.fromARGB(255, 255, 255, 255)
                        : const Color.fromARGB(255, 220, 220, 220),
                  ),

                  child: Flex(
                    // mainAxisSize: MainAxisSize.min,
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ///
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            // flex: 4,
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${healthData["steps"]! >= 100001 ? "♾️" : healthData['steps']}", // if more than 100k show infinty symbol
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  // textScaleFactor: 1,
                                  // textScaler: TextScaler.noScaling,
                                  style: const TextStyle(
                                    fontFamily: 'EvilEmpire',
                                    color: Colors.black,
                                    fontSize: 96,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: -5.76,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          LinearPercentIndicator(
                            addAutomaticKeepAlive: false,
                            barRadius: const Radius.circular(41),
                            lineHeight: 50.0,
                            animationDuration: 1000,
                            percent: goalPercent(healthData["steps"]!, 5000),
                            animation: true,
                            center:
                                Text("${healthData["steps"]} / ${5000} steps"),
                            // animateFromLastPercent: true,
                            backgroundColor: Colors.grey,
                            progressColor: currentTheme == ThemeMode.light
                                ? const Color.fromRGBO(103, 161, 197, 1)
                                : const Color(0xFF394760),
                            onAnimationEnd: () {
                              HapticFeedback.vibrate();
                              if (goalPercent(healthData["steps"]!, 5000) >=
                                  1) {
                                if (!isPlaying) {
                                  confettiControl.play();
                                } else {
                                  confettiControl.stop();
                                }
                              }
                            },
                          ),
                          ConfettiWidget(
                            confettiController: confettiControl,
                            blastDirection: -pi / 2,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
