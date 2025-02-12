import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:walk_it/misc/backend.dart';
import 'dart:math' as math;
import 'package:walk_it/providers/primary.dart';

class MobileLeaderboardPage extends ConsumerWidget {
  const MobileLeaderboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    // writeAccessTokenToLocal("PjJKkM3hACCd3o1ACZqkoHVRenkin2");

    // Future<List<LeaderBoard>> getLeaderBoard() async {
    //   print("Fffff");
    //   final yesterday = DateTime.now().subtract(const Duration(days: 1));
    //   List<LeaderBoard> leading = <LeaderBoard>[];

    //   /// return 100 documents in order of desending steps, where date is yesterday
    //   final leaders = await FirebaseFirestore.instance
    //       .collection('LeaderBoard')
    //       .where('year', isEqualTo: yesterday.year)
    //       .where('month', isEqualTo: yesterday.month)
    //       .where('day', isEqualTo: yesterday.day)
    //       .orderBy('steps', descending: true)
    //       .limit(100)
    //       .get();

    //   for (var leader in leaders.docs) {
    //     leading.add(LeaderBoard.fromJson(leader.data()));
    //   }
    //   // convert to set and list to make data unique
    //   leading = leading.toSet().toList();

    //   // sort in order of highest to lowest steps
    //   leading.sort(
    //     (leaderA, leaderB) => leaderB.steps!.compareTo(leaderA.steps!),
    //   );

    //   log("got steps?");
    //   return leading;
    // }

    ///
    return Scaffold(
      extendBody: true,

      // backgroundColor: const Color.fromRGBO(226, 237, 244, 1),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "Daily Leaderboard",
          style: GoogleFonts.montserratAlternates(
            // color: currentTheme == ThemeMode.light
            //     ? Color.fromARGB(255, 255, 255, 255)
            //     : const Color(0xFF67A1C5),
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: ((context) => AlertDialog(
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: currentTheme == ThemeMode.light
                          ? Colors.white
                          : const Color(0xFF242B2E),
                      actionsAlignment: MainAxisAlignment.center,
                      content: Text(
                        // yesterday
                        "Leaderboard for ${DateFormat.yMMMMEEEEd().format(DateTime.now().subtract(const Duration(days: 1)))}",
                        // textAlign: TextAlign.center,
                        style: GoogleFonts.montserratAlternates(
                          color: currentTheme == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    )),
              );
            },
            icon: LineIcon.calendar(
              color: currentTheme == ThemeMode.light
                  ? Colors.white
                  : const Color.fromRGBO(34, 40, 43, 1),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getLeaderBoard(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 50),
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 3,
                      margin: const EdgeInsets.all(4),
                      shadowColor: const Color.fromRGBO(103, 161, 197, 0.329),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        tileColor: index == 0
                            ? const Color.fromRGBO(104, 222, 172, 1)
                            : index == 1
                                ? Colors.deepOrange
                                : index == 2
                                    ? const Color.fromRGBO(220, 174, 151, 1)
                                    : Color((math.Random().nextDouble() *
                                                0xFFFFFF)
                                            .toInt())
                                        .withOpacity(0.1),
                        leading: RandomAvatar(
                          snapshot.data!.elementAt(index).display_name!,
                          height: 34,
                          width: 34,
                        ),
                        title: Text(
                          snapshot.data!.elementAt(index).display_name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserratAlternates(
                            color: const Color.fromRGBO(82, 82, 82, 1),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        trailing: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            index == 0
                                ? const Icon(
                                    Icons.star_rounded,
                                    color: Colors.yellow,
                                  )
                                : const SizedBox(),
                            index == 1
                                ? const Icon(
                                    Icons.star_rounded,
                                    color: Colors.white,
                                  )
                                : const SizedBox(),
                            index == 2
                                ? const Icon(
                                    Icons.star_rounded,
                                    color: Colors.brown,
                                  )
                                : const SizedBox(),

                            ///
                            Wrap(
                              direction: Axis.vertical,
                              // mainAxisSize: MainAxisSize.min,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Text(
                                  snapshot.data!
                                      .elementAt(index)
                                      .steps!
                                      .toString(),
                                  // textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  semanticsLabel: "step count",
                                  style: GoogleFonts.montserratAlternates(
                                    color: const Color.fromRGBO(82, 82, 82, 1),
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  "steps",
                                  semanticsLabel: "step",
                                  // textAlign: TextAlign.right,
                                  maxLines: 1,
                                  style: GoogleFonts.montserratAlternates(
                                    color: const Color.fromRGBO(82, 82, 82, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'All truly great thoughts are conceived while walking.',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserratAlternates(
                      color: currentTheme == ThemeMode.light
                          ? const Color(0xFF5E5E5E)
                          : const Color.fromRGBO(221, 221, 221, 1),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                );
        },
      ),
    );
  }
}
