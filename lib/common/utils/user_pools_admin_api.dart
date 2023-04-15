import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'dart:convert';

/// Handy Library Admin functions
/// Used by SaaS product owner
///
class UserPoolsAdminAPI {
  static Future<List<String>> listAllGroups() async {
    // TODO: check if user group is Admin
    List<String> groups = [];
    try {
      final options = RestOptions(path: '/listGroups');
      final restOperation = Amplify.API.get(restOptions: options);
      final response = await restOperation.response;
      debugPrint('listAllGroups(): \n${response.body}');

      String jsonString = response.body;
      Map<String, dynamic> groupsJsonObj = json.decode(jsonString);
      final group1 = groupsJsonObj['Groups'][0]['GroupName'];
      final userPoolId = groupsJsonObj['Groups'][0]['UserPoolId'];
      debugPrint("group1 name is: $group1, userPoolId is $userPoolId");
    } catch (e) {
      debugPrint('error: $e');
    }
    return groups;
  }
}
