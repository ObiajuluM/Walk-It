import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:walk_it/providers/dbconnect.dart';

class MobileBalanceAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const MobileBalanceAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(319);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    // final user = ref.watch(userProvider);
    final backendUser = ref.watch(backendUserProvider);
    //
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: currentTheme == ThemeMode.light
                ? const Color(0xFF68DEAC)
                : const Color(0xff23a06b),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(34),
              bottomRight: Radius.circular(34),
            ),
          ),
          child: Flex(
            direction: Axis.vertical,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: BackButton(
                  color: currentTheme == ThemeMode.light
                      ? Colors.white
                      : const Color(0xFF22282B),
                ),
                title: Text(
                  "Balance",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserratAlternates(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                actions: [
                  // IconButton(
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => AlertDialog(
                  //         title: Text(
                  //           "Other Walk Points are from sign up bonuses and referral bonuses",
                  //           textAlign: TextAlign.start,
                  //           // maxLines: 1,
                  //           // overflow: TextOverflow.ellipsis,
                  //           style: GoogleFonts.montserratAlternates(
                  //             color: currentTheme == ThemeMode.light
                  //                 ? Color.fromARGB(255, 0, 0, 0)
                  //                 : Color.fromARGB(255, 141, 138, 138),
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.w500,
                  //             height: 0,
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   icon: LineIcon.info(
                  //     color: currentTheme == ThemeMode.light
                  //         ? Colors.white
                  //         : const Color.fromRGBO(34, 40, 43, 1),
                  //   ),
                  // ),
                ],
              ),

              ///
              ListTile(
                title: Center(
                  child: Text(
                    "${backendUser.balance}",
                    maxLines: 1,
                    semanticsLabel: "${backendUser.balance}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
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
                color: currentTheme == ThemeMode.light
                    ? const Color(0xFF85B4D1)
                    : const Color(0xFF394861),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  // onTap: () {},
                  title: Center(
                    child: Text(
                      "Walk points",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserratAlternates(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ),
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
