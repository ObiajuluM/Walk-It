import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrimaryPageCurrentIndex extends StateNotifier<int> {
  PrimaryPageCurrentIndex() : super(0);

  setIndex(int index) {
    state = index;
  }
}

final primaryPageCurrentIndexProvider =
    StateNotifierProvider<PrimaryPageCurrentIndex, int>((ref) {
  return PrimaryPageCurrentIndex();
});

///
class ThemeModeState extends StateNotifier<ThemeMode> {
  ThemeModeState() : super(ThemeMode.light);

  changeState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // set state in UI
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    // set state in local storage
    state == ThemeMode.dark
        ? await prefs.setBool('night', true)
        : await prefs.setBool('night', false);

    // print(" is dark 1: ${prefs.getBool('night')}");
  }

  toDark() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // set state in UI
    state = ThemeMode.dark;

    // set state in local storage
    state == ThemeMode.dark
        ? await prefs.setBool('night', true)
        : await prefs.setBool('night', false);

    // print(" is dark 2: ${prefs.getBool('night')}");
  }
}

final ThemeModeStateProvider =
    StateNotifierProvider<ThemeModeState, ThemeMode>((ref) {
  return ThemeModeState();
});

// the 2 functions below to check if app is in dark mode


