

import 'package:shared_preferences/shared_preferences.dart';

class SessionData {
  static bool? isLogin;
  static String? emailId;
  //static String? password;

  static Future<void> storeSessionData(
      {required bool loginData, required String emailId}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

// SET DATA
    sharedPreferences.setBool("loginSession", loginData);
    sharedPreferences.setString("email", emailId);
    //sharedPreferences.setString("Password",password);

// GET DATA
    getSessionData();
  }

  static Future<void> getSessionData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isLogin = sharedPreferences.getBool("loginSession") ?? false;
    emailId = sharedPreferences.getString("email") ?? "";
    //password=sharedPreferences.getString("Password") ?? "";
  }
}