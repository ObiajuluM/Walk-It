import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:walk_it/misc/access_token.dart';
import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/providers/primary.dart';

class SignOutDialog extends ConsumerWidget {
  const SignOutDialog({super.key});

  Future<void> signOut() async {
    final accessToken = await retrieveAccessTokenFromLocal();
    await WalkItBackendAuth().signOut(
        accessToken!,
        "SMZAC3o1gZjggRDVSJQKoigVv5C15vcbTst0xTOs",
        "http://192.168.1.61:8080/auth/invalidate-sessions/",
        "http://192.168.1.61:8080/auth/invalidate-refresh-tokens/");
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: currentTheme == ThemeMode.light
          ? Colors.white
          : const Color(0xFF242B2E),
      actionsAlignment: MainAxisAlignment.center,
      title: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          'You are about to sign out!',
          style: GoogleFonts.montserratAlternates(
            color: const Color(0xFFE9222E),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
        trailing: CloseButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: currentTheme == ThemeMode.light
                ? const Color(0xFF67A1C5)
                : const Color(0xFF394861),
            foregroundColor: Colors.white,
          ),
        ),
      ),

      ///
      content: Text(
        "Thanks for walking with us! See you later, Walker! Don't forget to lace up those shoes tomorrow.",
        // textAlign: TextAlign.center,
        style: GoogleFonts.montserratAlternates(
          color: currentTheme == ThemeMode.light ? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      ),
      actions: [
        Card(
          color: const Color(0xFFF16D75),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          surfaceTintColor: Colors.transparent,
          child: InkWell(
            radius: 15,
            onTap: () {
              ref.read(primaryPageCurrentIndexProvider.notifier).setIndex(0);

              signOut().then((value) {
                Navigator.of(context).pop();
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 80,
                vertical: 20,
              ),
              child: Text(
                "Ok",
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.montserratAlternates(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  height: 0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
