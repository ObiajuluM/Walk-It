import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class IdkLoading extends ConsumerWidget {
  const IdkLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Center(
        child: IconButton(
          onPressed: () {},
          icon: Lottie.asset(
            addRepaintBoundary: true,
            Icons8.walk,
            fit: BoxFit.fitWidth,
            height: 50,
            width: 50,
          ),
        ),
      ),
    );
  }
}
