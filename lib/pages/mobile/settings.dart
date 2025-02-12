import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:walk_it/pages/mobile/permissions.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:walk_it/walk_it_icons_icons.dart';
import 'package:walk_it/widgets/mobile/settings/signout.dart';
import 'package:walk_it/widgets/mobile/settings/socials.dart';

class MobileSettingsPage extends ConsumerWidget {
  const MobileSettingsPage({super.key});

  Future<void> launchIt(String _url) async {
    final Uri url = Uri.parse(_url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    final globaldb = ref.watch(globalDBProvider);

    //
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,

      ///
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        title: Text(
          "Settings",
          style: GoogleFonts.montserratAlternates(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
      ),

      ///
      body: ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        itemCount: 7,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            shadowColor: currentTheme == ThemeMode.light
                ? const Color.fromRGBO(103, 161, 197, 0.329)
                : const Color(0xFF000000),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
            color: currentTheme == ThemeMode.light
                ? Colors.white
                : const Color(0xFF20262A),
            surfaceTintColor: Colors.transparent,
            child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                onTap: () {
                  index == 0
                      ? Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) =>
                                const MobilePermissionsPage()),
                          ),
                        )
                      : index == 1
                          ? ref
                              .read(ThemeModeStateProvider.notifier)
                              .changeState()
                          : index == 2
                              ? launchIt(globaldb.privacy!)
                              : index == 3
                                  ? launchIt(globaldb.terms!)
                                  : index == 4
                                      ? showDialog(
                                          context: context,
                                          builder: ((context) =>
                                              const SignOutDialog()),
                                        )
                                      : index == 5
                                          ? launchIt(
                                              globaldb.bugReportFeedback!)
                                          : showModalBottomSheet(
                                              showDragHandle: true,
                                              enableDrag: true,
                                              useSafeArea: true,
                                              context: context,
                                              backgroundColor: currentTheme ==
                                                      ThemeMode.light
                                                  ? Colors.white
                                                  : const Color(0xFF242A2E),
                                              builder: ((context) =>
                                                  const SizedBox(
                                                    height: 200,
                                                    child: Socials(),
                                                  )),
                                            );
                },

                ///
                title: Text(
                  index == 0
                      ? 'Permissions'
                      : index == 1
                          ? 'App look'
                          : index == 2
                              ? 'Privacy Policy'
                              : index == 3
                                  ? 'Terms and conditions'
                                  : index == 4
                                      ? 'Sign out'
                                      : index == 5
                                          ? 'Bug report and Feedback'
                                          : "Socials",
                  style: GoogleFonts.montserratAlternates(
                    color: currentTheme == ThemeMode.light
                        ? const Color(0xFF5E5E5E)
                        : const Color.fromRGBO(221, 221, 221, 1),
                    // const Color.fromRGBO(91, 91, 91, 1),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                leading: Icon(
                  index == 0
                      ? Icons.key_rounded
                      : (index == 1 && currentTheme == ThemeMode.light)
                          ? WalkItIcons.sun
                          : (index == 1 && currentTheme == ThemeMode.dark)
                              ? LineIcons.moon
                              : index == 2
                                  ? Icons.privacy_tip_outlined
                                  : index == 3
                                      ? LineIcons.book
                                      : index == 4
                                          ? WalkItIcons.signout
                                          : index == 5
                                              ? Icons.bug_report_outlined
                                              : LineIcons.globe,
                  color: index == 1 && currentTheme == ThemeMode.light
                      ? const Color(0xFFFFB700)
                      : index == 1 && currentTheme == ThemeMode.dark
                          ? const Color.fromRGBO(142, 141, 141, 1)
                          : index == 4 || index == 5
                              ? const Color(0xFFF16D75)
                              : const Color(0xFF11689E),
                ),
                trailing: index == 1
                    ? Text(
                        currentTheme == ThemeMode.light
                            ? "Light mode"
                            : currentTheme == ThemeMode.dark
                                ? "Night mode"
                                : "System",
                        style: GoogleFonts.montserratAlternates(
                          color: currentTheme == ThemeMode.light
                              ? const Color(0xFF5E5E5E)
                              : const Color.fromRGBO(122, 118, 118, 1),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      )
                    : null),
          );
        }),
      ),
    );
  }
}
