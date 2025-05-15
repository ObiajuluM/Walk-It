import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:walk_it/firebase_options.dart';
import 'package:walk_it/misc/backend.dart';

// notification channel id
const androidNotificationChannelId = "Walk It";

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 12345;

// channel description
const channelDescription = "Walk It foreground channel";

Future<void> initializeBkgService() async {
  try {
    // create notification channel instance
    const notificationChannel = AndroidNotificationChannel(
      androidNotificationChannelId,
      androidNotificationChannelId,
      description: channelDescription,
      importance: Importance.low,
      showBadge: false,
    );

    // init local notification
    final flnp = FlutterLocalNotificationsPlugin();

    await flnp
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .initialize(
          const AndroidInitializationSettings("@mipmap/ic_launcher"),
        );

    //req permission
    await flnp
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    //req permission
    await flnp
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestExactAlarmsPermission();

    // create notification channel for platform
    await flnp
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(notificationChannel);

    // create background service instance
    final service = FlutterBackgroundService();

    // configure service
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStartOnBoot: true,
        autoStart: true,
        foregroundServiceNotificationId: notificationId,
        notificationChannelId: androidNotificationChannelId,
        initialNotificationTitle: "",
        initialNotificationContent: "Initializing...",
      ),
      iosConfiguration: IosConfiguration(),
    );
  } catch (e) {
    print("print bkg $e");
  }
}

@pragma('vm:entry-point')
onStart(ServiceInstance service) async {
  // init dart plugin - might remove this
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore db = FirebaseFirestore.instance;

  if (service is AndroidServiceInstance) {
    // listen to see if service is foreground
    service.on('setAsForeground').listen((onData) {
      service.setAsForegroundService();
    });
    // listen to see if service is background
    service.on('setAsBackground').listen((onData) {
      service.setAsBackgroundService();
    });
    // listen to see if service is stopped
    service.on('stopService').listen((onData) {
      service.stopSelf();
    });
  }

  // init local notification
  final flnp = FlutterLocalNotificationsPlugin();

  // show local notification periodically
  Timer.periodic(const Duration(minutes: 15), (timer) async {
    // checks if service is currently running on an android device and if service is currently set to foreground
    if (service is AndroidServiceInstance &&
        await service.isForegroundService()) {
      // do health
      await Health().configure(useHealthConnectIfAvailable: true);
      Health healthFactory = Health();
      bool hasPermission = false;
      int healthSteps = 0;

      /// get health
      try {
        const kdataTypes = [HealthDataType.STEPS];
        // get steps for today (i.e., since midnight)
        // today
        final now = DateTime.now();
        // midnight
        final midnight = DateTime(now.year, now.month, now.day);
        hasPermission = await healthFactory.hasPermissions(kdataTypes) ?? false;
        if (hasPermission) {
          // get steps
          healthSteps =
              await healthFactory.getTotalStepsInInterval(midnight, now) ?? 0;
        } else {
          hasPermission = await healthFactory.requestAuthorization(kdataTypes);
        }
      } catch (e) {
        log("error on bg step get $e");
      }

      if (DateTime.now().hour == 23 && healthSteps >= 100) {
        log("enter 1");
        //  if the getUserLastRecordedSteps fails, it is most likely because
        // there was no object to modify in the first place, so skip the error and show love
        try {
          final lastRecorded = await getUserLastRecordedSteps();
        } catch (e) {
          log("showed love due to error");
          uploadSteps(healthSteps);
        }

        try {
          final lastRecorded = await getUserLastRecordedSteps();
          final lastTime = DateFormat('yyyy-MM-dd').parse(lastRecorded["time"]);

          if (DateTime.now().year != lastTime.year &&
              DateTime.now().month != lastTime.month &&
              DateTime.now().day != lastTime.day) {
            log("enter 2");
            uploadSteps(healthSteps);
          }
        } catch (e) {
          log(e.toString());
        }
      }

      /// Show love
      // try {
      //   /// do rewards and leader board
      //   // if hour is 11 o'clock and your steps is greater than or equal to 1000
      //   if (DateTime.now().hour == 23 && healthSteps >= 1000) {
      //     log("enter 1");
      //     // get user and cast as Walk user object
      //     var dbUser = await db
      //         .collection('Users')
      //         .doc(FirebaseAuth.instance.currentUser!.uid)
      //         .get();
      //     final user = WalkUser.fromJson(dbUser.data()!);

      //     // if your last seen location day is not equal to today
      //     if (DateTime.now().day.toString() !=
      //         user.lastSeenLocation?.time?.day.toString()) {
      //       log("enter 2");
      //       // get constants and cast as global db object
      //       var dbConstants =
      //           await db.collection('Constants').doc('Constant').get();
      //       final constants = GlobalDb.fromJson(dbConstants.data()!);

      //       // get location
      //       final location = await Geolocator.getCurrentPosition();

      //       // if your health steps is greater than max steps to reward, set your steps to reward as max steps
      //       int healthStepsToReward = healthSteps >= constants.maxStepsToReward!
      //           ? constants.maxStepsToReward!
      //           : healthSteps;

      //       double reward = healthStepsToReward * constants.wpPerStep!;

      //       // show love and modify your userbase
      //       await db
      //           .collection('Users')
      //           .doc(FirebaseAuth.instance.currentUser!.uid)
      //           .update({
      //         'lastSeenLocation': LocationSnapshot(
      //           lat: location.latitude,
      //           long: location.longitude,
      //           time: DateTime.now(),
      //         ).toJson(),
      //         'balance':
      //             FieldValue.increment(double.parse(reward.toStringAsFixed(2))),
      //         'claims': FieldValue.arrayUnion([
      //           Claim(
      //             date: DateTime.now(),
      //             stepsRecorded: healthSteps,
      //             stepsRewarded: healthStepsToReward,
      //             amountRewarded: double.parse(reward.toStringAsFixed(2)),
      //             wpPerStep: constants.wpPerStep!,
      //           ).toJson(),
      //         ]),
      //       });

      //       /// Leaderboard stuff
      //       await db
      //           .collection('LeaderBoard')
      //           .doc(FirebaseAuth.instance.currentUser!.uid)
      //           .set(LeaderBoard(
      //             displayName: user.displayName,
      //             steps: healthSteps,
      //             year: DateTime.now().year,
      //             month: DateTime.now().month,
      //             day: DateTime.now().day,
      //           ).toJson());

      //       ///
      //     } else {
      //       log("Already claimed and leaderboarded");
      //     }
      //   }
      // } catch (e) {
      //   log("error in showing love $e");
      // }

      flnp.show(
        notificationId,
        null,
        "$healthSteps steps today",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            androidNotificationChannelId,
            androidNotificationChannelId,
            channelDescription: channelDescription,
            icon: '@mipmap/ic_launcher',
            importance: Importance.low,
            priority: Priority.low,
            autoCancel: false,
            channelShowBadge: false,
            ongoing: true,
            color: Colors.transparent,
            silent: true,
            category: AndroidNotificationCategory.progress,
            showWhen: false, // disables notification time stamp
            when: null,
          ),
        ),
      );
    }
  });
}
