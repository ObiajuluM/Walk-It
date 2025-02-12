import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:walk_it/pages/mobile/leaderboard.dart';
import 'package:walk_it/providers/primary.dart';

class Leaderboard extends ConsumerWidget {
  const Leaderboard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);

    return ListTile(
      tileColor: currentTheme == ThemeMode.light
          ? Colors.white
          : const Color(0xFF242A2E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 9),
      title: Text(
        "Daily Leaderboard",
        textAlign: TextAlign.start,
        style: GoogleFonts.montserratAlternates(
          color: const Color(0xFF838383),
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      ),
      subtitle: Container(
        clipBehavior: Clip.antiAlias,
        height: 335,
        decoration: const BoxDecoration(),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MobileLeaderboardPage(),
              ),
            );
          },
          // highlightColor: Color.fromRGBO(103, 161, 197, 0.2),
          // splashColor: Color.fromRGBO(103, 161, 197, 0.2),
          child: ListView.builder(
            // physics: NeverScrollableScrollPhysics(),
            // clipBehavior: Clip.antiAlias,
            // padding: EdgeInsets.symmetric(horizontal: 24),'
            padding: const EdgeInsets.only(bottom: 0),
            itemCount: 5,
            shrinkWrap: true,
            clipBehavior: Clip.antiAlias,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                elevation: 3,
                shadowColor: index == 0
                    ? const Color(0xFF68DEAC)
                    : const Color.fromRGBO(103, 161, 197, 0.329),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  tileColor: index == 0
                      ? const Color.fromRGBO(104, 222, 172, 1)
                      : index == 1
                          ? Colors.deepOrangeAccent
                          : index == 2
                              ? const Color.fromRGBO(220, 174, 151, 1)
                              : Colors.white,
                  leading: RandomAvatar(
                    "$index",
                    height: 34,
                    width: 34,
                  ),
                  title: Text(
                    index == 0
                        ? "Adamant Potato"
                        : index == 1
                            ? "Violet Chicken"
                            : index == 2
                                ? "Rhythmic Cucumber"
                                : index == 3
                                    ? "Dancing Fowl"
                                    : "Indigo Pupa",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserratAlternates(
                      color: const Color(0xFF525252),
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
                            "100,003",
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
          ),
        ),
      ),
    );
  }
}
