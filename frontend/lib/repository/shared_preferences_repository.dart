import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  static String tokenKey = 'token';

  static Future<String?> getUserToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString(tokenKey);
    return userToken != '' ? userToken : null;
  }

  static Future<void> setUserToken(String userToken) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, userToken);
  }

  static Future<void> eraseUserToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, '');
  }
  
}