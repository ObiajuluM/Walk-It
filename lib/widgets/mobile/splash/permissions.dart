import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walk_it/providers/dbconnect.dart';
import 'package:walk_it/providers/primary.dart';

class PermissionsPopUp extends ConsumerStatefulWidget {
  const PermissionsPopUp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PermissionsPopUpState();
}

class _PermissionsPopUpState extends ConsumerState<PermissionsPopUp> {
  Future<void> requestPerms(int index) async {
    index == 0
        ? await Permission.location.request()
        : index == 1
            ? await Permission.activityRecognition.request()
            : index == 2
                ? await Permission.notification.request()
                : index == 3
                    ? await Permission.scheduleExactAlarm.request()
                    : await Permission.ignoreBatteryOptimizations.request();
  }

  Future<Map<String, bool>> permissionsStatus() async {
    bool privacy = false;
    bool terms = false;

    SharedPreferences.getInstance().then((prefs) => {
          privacy = prefs.getBool("privacy") ?? false,
          terms = prefs.getBool("terms") ?? false
        });

    return {
      "Location": await Geolocator.isLocationServiceEnabled() &&
          await Permission.location.isGranted,
      "Activity Recognition": await Permission.activityRecognition.isGranted,
      "Send Notification": await Permission.notification.isGranted,
      "Schedule Alarms": await Permission.scheduleExactAlarm.isGranted,
      "Ignore Battery Optimizations":
          await Permission.ignoreBatteryOptimizations.isGranted,
      "Privacy Policy": privacy,
      "Terms and Conditions": terms,
    };
  }

  Future<void> launchIt(String _url) async {
    final Uri url = Uri.parse(_url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("permissions pop up built");
    final currentTheme = ref.watch(ThemeModeStateProvider);
    final globalDB = ref.watch(globalDBProvider);

    return FutureBuilder(
        // initialData: {},
        future: permissionsStatus(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) => index == 5
                      ? ListTile(
                          key: ValueKey(index),
                          onTap: () {
                            try {
                              launchIt(globalDB.privacy!);
                            } catch (e) {
                              log("splash permissions page error ${e.toString()}");
                            }
                          },
                          title: Text(
                            snapshot.data!.keys.toList()[index],
                            style: GoogleFonts.montserratAlternates(
                              color: currentTheme == ThemeMode.light
                                  ? const Color(0xFF5E5E5E)
                                  : const Color.fromRGBO(221, 221, 221, 1),
                              // const Color.fromRGBO(91, 91, 91, 1),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          subtitle: Text(
                            "Read and accept our privacy policy",
                            style: GoogleFonts.montserratAlternates(
                              color: currentTheme == ThemeMode.light
                                  ? const Color(0xFF5E5E5E)
                                  : const Color.fromRGBO(122, 118, 118, 1),
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                              height: 0,
                            ),
                          ),
                          trailing: Checkbox(
                              value: snapshot.data!.values.toList()[index],
                              onChanged: (value) {
                                SharedPreferences.getInstance().then((prefs) =>
                                    {
                                      prefs.setBool("privacy", true),
                                      setState(() {})
                                    });
                              }),
                        )

                      ///
                      : index == 6
                          ? ListTile(
                              key: ValueKey(index),
                              onTap: () {
                                try {
                                  launchIt(globalDB.terms!);
                                } catch (e) {
                                  log("splash permissions page error ${e.toString()}");
                                }
                              },
                              title: Text(
                                snapshot.data!.keys.toList()[index],
                                style: GoogleFonts.montserratAlternates(
                                  color: currentTheme == ThemeMode.light
                                      ? const Color(0xFF5E5E5E)
                                      : const Color.fromRGBO(221, 221, 221, 1),
                                  // const Color.fromRGBO(91, 91, 91, 1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              subtitle: Text(
                                "Read and accept our terms and conditions",
                                style: GoogleFonts.montserratAlternates(
                                  color: currentTheme == ThemeMode.light
                                      ? const Color(0xFF5E5E5E)
                                      : const Color.fromRGBO(122, 118, 118, 1),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                              trailing: Checkbox(
                                  value: snapshot.data!.values.toList()[index],
                                  onChanged: (value) {
                                    SharedPreferences.getInstance().then(
                                        (prefs) => {
                                              prefs.setBool("terms", true),
                                              setState(() {})
                                            });
                                  }),
                            )

                          ///
                          : SwitchListTile(
                              key: ValueKey(index),
                              isThreeLine: true,
                              // tileColor: Colors.transparent,
                              value: snapshot.data!.values.toList()[index],
                              title: Text(
                                snapshot.data!.keys.toList()[index],
                                style: GoogleFonts.montserratAlternates(
                                  color: currentTheme == ThemeMode.light
                                      ? const Color(0xFF5E5E5E)
                                      : const Color.fromRGBO(221, 221, 221, 1),
                                  // const Color.fromRGBO(91, 91, 91, 1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              subtitle: Text(
                                index == 0
                                    ? "Allow me to read location data"
                                    : index == 1
                                        ? "Allow me to know when you start walking"
                                        : index == 2
                                            ? "Allow me to send notifications"
                                            : index == 3
                                                ? "Allow me to send routine notifications"
                                                : "Allow me to run in background, without interruptions",
                                style: GoogleFonts.montserratAlternates(
                                  color: currentTheme == ThemeMode.light
                                      ? const Color(0xFF5E5E5E)
                                      : const Color.fromRGBO(122, 118, 118, 1),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
                              onChanged: (value) async {
                                await requestPerms(index)
                                    .then((value) => setState(() {}));
                              },
                            )),
                )
              : const Center(
                  child: Text("Loading..."),
                );
        });
  }
}
