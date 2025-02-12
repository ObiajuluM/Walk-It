import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import 'package:flutter/services.dart';
// import 'package:wheel_chooser/wheel_chooser.dart';

class MobileGoalPage extends ConsumerStatefulWidget {
  const MobileGoalPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MobileGoalPageState();
}

class _MobileGoalPageState extends ConsumerState<MobileGoalPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final currentTheme = ref.watch(ThemeModeStateProvider);
    return Scaffold(
      backgroundColor: currentTheme == ThemeMode.light
          ? const Color(0xFFEFA159)
          : const Color(0xFF865527),
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: const BackButton(
          color: Color.fromRGBO(103, 161, 197, 1),
        ),
        title: Text(
          "Goal",
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
      ),

      ///
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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

          ///
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            children: [
              Container(
                height: 700,
                margin: const EdgeInsets.symmetric(horizontal: 70),
                // color: Colors.pink,

                ///
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    WheelChooser.integer(
                      physics: const BouncingScrollPhysics(),
                      listHeight: 600,
                      listWidth: 200,
                      selectTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                      unSelectTextStyle: const TextStyle(
                        color: Colors.white38,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                      onValueChanged: (value) async {
                        HapticFeedback.heavyImpact();
                      },
                      maxValue: 5000,
                      minValue: 1000,
                      initValue: user.dailyGoal, // set to original goal if any
                      step: 5,
                    ),

                    ///
                    Text(
                      "steps",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.montserratAlternates(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      ///
      bottomNavigationBar: Card(
        color: currentTheme == ThemeMode.light
            ? const Color(0xFF67A1C5)
            : const Color(0xFF394861),
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
              "Set Goal",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.montserratAlternates(
                color: Colors.white,
                fontSize: 17,
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
