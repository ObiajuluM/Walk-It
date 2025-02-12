import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/widgets/mobile/referrals.dart/appbar.dart';

/// what i want to do
/// create a document with

class MobileReferralsPage extends ConsumerWidget {
  const MobileReferralsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    // final user = ref.watch(userProvider);

    //
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        resizeToAvoidBottomInset: true,
        appBar: const MobileReferralsAppBar(),

        ///
        body: FutureBuilder(
            future: getUserInvites(),
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data!.isNotEmpty
                  ? ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Card(
                        surfaceTintColor: Colors.transparent,
                        color: currentTheme == ThemeMode.light
                            ? Colors.white
                            : const Color(0xFF20262A),
                        shadowColor: currentTheme == ThemeMode.light
                            ? const Color(0x5467A1C5)
                            : const Color(0xFF000000),
                        clipBehavior: Clip.antiAlias,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: SizedBox(
                            height: 34,
                            width: 34,
                            child: RandomAvatar(
                                snapshot.data!.elementAt(index).display_name!),
                          ),
                          title: Text(
                            snapshot.data!.elementAt(index).display_name!,
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
                      ),
                    )
                  : Center(
                      child: Text(
                        "Don't walk in front of me… I may not follow, Don't walk behind me… I may not lead, Walk beside me… just be my friend",
                        textAlign: TextAlign.center,
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
            })

        // Center(
        //     child: Text(
        //       "Don't walk in front of me… I may not follow Don't walk behind me… I may not lead Walk beside me… just be my friend",
        //       textAlign: TextAlign.start,
        //       style: GoogleFonts.montserratAlternates(
        //         color: currentTheme == ThemeMode.light
        //             ? const Color(0xFF5E5E5E)
        //             : const Color.fromRGBO(221, 221, 221, 1),
        //         fontSize: 13,
        //         fontWeight: FontWeight.w500,
        //         height: 0,
        //       ),
        //     ),
        //   ),
        );
  }
}
