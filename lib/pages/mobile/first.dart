import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileFirstPage extends ConsumerWidget {
  const MobileFirstPage({super.key});

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
            Color(0xFF83350D),
            Color(0xFFC37030),
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
              "lib/assets/3d/Brown.gif",
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
              """The lifestyle dapp that rewards you to walk.

            """,
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
