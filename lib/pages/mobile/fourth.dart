import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileFourthPage extends ConsumerWidget {
  const MobileFourthPage({super.key});

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
            Color(0xFF025E8E),
            Color(0xFF2183CD),
          ],
        ),
      ),

      ///
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
              "lib/assets/3d/Blue.gif",
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
              'Lorem ipsum dolor sit amet consectetur. Cum scelerisque semper egestas nibh ut lectus. Vel a sed enim porta congue hac imperdiet.',
              style: GoogleFonts.montserratAlternates(
                color: Colors.transparent,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          )
        ],
      ),

      ///
    );
  }
}
