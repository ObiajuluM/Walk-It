import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:walk_it/providers/home.dart';
import 'package:walk_it/providers/primary.dart';

class MobilePermissionsPage extends ConsumerWidget {
  const MobilePermissionsPage({super.key});

  Future<Map<String, bool>> permissionsStatus() async {
    Health().configure(useHealthConnectIfAvailable: true);
    Health healthFactory = Health();

    return {
      "Location": await Geolocator.isLocationServiceEnabled() &&
          await Permission.location.isGranted,
      "Activity Recognition": await Permission.activityRecognition.isGranted,
      "Send Notification": await Permission.notification.isGranted,
      "Schedule Alarms": await Permission.scheduleExactAlarm.isGranted,
      "Ignore Battery Optimizations":
          await Permission.ignoreBatteryOptimizations.isGranted,
      "Read Step Data":
          await healthFactory.hasPermissions([HealthDataType.STEPS]) ?? false,
    };
  }

  Future<void> requestPerms(int index, WidgetRef ref) async {
    index == 0
        ? await Permission.location.request()
        : index == 1
            ? await Permission.activityRecognition.request()
            : index == 2
                ? await Permission.notification.request()
                : index == 3
                    ? await Permission.scheduleExactAlarm.request()
                    : index == 4
                        ? await Permission.ignoreBatteryOptimizations.request()
                        : ref.watch(healthDataProvider.notifier).getData();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(ThemeModeStateProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,

      ///
      appBar: AppBar(
        centerTitle: true,
        // automaticallyImplyLeading: false,
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
          "Permissions",
          style: GoogleFonts.montserratAlternates(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 0,
          ),
        ),
      ),

      ///
      body: FutureBuilder(
          future: permissionsStatus(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data != null
                ? ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => SwitchListTile(
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
                                        : index == 4
                                            ? "Allow me to run in background, without interruptions"
                                            : "Allow me to read step data from your preferred provider",
                        style: GoogleFonts.montserratAlternates(
                          color: currentTheme == ThemeMode.light
                              ? const Color(0xFF5E5E5E)
                              : const Color.fromRGBO(122, 118, 118, 1),
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          height: 0,
                        ),
                      ),
                      onChanged: (value) {
                        requestPerms(index, ref);
                      },
                    ),
                  )
                : const Center(child: Text("Loading..."));
          }),
    );
  }
}
