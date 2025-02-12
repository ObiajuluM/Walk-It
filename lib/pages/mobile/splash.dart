import 'dart:async';
import 'dart:developer';
import 'package:action_slider/action_slider.dart';
import 'package:appcheck/appcheck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/people/v1.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:walk_it/misc/access_token.dart';
import 'package:walk_it/misc/backend.dart';
import 'package:walk_it/misc/backend_model.dart';
import 'package:walk_it/misc/models.dart';
import 'package:walk_it/pages/mobile/first.dart';
import 'package:walk_it/pages/mobile/fourth.dart';
import 'package:walk_it/pages/mobile/second.dart';
import 'package:walk_it/pages/mobile/third.dart';
import 'package:walk_it/providers/home.dart';
import 'package:walk_it/providers/splash.dart';
import 'package:walk_it/widgets/mobile/splash/permissions.dart';

class MobileSplashPage extends ConsumerStatefulWidget {
  const MobileSplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileSplashPageState();
}

class _MobileSplashPageState extends ConsumerState<MobileSplashPage> {
  final pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    print("first build splash page");
  }

  Future<bool> hasHealthConnect() async {
    bool enabled = false;
    try {
      enabled =
          await AppCheck().isAppEnabled("com.google.android.apps.healthdata");
    } catch (e) {
      log(e.toString());
    }
    return enabled;
  }

  Future<bool> permissionsEnabled() async {
    bool privacy = false;
    bool terms = false;

    SharedPreferences.getInstance().then((prefs) => {
          privacy = prefs.getBool("privacy") ?? false,
          terms = prefs.getBool("terms") ?? false
        });

    return await Geolocator.isLocationServiceEnabled() &&
        // await Permission.location.isGranted &&
        await Permission.activityRecognition.isGranted &&
        await Permission.notification.isGranted &&
        await Permission.scheduleExactAlarm.isGranted &&
        await Permission.ignoreBatteryOptimizations.isGranted &&
        // check if health connect is installed
        await hasHealthConnect() &&
        privacy &&
        terms;
  }

  requestStepPermission() async {
    // request health permissions
    Health().configure(useHealthConnectIfAvailable: true);
    Health healthFactory = Health();
    const List<HealthDataType> kdataTypes = [HealthDataType.STEPS];
    await healthFactory.hasPermissions(kdataTypes) ??
        await healthFactory.requestAuthorization(kdataTypes).then((value) {
          value == true
              ? ref.watch(healthDataProvider.notifier).getData()
              : requestStepPermission();
        });
  }

  // addNewUser(Person biodata) async {
  //   if (
  //       // user is signed in
  //       FirebaseAuth.instance.currentUser != null &&
  //           // is new user
  //           await isNewUser()) {
  //     // get constants to reward for sign up
  //     final constants = await FirebaseFirestore.instance
  //         .collection("Constants")
  //         .doc("Constant")
  //         .get();

  //     Position location = await Geolocator.getCurrentPosition();

  //     final newUser = WalkUser(
  //       uid: FirebaseAuth.instance.currentUser!.uid,
  //       firebaseName: FirebaseAuth.instance.currentUser!.displayName,
  //       displayName: ung.generate(
  //         seed: returnAppropriateIntForName(
  //             FirebaseAuth.instance.currentUser!.uid),
  //       ),
  //       email: FirebaseAuth.instance.currentUser!.email,
  //       dob: {
  //         "day": biodata.birthdays?.firstOrNull?.date?.day,
  //         "month": biodata.birthdays?.firstOrNull?.date?.month,
  //         "year": biodata.birthdays?.firstOrNull?.date?.year,
  //       },
  //       gender: biodata.genders?[0].formattedValue,
  //       signUpLocation: LocationSnapshot(
  //         lat: location.latitude,
  //         long: location.longitude,
  //         time: DateTime.now(),
  //       ),
  //       inviteCode: generateInviteCode(FirebaseAuth.instance.currentUser!.uid),
  //       balance: double.parse('${constants["signUpBonus"]}'),
  //       claims: [],
  //     );

  //     try {
  //       // add user
  //       await FirebaseFirestore.instance
  //           .collection('Users')
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           .set(newUser.toJson())
  //           .then((onValue) {});

  //       /// add the user invite code to the invite db
  //       await FirebaseFirestore.instance
  //           .collection('Invites')
  //           .doc(generateInviteCode(FirebaseAuth.instance.currentUser!.uid))
  //           .set({
  //         generateInviteCode(FirebaseAuth.instance.currentUser!.uid):
  //             ung.generate(
  //           seed: returnAppropriateIntForName(
  //               FirebaseAuth.instance.currentUser!.uid),
  //         ),
  //       });
  //     } catch (e) {
  //       log(e.toString());
  //     }
  //   }
  // }

  Future<void> signInWithGoogle() async {
    // .then everything
    // showDialog(context: context, builder: (context) => const IdkLoading());
    try {
      // begin interactive process
      final user = GoogleSignIn(scopes: [
        // give me access to read your gender and birthday
        PeopleServiceApi.userBirthdayReadScope,
        PeopleServiceApi.userGenderReadScope,
        PeopleServiceApi.userinfoProfileScope,
      ]);

      // sign in with google
      final gUser = await user.signIn();

      // get birthday day and gender
      final httpclient = (await user.authenticatedClient())!;
      final peopleApi = PeopleServiceApi(httpclient);
      final biodata = await peopleApi.people.get(
        "people/me",
        personFields:
            "birthdays,genders", // add more fields with comma separated and no space
      );

      // obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // create a new user credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // finally, lets sign in
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        // get location
        Position location = await Geolocator.getCurrentPosition();
        //  TODO: do me

        //  create new user in backend db
        await WalkItBackendAuth()
            .signInWithCredential(
          djangoClientId: "SMZAC3o1gZjggRDVSJQKoigVv5C15vcbTst0xTOs",
          googleAccessToken: gAuth.accessToken,
        )
            .then((onValue) async {
          //  modify user variables
          await modifyUser({
            "display_name": ung.generate(
              seed: returnAppropriateIntForName(
                  FirebaseAuth.instance.currentUser!.email!),
            ),
            "gender": biodata.genders?[0].formattedValue,
            "dob": toDate(
              DateTime(
                biodata.birthdays?.firstOrNull?.date?.year ?? 1500,
                biodata.birthdays?.firstOrNull?.date?.month ?? 00,
                biodata.birthdays?.firstOrNull?.date?.day ?? 00,
              ),
            ),
            "lat": location.latitude.toStringAsFixed(6),
            "long": location.longitude.toStringAsFixed(6),
          });

          // await writeAccessTokenToLocal(onValue);
        });

        // modify user in backend db

        // add new firebase user
        // addNewUser(biodata);
        //
        requestStepPermission();
      });
    } catch (e) {
      if (!mounted) return;

      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(splashPageCurrentIndexProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: PageView.builder(
        controller: pageController,
        itemCount: 4,
        onPageChanged: (value) {
          ref.read(splashPageCurrentIndexProvider.notifier).setIndex(value);
        },
        itemBuilder: ((context, index) => const [
              MobileFirstPage(),
              MobileSecondPage(),
              MobileThirdPage(),
              MobileFourthPage(),
            ].elementAt(index)),
      ),

      ///
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,

      ///
      floatingActionButton: currentPage == 2
          ? Container(
              margin: const EdgeInsets.all(10),
              child: ActionSlider.standard(
                backgroundColor: const Color(0xFF3A028E),
                toggleColor: const Color(0xFF7520CC),
                backgroundBorderRadius: BorderRadius.circular(16),
                foregroundBorderRadius: BorderRadius.circular(16),

                icon: Lottie.asset(
                  Icons8.key_password,
                  fit: BoxFit.fill,
                  height: 25,
                  width: 25,
                  alignment: Alignment.center,
                ),

                child: Text(
                  "Request Permissions",
                  style: GoogleFonts.montserratAlternates(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                action: (controller) async {
                  controller.loading(); //starts loading animation
                  showModalBottomSheet(
                    showDragHandle: true,

                    context: context,
                    // backgroundColor: Colors.black,

                    builder: (context) {
                      return StatefulBuilder(
                          builder: (context, state) =>
                              const PermissionsPopUp());
                    },
                  ).then((onValue) async {
                    if (await permissionsEnabled() == true) {
                      ref
                          .watch(splashPageCurrentIndexProvider.notifier)
                          .setIndex(3);

                      pageController.jumpToPage(3);
                    }

                    controller.reset(); //starts success animation
                  });
                },
                //many more parameters
              )

              // SlideAction(
              //   borderRadius: 16,
              //   // animationDuration: Duration(seconds: 1),

              //   alignment: Alignment.bottomCenter,
              //   elevation: 0,
              //   innerColor: const Color(0xFF7520CC),
              //   outerColor: const Color(0xFF3A028E),
              //   sliderButtonIcon: Lottie.asset(
              //     Icons8.key_password,
              //     fit: BoxFit.fill,
              //     height: 25,
              //     width: 25,
              //     alignment: Alignment.center,
              //   ),
              //   submittedIcon: Lottie.asset(
              //     Icons8.key_password,
              //     fit: BoxFit.fill,
              //     height: 25,
              //     width: 25,
              //     alignment: Alignment.center,
              //   ),
              //   text: "Request Permissions",
              //   sliderRotate: true,
              //   textStyle: GoogleFonts.montserratAlternates(
              //     color: const Color.fromRGBO(255, 255, 255, 1),
              //     fontSize: 20,
              //     fontWeight: FontWeight.w500,
              //   ),
              //   onSubmit: () {
              //     showModalBottomSheet(
              //       showDragHandle: true,

              //       context: context,
              //       // backgroundColor: Colors.black,

              //       builder: (context) {
              //         return StatefulBuilder(
              //             builder: (context, state) =>
              //                 const PermissionsPopUp());
              //       },
              //     );
              //     return null;
              //   },
              // ),

              )
          : currentPage == 3
              ? FutureBuilder(
                  future: permissionsEnabled(),
                  builder: (context, snapshot) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      child: snapshot.connectionState == ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data == true
                          ? ActionSlider.standard(
                              backgroundBorderRadius: BorderRadius.circular(16),
                              foregroundBorderRadius: BorderRadius.circular(16),
                              toggleColor: const Color(0xFF2183CD),
                              backgroundColor: const Color(0xFF025E8E),
                              icon: Lottie.asset(
                                Icons8.walk,
                                fit: BoxFit.fill,
                                height: 25,
                                width: 25,
                                alignment: Alignment.center,
                              ),
                              loadingIcon: Lottie.asset(
                                Icons8.load_from_cloud,
                                fit: BoxFit.fill,
                                height: 25,
                                width: 25,
                                alignment: Alignment.center,
                              ),
                              action: (controller) async {
                                controller.loading();
                                //do something

                                try {
                                  await signInWithGoogle();
                                } catch (e) {
                                  log(e.toString());
                                }

                                if (FirebaseAuth.instance.currentUser == null) {
                                  controller.reset();
                                }
                                // controller.success();

                                // controller.reset();
                              },
                              child: Text(
                                "Sign in with Google",
                                style: GoogleFonts.montserratAlternates(
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : Text(
                              "Please allow all permissions and enable health connect!",
                              style: GoogleFonts.montserratAlternates(
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    );
                  },
                )
              : null,
    );
  }
}
