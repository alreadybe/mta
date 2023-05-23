import 'dart:convert';

import 'package:mta_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Future<void> setUser(UserModel user) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('USER', jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final sp = await SharedPreferences.getInstance();
    final rawUser = sp.getString('USER');
    if (rawUser == null) return null;
    final jsonUser = json.decode(rawUser);
    return UserModel.fromJson(Map.castFrom(jsonUser as Map));
  }

  Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
