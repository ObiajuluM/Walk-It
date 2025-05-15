import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walk_it/misc/access_token.dart';
import 'package:walk_it/pages/mobile/primary.dart';
import 'package:walk_it/pages/mobile/splash.dart';
import 'package:walk_it/providers/primary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:walk_it/providers/splash.dart';
import 'package:walk_it/misc/background.dart';
import 'firebase_options.dart';

// TODO: AD we are at liberty of doing with your points as we wiish - they have no value

// TODO: make it only work on one device

/// in future updates add support to automatically share to social media at the end of the day

/// in future updates - add a popup if health connect isnt installed
/// then req to install health connect

// Future<void> installHealthConnect() async {
//   await Health().installHealthConnect();
// }

// add a versioning system to db to make block later version users from making requests

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // enable appcheck
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  // );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // set status bar color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(103, 161, 197, 0.329),
    ),
  );

  // do background stuff
  if (await FlutterBackgroundService().isRunning() == false) {
    await initializeBkgService();
    FlutterBackgroundService().invoke('setAsForeground');
  }

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  night() {
    SharedPreferences.getInstance().then((prefs) {
      bool isNight = prefs.getBool('night') ?? false;
      if (isNight == true) {
        ref.read(ThemeModeStateProvider.notifier).toDark();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    night();

    return SafeArea(
      child: MaterialApp(
        // // for visuals
        // useInheritedMediaQuery: true,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,

        ///
        debugShowCheckedModeBanner: false,
        // debugShowMaterialGrid: true,
        themeMode: ref.watch(ThemeModeStateProvider),
        theme: ThemeData(
          fontFamily: 'EvilEmpire',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(103, 161, 197, 1),
          ),
          appBarTheme: const AppBarTheme(
              backgroundColor: Color.fromRGBO(103, 161, 197, 1)),
          scaffoldBackgroundColor: const Color.fromRGBO(226, 237, 244, 1),
          bottomSheetTheme: const BottomSheetThemeData(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Color.fromRGBO(226, 237, 244, 1),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            // type: BottomNavigationBarType.fixed,
            selectedIconTheme: IconThemeData(
              size: 39,
              color: Color.fromRGBO(103, 161, 197, 1),
            ),
            unselectedIconTheme: IconThemeData(
              size: 39,
              color: Color.fromRGBO(221, 221, 221, 1),
            ),
          ),
        ),

        ///
        darkTheme: ThemeData(
          fontFamily: 'EvilEmpire',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(103, 161, 197, 1),
          ),
          scaffoldBackgroundColor: const Color.fromRGBO(24, 29, 31, 1),
          bottomSheetTheme: const BottomSheetThemeData(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Color.fromRGBO(24, 29, 31, 1),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF394861),
            surfaceTintColor: Colors.transparent,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color(0xFF21272B),
            showUnselectedLabels: false,
            showSelectedLabels: false,
            selectedIconTheme: IconThemeData(
              size: 39,
              color: Color(0xFF394861),
            ),
            unselectedIconTheme: IconThemeData(
              size: 39,
              color: Color.fromRGBO(221, 221, 221, 1),
            ),
          ),
        ),

        ///
        home: StreamBuilder(
            stream: accessTokenStream.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const MobilePrimaryPage();
              } else {
                Future(() {
                  ref
                      .watch(splashPageCurrentIndexProvider.notifier)
                      .setIndex(0);
                });
                return const MobileSplashPage();
              }
            }),
      ),
    );
  }
}

// ///
// class ResponsiveLayout extends StatelessWidget {
//   final Widget mobileScaffold;
//   final Widget tabletScaffold;

//   const ResponsiveLayout({
//     super.key,
//     required this.mobileScaffold,
//     required this.tabletScaffold,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//         // layout builder keeps tracks of the constraints for a window
//         builder: (context, constraints) {
//       if (constraints.maxWidth < 600) {
//         return mobileScaffold;
//       } else {
//         return tabletScaffold;
//       }
//     });
//   }
// }
