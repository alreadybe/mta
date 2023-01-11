import 'dart:convert';

import 'package:mta_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Future<void> setUser(User user) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('USER', jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    final sp = await SharedPreferences.getInstance();
    final rawUser = sp.getString('USER');
    if (rawUser == null) return null;
    final jsonUser = json.decode(rawUser);
    return User.fromJson(Map.castFrom(jsonUser as Map));
  }
}
