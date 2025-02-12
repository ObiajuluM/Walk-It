import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walk_it/providers/primary.dart';

class MobileDeletePage extends ConsumerWidget {
  const MobileDeletePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: currentTheme == ThemeMode.light
                ? [
                    const Color.fromRGBO(65, 115, 243, 1),
                    const Color.fromRGBO(112, 172, 185, 1),
                    const Color.fromRGBO(241, 109, 117, 1),
                  ]
                : [
                    const Color(0xFF1B326B),
                    const Color(0xFF33535A),
                    const Color(0xFF531317),
                  ],
          ),
        ),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                "We'd hate to see you go",
                style: GoogleFonts.montserratAlternates(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),

              ///
              trailing: CloseButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.transparent.withOpacity(0.5),
                  surfaceTintColor: Colors.pink,
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            ///

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Text(
                "How can we improve?",
                style: GoogleFonts.montserratAlternates(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  height: 2,
                ),
              ),
            ),

            ///
            AspectRatio(
              aspectRatio: 0.9,
              child: Card(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text("data"),
              ),
            ),

            ///
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Lorem ipsum dolor sit amet consectetur. Aliquet eget arcu aenean tempor iaculis et molestie. Et massa et neque mi eget. Mauris ut id pretium porta elit nec. Tristique lacus bibendum enim at pulvinar neque.',
                style: GoogleFonts.montserratAlternates(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Card(
        color: const Color(0xFFFF404C), // for light mode
        margin: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          enableFeedback: true,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Text(
              "Delete Account",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.montserratAlternates(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
