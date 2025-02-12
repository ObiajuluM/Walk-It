import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:walk_it/widgets/mobile/balance/appbar.dart';

class MobileBalancePage extends ConsumerStatefulWidget {
  const MobileBalancePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileBalancePageState();
}

class _MobileBalancePageState extends ConsumerState<MobileBalancePage> {
  @override
  Widget build(BuildContext context) {
    // final backendUser = ref.watch(backendUserProvider);
    final currentTheme = ref.watch(ThemeModeStateProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,

      ///
      appBar: const MobileBalanceAppBar(),

      // body:  use list view.seperated by the date,

      body: FutureBuilder(
        future: getUserClaims(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => Card(
                    surfaceTintColor: Colors.transparent,
                    color: currentTheme == ThemeMode.light
                        ? Colors.white
                        : const Color(0xFF20262A),
                    shadowColor: currentTheme == ThemeMode.light
                        ? const Color(0x5467A1C5)
                        : const Color(0xFF000000),
                    clipBehavior: Clip.antiAlias,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.all(7),
                      childrenPadding: EdgeInsets.all(0),
                      shape: const Border(),
                      leading: LineIcon.walking(
                        color: currentTheme == ThemeMode.light
                            ? const Color.fromRGBO(103, 161, 197, 1)
                            : const Color(0xFF394760),
                      ),
                      // contentPadding: const EdgeInsets.all(10),
                      title: Text(
                        DateFormat.yMMMMEEEEd()
                            .format(snapshot.data!.elementAt(index).time!),
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
                      children: [
                        ListTile(
                          title: Text(
                            "Steps Rewarded: ${snapshot.data!.elementAt(index).steps_rewarded.toString()} / ${snapshot.data!.elementAt(index).steps_recorded.toString()}",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserratAlternates(
                              color: currentTheme == ThemeMode.light
                                  ? const Color(0xFF5E5E5E)
                                  : const Color.fromARGB(255, 141, 138, 138),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          subtitle: Text(
                            "Amount Rewarded: ${snapshot.data!.elementAt(index).amount_rewarded.toString()}",
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
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'In every walk with nature, one receives far more than he seeks.',
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
