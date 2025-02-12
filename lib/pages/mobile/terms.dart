import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileTermsandConditionsPage extends ConsumerWidget {
  const MobileTermsandConditionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,

      ///
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          "Terms and conditions",
          style: GoogleFonts.montserratAlternates(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Text(
            "Lorem ipsum dolor sit amet consectetur. Condimentum sed sodales euismod faucibus elementum suspendisse fringilla pretium ullamcorper. Ornare mi rhoncus sit proin odio. Porttitor integer vitae ipsum vel id vulputate. Nibh donec nunc sapien \n\npellentesque. Euismod tortor pretium tincidunt amet vitae fringilla. Quis purus mi quam pellentesque ut enim et. Posuere libero a quam tincidunt lectus rhoncus sollicitudin. Orci sagittis magna metus in ipsum sit pulvinar quam. Viverra in nec vitae molestie dui urna nibh sed egestas. Et non lacus in quis rhoncus nec quis placerat. Non mattis eleifend nisi dictum nunc pellentesque. Enim tortor erat lacus volutpat lobortis pharetra hendrerit. Habitant congue et quisque egestas sed est suscipit amet. Iaculis etiam \n\nfaucibus sem metus viverra proin. Dolor a iaculis cursus et dictumst ultricies elit. Molestie in morbi pharetra rhoncus risus tellus in. Tellus integer non sodales proin massa purus. Massa purus donec et diam non vestibulum dui faucibus augue. Libero est non sit elementum cras at. Risus suspendisse massa purus cras amet rutrum non in rhoncus. Tempor lectus donec duis diam eget quis ultrices blandit habitasse. Quis eget dignissim aliquet at. Eget dictumst condimentum semper leo. Fringilla sed platea a non ac tempus elit. Pellentesque ultrices pharetra mattis sit et. Morbi pellentesque elit convallis tristique interdum pulvinar. Malesuada venenatis tempor non vestibulum massa urna lorem habitant \n\nlectus. Ut vel ornare cras rhoncus. Suscipit laoreet sed sed sit eros. Phasellus scelerisque ipsum a massa. Est in in vel orci ultrices in. Nisi eget fames in vitae odio hac a. Volutpat ultrices ac facilisis feugiat purus habitasse faucibus mi. In maecenas purus tempor nunc in diam vitae leo. Ullamcorper nulla in platea arcu. Feugiat pharetra magna sollicitudin odio malesuada est. Lectus dignissim hendrerit maecenas suspendisse. Orci nunc sit nibh s\n\nit egestas. Magna sollicitudin vulputate aliquam porttitor id suscipit. Proin amet imperdiet velit semper elementum commodo. vestibulum nulla aliquam scelerisque lacus amet consectetur tortor. Ac massa urna in sit iaculis dui scelerisque.',",
            style: GoogleFonts.montserratAlternates(
              color: const Color(0xFF6C6C6C),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          )
        ],
      ),
    );
  }
}
