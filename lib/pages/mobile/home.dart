import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walk_it/widgets/mobile/home/appbar.dart';
import 'package:walk_it/widgets/mobile/home/explore.dart';
import 'package:walk_it/widgets/mobile/home/leaderboard.dart';

class MobileHomePage extends ConsumerStatefulWidget {
  const MobileHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends ConsumerState<MobileHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,

      // appBar: MobileHomeAppBar(),

      ///
      body: SingleChildScrollView(
        child: Column(
          children: [
            MobileHomeAppBar(),

            ///
            Explore(),

            ///
            Leaderboard(),
          ],
        ),
      ),
    );
  }
}
