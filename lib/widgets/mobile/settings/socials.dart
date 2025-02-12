import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/providers/primary.dart';

class Socials extends ConsumerWidget {
  const Socials({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    final globaldb = ref.watch(globalDBProvider);

    Future<void> launchIt(String _url) async {
      final Uri url = Uri.parse(_url);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) => ListTile(
        onTap: () async {
          index == 0
              ? launchIt(globaldb.X!)
              : index == 1
                  ? launchIt(globaldb.website!)
                  : launchIt(globaldb.telegram!);
        },
        leading: index == 0
            ? LineIcon.twitter(
                color: currentTheme == ThemeMode.light
                    ? Colors.blue
                    : Colors.white,
              )
            : index == 1
                ? LineIcon.globeWithAfricaShown(
                    color: currentTheme == ThemeMode.light
                        ? Colors.blueAccent
                        : Colors.blue,
                  )
                : LineIcon.telegram(
                    color: currentTheme == ThemeMode.light
                        ? Colors.blue
                        : Colors.white,
                  ),
        title: Text(
          index == 0
              ? "X"
              : index == 1
                  ? "Website"
                  : "Telegram",
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
    );
  }
}
