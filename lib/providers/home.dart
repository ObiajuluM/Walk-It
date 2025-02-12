import 'package:health/health.dart';
import 'package:riverpod/riverpod.dart';

class Greeting extends StateNotifier<String> {
  Greeting() : super("Good Day!");

  greet() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      state = 'Good Morning!';
    } else if (hour < 17) {
      state = 'Good Afternoon!';
    } else {
      state = 'Good Evening!';
    }
  }
}

final greetingProvider = StateNotifierProvider<Greeting, String>((ref) {
  return Greeting();
});

/// Health Data
class HealthDataProvider extends StateNotifier<Map<String, int>> {
  HealthDataProvider() : super({"steps": 0000});

  getData() async {
    try {
      Health().configure(useHealthConnectIfAvailable: true);

      Health healthFactory = Health();
      bool hasPermission = false;

      const List<HealthDataType> kdataTypes = [HealthDataType.STEPS];

      // get steps for today (i.e., since midnight)
      // today
      final now = DateTime.now();
      // midnight
      final midnight = DateTime(now.year, now.month, now.day);

      hasPermission = await healthFactory.hasPermissions(kdataTypes) ?? false;
      // await Permission.activityRecognition.request();
      // await Permission.notification.request();
      // await Permission.scheduleExactAlarm.request();
      // await Permission.ignoreBatteryOptimizations.request();
      // await Permission.location.request();

      if (hasPermission) {
        /// get steps and set state
        state = {
          "steps":
              await healthFactory.getTotalStepsInInterval(midnight, now) ?? 0000
        };
      } else {
        hasPermission =
            await healthFactory.requestAuthorization(kdataTypes).then((value) {
          getData();
          return true;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

final healthDataProvider =
    StateNotifierProvider<HealthDataProvider, Map<String, int>>((ref) {
  return HealthDataProvider();
});

///
class HistoryDataProvider extends StateNotifier<Map<DateTime, int>> {
  HistoryDataProvider() : super({});

  setData() async {
    Map<DateTime, int> stepMap = {};
    Health healthFactory = Health();

    try {
      for (var i = 0; i < 30; i++) {
        final thatMidnight = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).subtract(Duration(days: i, hours: 23, minutes: 60));
        final thatDay = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ).subtract(Duration(days: i, hours: 0, minutes: 0));

        int step = await healthFactory.getTotalStepsInInterval(
                thatMidnight, thatDay) ??
            0;

        stepMap[thatMidnight] = step;
      }
    } catch (e) {
      state = {DateTime.now(): 0};
      print("Step history error ${e}");
    }

    state = stepMap;
  }
}

final historyDataProvider =
    StateNotifierProvider<HistoryDataProvider, Map<DateTime, int>>((ref) {
  return HistoryDataProvider();
});

// ///
// getHistoricalSteps() async {
//   Map<DateTime, int> stepMap = {};
//   HealthFactory healthFactory = HealthFactory();

//   for (var i = 0; i < 30; i++) {
//     final thatMidnight =
//         DateTime.now().subtract(Duration(days: 30, hours: 23, minutes: 59));
//     final thatDay =
//         DateTime.now().subtract(Duration(days: 30, hours: 0, minutes: 0));

//     int step =
//         await healthFactory.getTotalStepsInInterval(thatMidnight, thatDay) ?? 0;

//     stepMap[thatMidnight] = step;
//   }

//   return stepMap;
// }

///
///
///
///
///
///
///

Future<int> notificationhealthData() async {
  int healthSteps = 0;
  try {
    Health().configure(useHealthConnectIfAvailable: true);

    Health healthFactory = Health();
    bool hasPermission = false;

    const List<HealthDataType> kdataTypes = [
      HealthDataType.STEPS,
    ];

    // get steps for today (i.e., since midnight)
    // today
    final now = DateTime.now();
    // midnight
    final midnight = DateTime(now.year, now.month, now.day);

    hasPermission = await healthFactory.hasPermissions(kdataTypes) ?? false;

    if (hasPermission) {
      // get steps
      int steps_ =
          await healthFactory.getTotalStepsInInterval(midnight, now) ?? 0;
      var healthSteps = steps_.toString();

      print("steps: $healthSteps");
    } else {
      hasPermission = await healthFactory.requestAuthorization(kdataTypes);
    }
  } catch (e) {
    print("error on bg step get $e");
  }
  return healthSteps;
}

double goalPercent(int steps, int goal) {
  final gDouble = steps / goal;
  return gDouble >= 1 ? 1 : double.parse(gDouble.toStringAsFixed(2));
}

/// functions to convert name to int
const String lowercaseAlphabet = 'abcdefghijklmnopqrstuvwxyz';

Map<String, int> getAlphabetMap() {
  const int alphabetLength = lowercaseAlphabet.length;
  Map<String, int> alphabetMap = {};
  for (int i = 0; i < alphabetLength; i++) {
    final letter = lowercaseAlphabet[i];
    final int code = letter.codeUnitAt(0) - 'a'.codeUnitAt(0) + 1;
    alphabetMap[letter.toUpperCase()] = code;
  }
  return alphabetMap;
}

List<int> wordToIntegerList(String word) {
  final alphabetMap = getAlphabetMap();

  List<int> integerList = [];
  for (int i = 0; i < word.length; i++) {
    final letter = word.toUpperCase()[i]; // Convert to uppercase
    if (alphabetMap.containsKey(letter)) {
      integerList.add(alphabetMap[letter]!);
    } else {
      // Handle non-alphabetic characters (optional)
      // You can throw an exception, add a special value, or ignore them
    }
  }
  return integerList;
}
