import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileSecondPage extends ConsumerWidget {
  const MobileSecondPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [
            Color(0xFF830C3B),
            Color(0xFFC02E5A),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            title: Text(
              'Welcome to',
              style: GoogleFonts.montserratAlternates(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            subtitle: const Text(
              'WALK IT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 44,
                fontWeight: FontWeight.w900,
                height: 0,
              ),
            ),
          ),

          ///
          Center(
            child: Image.asset(
              "lib/assets/3d/Pink.gif",
              // height: 125.0,
              // width: 125.0,
              width: 605.47,
              height: 512,

              fit: BoxFit.cover,
            ),
          ),

          ///
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Walk It rewards you with your steps at the end of the day. Make sure your phone is connected to the internet to sync your steps.',
              style: GoogleFonts.montserratAlternates(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
