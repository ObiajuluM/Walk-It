import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/pages/mobile/discover.dart';
import 'package:walk_it/pages/mobile/home.dart';
import 'package:walk_it/pages/mobile/profile.dart';
import 'package:walk_it/pages/mobile/settings.dart';
import 'package:walk_it/providers/home.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/walk_it_icons_icons.dart';

// widgetor Colorful widgets

class MobilePrimaryPage extends ConsumerStatefulWidget {
  const MobilePrimaryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobilePrimaryPageState();
}

class _MobilePrimaryPageState extends ConsumerState<MobilePrimaryPage> {
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    print("first build primary page");
    // Future(() => loadData());
  }

  // ff() {
  //   FirebaseFirestore.instance
  //       .collection('LeaderBoard')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .set(LeaderBoard(
  //               displayName: 'Inner DamselFly',
  //               day: 3,
  //               month: 10,
  //               year: 2024,
  //               steps: 10000)
  //           .toJson());
  // }

  loadData(int index) async {
    // ff();
    try {
      if (index == 0) {
        //greet
        ref.read(greetingProvider.notifier).greet();
        // get health
        ref.read(healthDataProvider.notifier).getData();
        // get user
        ref
            .read(userProvider.notifier)
            .getData(FirebaseAuth.instance.currentUser!.uid);
        //  get backend user
        await ref.read(backendUserProvider.notifier).getData();

        log("called page 0");
      } else if (index == 1) {
        // get user
        ref
            .read(userProvider.notifier)
            .getData(FirebaseAuth.instance.currentUser!.uid);
        //  get backend user
        await ref.read(backendUserProvider.notifier).getData();
        log("called page 1");
      } else if (index == 2) {
      } else if (index == 3) {
        ref.read(globalDBProvider.notifier).getData();
      }

      // load user
      // ref
      //     .read(userProvider.notifier)
      //     .getData(FirebaseAuth.instance.currentUser!.uid);

      // update location on discover page
      // if (page == 0) {
      //   final currentLocation = await Geolocator.getCurrentPosition();
      //   await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(FirebaseAuth.instance.currentUser!.uid)
      //       .update({
      //     'currentLocation': Location(
      //             lat: currentLocation.latitude, long: currentLocation.longitude)
      //         .toJson(),
      //   });
      // }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///
    final currentPage = ref.watch(primaryPageCurrentIndexProvider);
    final currentTheme = ref.watch(ThemeModeStateProvider);

    //
    Future(() async {
      await loadData(currentPage);
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,

      ///
      body: PageView.builder(
        // allowImplicitScrolling: true,
        controller: pageController,
        itemCount: 4,
        onPageChanged: (value) async {
          ref.read(primaryPageCurrentIndexProvider.notifier).setIndex(value);
        },
        itemBuilder: ((context, index) => const [
              MobileHomePage(),
              MobileProfilePage(),
              MobileDiscoverPage(),
              MobileSettingsPage(),
            ].elementAt(index)),
      ),

      ///
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 8.0,
        ),
        child: Container(
          height: 86,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            shadows: [
              currentTheme == ThemeMode.light
                  ? const BoxShadow(
                      color: Color.fromRGBO(103, 161, 197, 0.329),
                      blurRadius: 16.10,
                      offset: Offset(0, 4),
                      spreadRadius: 12,
                    )
                  : const BoxShadow(
                      color: Color(0x9E000000),
                      blurRadius: 26.60,
                      offset: Offset(0, 4),
                      spreadRadius: 11,
                    ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentPage,
            onTap: (index) async {
              // jump to pages
              ref
                  .read(primaryPageCurrentIndexProvider.notifier)
                  .setIndex(index);
              pageController.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(WalkItIcons.home),
                label: "_",
                tooltip: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(WalkItIcons.profile),
                label: "_",
                tooltip: "Profile",
              ),
              BottomNavigationBarItem(
                icon: Icon(WalkItIcons.discover),
                label: "_",
                tooltip: "Discover",
              ),
              BottomNavigationBarItem(
                icon: Icon(WalkItIcons.settings),
                label: "_",
                tooltip: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
