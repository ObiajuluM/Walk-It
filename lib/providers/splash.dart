import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unique_name_generator/unique_name_generator.dart';

class SplashPageCurrentIndex extends StateNotifier<int> {
  SplashPageCurrentIndex() : super(0);

  setIndex(int index) {
    state = index;
  }
}

final splashPageCurrentIndexProvider =
    StateNotifierProvider<SplashPageCurrentIndex, int>((ref) {
  return SplashPageCurrentIndex();
});

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

int returnAppropriateIntForName(String name) {
  return int.tryParse(
      // wordToIntegerList(name.length >= 8 ? name.substring(0, 9) : name)
      wordToIntegerList(name).join()) ?? 0;
}

var ung = UniqueNameGenerator(
  dictionaries: [adjectives, animals],
  style: NameStyle.capital,
  separator: ' ',
);
