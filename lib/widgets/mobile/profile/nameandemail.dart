import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/walk_it_icons_icons.dart';

class NameandEmail extends ConsumerWidget {
  const NameandEmail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    final user = ref.watch(userProvider);

    ///
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: currentTheme == ThemeMode.light
          ? const Color(0x5467A1C5)
          : const Color(0xFF000000),
      surfaceTintColor: Colors.transparent,
      color: currentTheme == ThemeMode.light
          ? Colors.white
          : const Color(0xFF20262A),
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 20,
        bottom: 20,
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        shrinkWrap: true,
        separatorBuilder: (context, index) => const Divider(
          endIndent: 70,
          indent: 70,
          height: 0,
          color: Color.fromRGBO(103, 161, 197, 0.4),
        ),
        itemBuilder: (context, index) => ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          // tileColor:
          leading: Icon(
            index == 0 ? Icons.person_outline_outlined : WalkItIcons.email,
            color: const Color(0x93E5737C),
          ),
          title: Text(
            index == 0
                ? user.firebaseName ??
                    FirebaseAuth.instance.currentUser!.displayName!
                : user.email ?? FirebaseAuth.instance.currentUser!.email!,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserratAlternates(
              color: currentTheme == ThemeMode.light
                  ? const Color.fromRGBO(143, 143, 143, 1)
                  : const Color.fromRGBO(221, 221, 221, 1),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}
