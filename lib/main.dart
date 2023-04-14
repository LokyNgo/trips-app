import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_trips_planner/models/ModelProvider.dart';
import 'package:amplify_trips_planner/trips_planner_app.dart';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'amplifyconfiguration.dart';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await _configureAmplify();
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify configuration failed.');
  }

  runApp(
    const ProviderScope(
      child: TripsPlannerApp(),
    ),
  );
}

Future<void> _configureAmplify() async {
  // TODO: change cache strategy
  // final dataStorePlugin =

  await Amplify.addPlugins([
    AmplifyAuthCognito(),
    AmplifyDataStore(
      modelProvider: ModelProvider.instance,
    ),
    AmplifyAPI(),
    AmplifyStorageS3()
  ]);
  await Amplify.configure(amplifyconfig);
  getUserInfo();
  fetchAuthSession();
}

Future<String> getUserInfo() async {
  try {
    final mAuth = Amplify.Auth;
    final authUser = await mAuth.getCurrentUser();
    final userName = authUser.username;
    final userId = authUser.userId;
    debugPrint('username is $userName, userId is $userId');
    return userName;
  } catch (e) {
    print('Error getting authenticated user: $e');
    return "";
  }
}

Future<void> fetchAuthSession() async {
  try {
    final result = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    ).timeout(
      const Duration(seconds: 5),
    );
    final currentSession = result as CognitoAuthSession;
    String accessToken = currentSession.userPoolTokens?.accessToken ?? '';
    String identityId = currentSession.identityId ?? '';
    safePrint('accessToken: $accessToken');
    safePrint('identityId: $identityId');
  } catch (e) {
    safePrint('$e');
  }
}
