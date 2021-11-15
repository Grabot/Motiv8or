import 'package:shared_preferences/shared_preferences.dart';


class HelperFunction {
  static String testStringKey = "testString";

  static Future<bool> setTestString(String testString) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(testStringKey, testString);
  }

  static Future<String?> getTestString() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(testStringKey);
  }
}