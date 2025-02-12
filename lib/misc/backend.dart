import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:walk_it/misc/access_token.dart';
import 'package:walk_it/misc/backend_model.dart';

//  TODO: PRACTICE SECURE KEY STORAGE AND PUT SENSITIVE VARIABLES IN AN ENV FILE
class WalkItBackendAuth {
  // final String connectToBackendUrl;
  // final String? djangoClientId;
  // final String? googleAccessToken;

  // WalkItBackendAuth({
  //   required this.connectToBackendUrl,
  //   this.djangoClientId,
  // this.googleAccessToken,
  // });

  // sign in
  Future<String> signInWithCredential(
      {required String djangoClientId,
      required String? googleAccessToken}) async {
    // http://uri:port/auth/convert-token
    final connectTo = Uri.parse("http://192.168.1.61:8080/auth/convert-token");
    final headers = <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final data =
        "grant_type=convert_token&client_id=$djangoClientId&backend=google-oauth2&token=$googleAccessToken";
    final result = await http.post(
      connectTo,
      headers: headers,
      body: data,
    );
    if (result.statusCode == 200) {
      final userData = jsonDecode(result.body) as Map<String, dynamic>;
      //  do the access token assignment here
      log("BACKEND SIGN IN SUCCESS");
      //  write token to local storage
      await writeAccessTokenToLocal(userData["access_token"]);
      return userData["access_token"];
    } else {
      throw Exception(result.body);
    }
  }

//  delete all refresh code and all access tokens and clear storage
  signOut(
    String accessToken,
    String djangoClientId,
    String accessDeleteBackendUrl,
    String refreshDeleteBackendUrl,
  ) async {
    // http://localhost:8000/auth/invalidate-sessions - access tokens
    // 'http://localhost:8000/auth/invalidate-refresh-tokens' - refresh tokens
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final data = 'client_id=$djangoClientId';

    // remove refresh token
    final rurl = Uri.parse(refreshDeleteBackendUrl);
    final deleteRefreshTokens =
        await http.post(rurl, headers: headers, body: data);

    //

    // remove access token
    final aurl = Uri.parse(accessDeleteBackendUrl);
    final deleteAccessTokens =
        await http.post(aurl, headers: headers, body: data);
    //

    // log the result code
    log(deleteRefreshTokens.statusCode.toString());
    log(deleteAccessTokens.statusCode.toString());

    // then clear access token from local
    await clearAccessTokenFromLocal();

    log("sign out sucess");
  }
}

Future<WalkUserBackend> getUser() async {
  // create params
  final access_token = await retrieveAccessTokenFromLocal();
  final url = Uri.parse("http://192.168.1.61:8080/user/");

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
  };

  // make request
  final response = await http.get(url, headers: headers);

// parse response
  if (response.statusCode == 200) {
    log("GET USER REQUEST SUCCESSFUL");
    final responseData = WalkUserBackend.fromJson(jsonDecode(response.body));
    return responseData;
  } else {
    log("GET USER REQUEST FAILED");
    log(response.body);
    throw Exception(response.body);
  }
}

// "display_name",
// "gender",
// "dob",
// "invited_by",
// "dob",
// "long",
// "lat",

Future<void> modifyUser(Map<String, dynamic> data) async {
  // create params
  final access_token = await retrieveAccessTokenFromLocal();
  final url = Uri.parse("http://192.168.1.61:8080/user/");
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
  };
  final body = jsonEncode(data);

  // make request
  final response = await http.patch(url, headers: headers, body: body);

  // parse response
  if (response.statusCode == 200) {
    log("MODIFY USER REQUEST SUCCESSFUL");
  } else {
    log("MODIFY USER REQUEST FAILED");
    log(response.body);
    throw Exception(response.body);
  }
}

Future<void> uploadSteps(int steps) async {
  // create params
  final access_token = await retrieveAccessTokenFromLocal();
  final url = Uri.parse("http://192.168.1.61:8080/steps-today/");
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
  };
  final body = jsonEncode({"steps": steps});

  // make request
  final response = await http.post(url, headers: headers, body: body);

  // parse response
  if (response.statusCode == 200) {
    log("POST USER STEPS SUCCESSFUL");
  } else {
    log("POST USER STEPS FAILED");
    log(response.body);
    throw Exception(response.body);
  }
}

Future<List<LeaderBoardBackend>> getLeaderBoard() async {
  // create params
  final access_token = await retrieveAccessTokenFromLocal();
  // final url = Uri.parse("http://127.0.0.1:8080/steps-today/");
  final url = Uri.parse("http://192.168.1.61:8080/steps-today/");
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
  };

  // make request
  final response = await http.get(url, headers: headers);

  // parse response
  if (response.statusCode == 200) {
    log("GET LEADERBOARD SUCCESSFUL");
    Map<String, dynamic> responseMap = jsonDecode(response.body);
    List responseList = responseMap["data"];
    final leaders = responseList.map((item) {
      return LeaderBoardBackend.fromJson(item);
    }).toList();
    return leaders;
  } else {
    log("GET LEADERBOARD FAILED");
    log(response.body);
    throw Exception(response.body);
  }
}

Future<List<ClaimBackend>> getUserClaims() async {
  // create params
  final access_token = await retrieveAccessTokenFromLocal();
  final url = Uri.parse("http://192.168.1.61:8080/user-claims/");
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
  };

  // make request
  final response = await http.get(url, headers: headers);

  // parse response
  if (response.statusCode == 200) {
    log("GET USER CLAIMS SUCCESSFUL");
    List<dynamic> responseMap = jsonDecode(response.body);
    final responseList =
        responseMap.map((item) => ClaimBackend.fromJson(item)).toList();
    return responseList;
  } else {
    log("GET USER CLAIMS FAILED");
    log(response.body);
    throw Exception(response.body);
  }
}

// get the people the user invited
Future<List<WalkUserBackend>> getUserInvites() async {
  // create params
  final access_token = await retrieveAccessTokenFromLocal();
  final url = Uri.parse("http://192.168.1.61:8080/user-invites/");
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
  };

  // make request
  final response = await http.get(url, headers: headers);

  // parse response
  if (response.statusCode == 200) {
    log("GET USER INVITES SUCCESSFUL");
    List<dynamic> responseMap = jsonDecode(response.body);
    final responseList =
        responseMap.map((item) => WalkUserBackend.fromJson(item)).toList();
    return responseList;
  } else {
    log("GET USER INVITES FAILED");
    log(response.body);
    throw Exception(response.body);
  }
}

//  get the user steps
Future<Map<String, dynamic>> getUserLastRecordedSteps() async {
  // create params
  final access_token = await retrieveAccessTokenFromLocal();
  final url = Uri.parse("http://192.168.1.61:8080/user-step/");
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $access_token',
  };

  // make request
  final response = await http.get(url, headers: headers);

  // parse response
  if (response.statusCode == 200) {
    log("GET USER LAST STEPS SUCCESSFUL");
    Map<String, dynamic> responseMap = jsonDecode(response.body);

    return responseMap;
  } else {
    log("GET USER LAST STEPS FAILED");
    log(response.body);
    throw Exception(response.body);
  }
}

class BackendUserProvider extends StateNotifier<WalkUserBackend> {
  BackendUserProvider() : super(WalkUserBackend());

  Future<void> getData() async {
    final user = await getUser();
    state = user;
  }
}

final backendUserProvider =
    StateNotifierProvider<BackendUserProvider, WalkUserBackend>((ref) {
  return BackendUserProvider();
});
