import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

StreamController<String?> accessTokenStream = StreamController<String?>();

/// add access_token to flutter secure local storage
Future<void> writeAccessTokenToLocal(String accessToken) async {
  const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  storage.write(key: "access_token", value: accessToken);
  accessTokenStream.add("");
}

/// retrieve access token from db
Future<String?> retrieveAccessTokenFromLocal() async {
  String? accessToken;

  const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  accessToken = await storage.read(key: "access_token");
  // storage.registerListener(key: key, listener: listener);
  accessTokenStream.add("");

  return accessToken;
}

/// remove access_token to flutter secure local storage
clearAccessTokenFromLocal() async {
  const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  await storage.delete(key: "access_token");
  accessTokenStream.add(null);
}








// class AccessTokenProvider extends StateNotifier<String?> {
//   AccessTokenProvider() : super(null);

//   Future<void> setData(String accessToken) async {
//     const storage = FlutterSecureStorage(
//         aOptions: AndroidOptions(
//       encryptedSharedPreferences: true,
//     ));

//     state = accessToken;
//     storage.write(key: "access_token", value: accessToken);
//   }
// }

// final accessTokenProvider =
//     StateNotifierProvider<AccessTokenProvider, String?>((ref) {
//   return AccessTokenProvider();
// });
